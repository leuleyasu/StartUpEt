import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../models/notification_info.dart';
import '../../../core/api_client.dart';
import '../../../core/api_endpoints.dart';
import '../../../core/api_exceptions.dart';

class NotificationService {
  final ApiClient _client;
  StreamController<SseEvent>? _eventController;
  StreamSubscription? _rawStreamSubscription;

  NotificationService(this._client);

  Stream<SseEvent> subscribeToEvents() {
    if (_eventController == null || _eventController!.isClosed) {
      _eventController = StreamController<SseEvent>.broadcast(
        onListen: _startSseStream,
        onCancel: _stopSseStream,
      );
    }
    return _eventController!.stream;
  }

  Stream<NotificationInfo> subscribeToNotifications() {
    return subscribeToEvents()
        .where((e) => e.isNotification)
        .map((e) => e.toNotification())
        .where((n) => n != null)
        .cast<NotificationInfo>();
  }

  void _startSseStream() async {
    try {
      final response = await _client.get(
        ApiEndpoints.notificationsStream,
        options: Options(
          responseType: ResponseType.stream,
          headers: {
            'Accept': 'text/event-stream',
            'Cache-Control': 'no-cache',
          },
        ),
      );

      final responseBody = response.data;
      if (responseBody is ResponseBody) {
        String currentEvent = 'message';
        final buffer = StringBuffer();

        _rawStreamSubscription = responseBody.stream
            .cast<List<int>>()
            .transform(utf8.decoder)
            .transform(const LineSplitter())
            .listen(
          (line) {
            final trimmed = line.trim();
            if (trimmed.isEmpty) {
              if (buffer.isNotEmpty) {
                final raw = buffer.toString();
                buffer.clear();
                dynamic parsedData = raw;
                try {
                  parsedData = jsonDecode(raw);
                } catch (_) {}

                _eventController?.add(
                  SseEvent(
                    eventType: currentEvent,
                    data: parsedData,
                    rawData: raw,
                  ),
                );
                currentEvent = 'message';
              }
            } else if (trimmed.startsWith(':')) {
              // SSE comment or heartbeat (e.g. ": heartbeat")
              _eventController?.add(
                const SseEvent(
                  eventType: 'heartbeat',
                  data: 'heartbeat',
                ),
              );
            } else if (trimmed.startsWith('event:')) {
              currentEvent = trimmed.substring(6).trim();
            } else if (trimmed.startsWith('data:')) {
              final dataContent = trimmed.substring(5).trim();
              if (buffer.isNotEmpty) buffer.write('\n');
              buffer.write(dataContent);
            }
          },
          onError: (err) {
            _eventController?.addError(
              ApiException(message: 'Notification stream connection error: $err'),
            );
          },
          onDone: () {
            // Reconnection could be handled here or by callers
          },
          cancelOnError: false,
        );
      }
    } catch (e) {
      _eventController?.addError(
        ApiException(message: 'Failed to start notification stream: $e'),
      );
    }
  }

  void _stopSseStream() {
    _rawStreamSubscription?.cancel();
    _rawStreamSubscription = null;
  }

  void dispose() {
    _stopSseStream();
    _eventController?.close();
    _eventController = null;
  }

  Future<Either<ApiException, NotificationInfo>> streamNotifications() async {
    try {
      final response = await _client.get(
        ApiEndpoints.notificationsStream,
        options: Options(responseType: ResponseType.stream),
      );
      if (response.data is Map<String, dynamic>) {
        return Right(
          NotificationInfo.fromJson(response.data as Map<String, dynamic>),
        );
      }
      return const Right(
        NotificationInfo(
          id: 'connected_event',
          title: 'Connected',
          message: 'Notifications stream connected',
          type: 'info',
        ),
      );
    } on DioException catch (e) {
      return Left(_error(e));
    } catch (e) {
      return Left(ApiException(message: 'Stream failed: $e'));
    }
  }

  ApiException _error(DioException e) => e.error is ApiException
      ? e.error as ApiException
      : ApiException(message: e.message ?? 'Stream failed');
}
