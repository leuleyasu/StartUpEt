import 'package:dio/dio.dart';

import 'api_endpoints.dart';

class MockInterceptor extends Interceptor {
  final bool enableOfflineMock;

  MockInterceptor({this.enableOfflineMock = true});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!enableOfflineMock) {
      return handler.next(options);
    }

    final path = options.path;

    // Simulate short network delay
    await Future.delayed(const Duration(milliseconds: 300));
    if (path.contains(ApiEndpoints.authCallbackCredentials) ||
          path.contains(ApiEndpoints.authRegister)) {
        final reqData = options.data is Map ? options.data as Map : {};
        final name = reqData['name'] ?? reqData['username'] ?? 'Startup Founder';
        final email = reqData['email'] ?? reqData['username'] ?? 'founder@startupet.et';

        return handler.resolve(
          Response(
            requestOptions: options,
            statusCode: 200,
            data: {
              'apiKey': 'mock_credentials_api_key_2026',
              'user': {
                'id': 'user_002',
                'name': name,
                'email': email,
                'role': 'Startup Founder',
              },
            },
          ),
        );
      }

      if (path.contains(ApiEndpoints.authCallbackFayda)) {
        return handler.resolve(
          Response(
            requestOptions: options,
            statusCode: 200,
            data: {
              'apiKey': 'mock_fayda_api_key_2026',
              'user': {
                'id': 'user_001',
                'name': 'Abebe Bikila',
                'email': 'abebe.bikila@startupet.et',
                'role': 'Startup Founder',
                'nationalId': 'ET-FAYDA-987654321',
                'tin': '0098765432',
              },
            },
          ),
        );
      }

      if (path.contains(ApiEndpoints.protected)) {
        return handler.resolve(
          Response(
            requestOptions: options,
            statusCode: 200,
            data: {
              'id': 'user_001',
              'name': 'Abebe Bikila',
              'email': 'abebe.bikila@startupet.et',
              'role': 'Startup Founder',
              'nationalId': 'ET-FAYDA-987654321',
              'tin': '0098765432',
            },
          ),
        );
      }

      if (path.contains(ApiEndpoints.startupMyStatus)) {
        return handler.resolve(
          Response(
            requestOptions: options,
            statusCode: 200,
            data: {
              'id': 'su_101',
              'name': 'AgriTech Ethiopia',
              'sector': 'Agriculture & AI',
              'stage': 'Growth / Series A',
              'status': 'VERIFIED',
              'tin': '0098765432',
              'establishedYear': 2023,
              'city': 'Addis Ababa',
            },
          ),
        );
      }

      if (path.contains(ApiEndpoints.events)) {
        return handler.resolve(
          Response(
            requestOptions: options,
            statusCode: 200,
            data: [
              {
                'id': 'evt_1',
                'title': 'Ethiopia Startup Summit 2026',
                'date': '2026-08-15T09:00:00Z',
                'location': 'Millennium Hall, Addis Ababa',
                'category': 'Conference',
                'organizer': 'Ministry of Innovation & Technology',
                'isRegistered': true,
              },
              {
                'id': 'evt_2',
                'title': 'FinTech & Digital Payment Hackathon',
                'date': '2026-08-28T10:00:00Z',
                'location': 'ICT Park, Addis Ababa',
                'category': 'Hackathon',
                'organizer': 'Ethio Telecom & StartupEt',
                'isRegistered': false,
              },
              {
                'id': 'evt_3',
                'title': 'Venture Capital & Angel Investor Pitch Night',
                'date': '2026-09-05T18:00:00Z',
                'location': 'Skylight Hotel, Addis Ababa',
                'category': 'Networking',
                'organizer': 'Ethiopian Business Angels Network',
                'isRegistered': false,
              },
            ],
          ),
        );
      }

      if (path.contains(ApiEndpoints.funding)) {
        return handler.resolve(
          Response(
            requestOptions: options,
            statusCode: 200,
            data: [
              {
                'id': 'fnd_1',
                'title': 'National Innovation Grant Program',
                'amount': 'ETB 2,500,000',
                'deadline': '2026-09-30',
                'eligibility': 'Early-stage tech startups with Fayda ID',
                'status': 'OPEN',
              },
              {
                'id': 'fnd_2',
                'title': 'GreenTech & Renewable Energy Challenge',
                'amount': '\$50,000 USD',
                'deadline': '2026-10-15',
                'eligibility': 'ClimateTech startups in East Africa',
                'status': 'OPEN',
              },
              {
                'id': 'fnd_3',
                'title': 'Women Entrepreneurs Technology Fund',
                'amount': 'ETB 1,800,000',
                'deadline': '2026-11-01',
                'eligibility': 'Female-led Ethiopian tech enterprises',
                'status': 'OPEN',
              },
            ],
          ),
        );
      }

      if (path.contains(ApiEndpoints.applications)) {
        return handler.resolve(
          Response(
            requestOptions: options,
            statusCode: 200,
            data: [
              {
                'id': 'app_001',
                'title': 'Startup Label Certification Application',
                'submittedDate': '2026-07-10',
                'status': 'UNDER_REVIEW',
                'step': 'Document Verification',
              },
              {
                'id': 'app_002',
                'title': 'National Innovation Grant 2026',
                'submittedDate': '2026-06-20',
                'status': 'APPROVED',
                'step': 'Final Grant Disbursement',
              },
            ],
          ),
        );
      }

      if (path.contains(ApiEndpoints.ecosystemSpaces)) {
        return handler.resolve(
          Response(
            requestOptions: options,
            statusCode: 200,
            data: [
              {
                'id': 'spc_1',
                'name': 'ICT Park Innovation Center',
                'location': 'Bole, Addis Ababa',
                'capacity': '150 seats',
                'availableDeskCount': 12,
                'amenities': ['High-speed Wi-Fi', 'Meeting Rooms', 'Cafeteria'],
              },
              {
                'id': 'spc_2',
                'name': 'Addis Tech Hub & Incubator',
                'location': 'Kazanchis, Addis Ababa',
                'capacity': '80 seats',
                'availableDeskCount': 5,
                'amenities': ['Maker Lab', 'Mentorship Desk', '24/7 Access'],
              },
            ],
          ),
        );
      }

      if (path.contains(ApiEndpoints.verifyNationalId) ||
          path.contains(ApiEndpoints.verifyTin)) {
        return handler.resolve(
          Response(
            requestOptions: options,
            statusCode: 200,
            data: {
              'verified': true,
              'message': 'Verification successfully completed with Fayda registry.',
            },
          ),
        );
      }

      // Default fallback response for any other GET/POST endpoint
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: {'status': 'success', 'message': 'Mock response for $path'},
        ),
      );
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (enableOfflineMock) {
      // If live API connection fails (e.g. socket/connection error), fallback gracefully to mock response
      final options = err.requestOptions;
      onRequest(options, RequestInterceptorHandler());
    } else {
      handler.next(err);
    }
  }
}
