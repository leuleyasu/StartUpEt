import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'core/api_client.dart';
import 'core/theme/cubit/theme_cubit.dart';
import 'core/theme/theme_service.dart';
import 'features/application/bloc/application_bloc.dart';
import 'features/application/services/application_service.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/services/auth_service.dart';
import 'features/certificate/bloc/certificate_bloc.dart';
import 'features/certificate/services/certificate_service.dart';
import 'features/cron/bloc/cron_bloc.dart';
import 'features/cron/services/cron_service.dart';
import 'features/ecosystem/bloc/ecosystem_bloc.dart';
import 'features/ecosystem/services/ecosystem_service.dart';
import 'features/event/bloc/event_bloc.dart';
import 'features/event/services/event_service.dart';
import 'features/file/bloc/file_bloc.dart';
import 'features/file/services/file_service.dart';
import 'features/funding/bloc/funding_bloc.dart';
import 'features/funding/services/funding_service.dart';
import 'features/notification/bloc/notification_bloc.dart';
import 'features/notification/services/notification_service.dart';
import 'features/pitch/bloc/pitch_bloc.dart';
import 'features/pitch/services/pitch_service.dart';
import 'features/report/bloc/report_bloc.dart';
import 'features/report/services/report_service.dart';
import 'features/startup/bloc/startup_bloc.dart';
import 'features/startup/services/startup_service.dart';
import 'features/verification/bloc/verification_bloc.dart';
import 'features/verification/services/verification_service.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  final secureStorage = const FlutterSecureStorage();
  sl.registerLazySingleton<FlutterSecureStorage>(() => secureStorage);

  final apiClient = ApiClient(secureStorage);
  sl.registerLazySingleton<ApiClient>(() => apiClient);

  sl.registerLazySingleton<AuthService>(() => AuthService(sl()));
  sl.registerLazySingleton<StartupService>(() => StartupService(sl()));
  sl.registerLazySingleton<CertificateService>(() => CertificateService(sl()));
  sl.registerLazySingleton<EcosystemService>(() => EcosystemService(sl()));
  sl.registerLazySingleton<EventService>(() => EventService(sl()));
  sl.registerLazySingleton<FileService>(() => FileService(sl()));
  sl.registerLazySingleton<FundingService>(() => FundingService(sl()));
  sl.registerLazySingleton<ReportService>(() => ReportService(sl()));
  sl.registerLazySingleton<NotificationService>(
    () => NotificationService(sl()),
  );
  sl.registerLazySingleton<VerificationService>(
    () => VerificationService(sl()),
  );
  sl.registerLazySingleton<ApplicationService>(() => ApplicationService(sl()));
  sl.registerLazySingleton<PitchService>(() => PitchService(sl()));
  sl.registerLazySingleton<CronService>(() => CronService(sl()));
  sl.registerLazySingleton<ThemeService>(() => ThemeServiceImpl(sl()));

  sl.registerFactory<ThemeCubit>(() => ThemeCubit(sl()));
  sl.registerFactory<AuthBloc>(() => AuthBloc(sl(), sl()));
  sl.registerFactory<StartupBloc>(() => StartupBloc(sl()));
  sl.registerFactory<CertificateBloc>(() => CertificateBloc(sl()));
  sl.registerFactory<EcosystemBloc>(() => EcosystemBloc(sl()));
  sl.registerFactory<EventBloc>(() => EventBloc(sl()));
  sl.registerFactory<FileBloc>(() => FileBloc(sl()));
  sl.registerFactory<FundingBloc>(() => FundingBloc(sl()));
  sl.registerFactory<NotificationBloc>(() => NotificationBloc(sl()));
  sl.registerFactory<VerificationBloc>(() => VerificationBloc(sl()));
  sl.registerFactory<ApplicationBloc>(() => ApplicationBloc(sl()));
  sl.registerFactory<PitchBloc>(() => PitchBloc(sl()));
  sl.registerFactory<CronBloc>(() => CronBloc(sl()));
  sl.registerFactory<ReportBloc>(() => ReportBloc(sl()));
}
