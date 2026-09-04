import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'core/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/cubit/theme_cubit.dart';
import 'core/theme/cubit/theme_state.dart';
import 'features/application/bloc/application_bloc.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/bloc/auth_event.dart';
import 'features/auth/bloc/auth_state.dart';
import 'features/auth/presentation/screens/home_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/certificate/bloc/certificate_bloc.dart';
import 'features/cron/bloc/cron_bloc.dart';
import 'features/ecosystem/bloc/ecosystem_bloc.dart';
import 'features/event/bloc/event_bloc.dart';
import 'features/file/bloc/file_bloc.dart';
import 'features/funding/bloc/funding_bloc.dart';
import 'features/notification/bloc/notification_bloc.dart';
import 'features/onboarding/presentation/screens/onboarding_screen.dart';
import 'features/pitch/bloc/pitch_bloc.dart';
import 'features/report/bloc/report_bloc.dart';
import 'features/startup/bloc/startup_bloc.dart';
import 'features/verification/bloc/verification_bloc.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initDependencies();

  final storage = const FlutterSecureStorage();
  final apiKey = await storage.read(key: 'api_key');
  final hasToken = apiKey != null && apiKey.isNotEmpty;
  final hasSeenOnboarding =
      (await storage.read(key: OnboardingScreen.hasSeenOnboardingKey)) ==
          'true';

  runApp(StartupetApp(
    hasStoredToken: hasToken,
    hasSeenOnboarding: hasSeenOnboarding,
  ));
}

class StartupetApp extends StatelessWidget {
  final bool hasStoredToken;
  final bool hasSeenOnboarding;

  const StartupetApp({
    super.key,
    bool? isAuthenticated,
    bool? hasStoredToken,
    this.hasSeenOnboarding = false,
  }) : hasStoredToken = hasStoredToken ?? isAuthenticated ?? false;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) {
            final bloc = di.sl<AuthBloc>();
            if (hasStoredToken) {
              bloc.add(const AuthCheckRequested());
            }
            return bloc;
          },
        ),
        BlocProvider<StartupBloc>(
          lazy: true,
          create: (context) => di.sl<StartupBloc>(),
        ),
        BlocProvider<ApplicationBloc>(
          lazy: true,
          create: (context) => di.sl<ApplicationBloc>(),
        ),
        BlocProvider<FundingBloc>(
          lazy: true,
          create: (context) => di.sl<FundingBloc>(),
        ),
        BlocProvider<EventBloc>(
          lazy: true,
          create: (context) => di.sl<EventBloc>(),
        ),
        BlocProvider<EcosystemBloc>(
          lazy: true,
          create: (context) => di.sl<EcosystemBloc>(),
        ),
        BlocProvider<CertificateBloc>(
          lazy: true,
          create: (context) => di.sl<CertificateBloc>(),
        ),
        BlocProvider<NotificationBloc>(
          lazy: true,
          create: (context) => di.sl<NotificationBloc>(),
        ),
        BlocProvider<VerificationBloc>(
          lazy: true,
          create: (context) => di.sl<VerificationBloc>(),
        ),
        BlocProvider<PitchBloc>(
          lazy: true,
          create: (context) => di.sl<PitchBloc>(),
        ),
        BlocProvider<FileBloc>(
          lazy: true,
          create: (context) => di.sl<FileBloc>(),
        ),
        BlocProvider<CronBloc>(
          lazy: true,
          create: (context) => di.sl<CronBloc>(),
        ),
        BlocProvider<ReportBloc>(
          lazy: true,
          create: (context) => di.sl<ReportBloc>(),
        ),
        BlocProvider<ThemeCubit>(
          create: (context) => di.sl<ThemeCubit>()..loadTheme(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'StartupEt',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeState.themeMode,
            home: AuthGate(
              hasStoredToken: hasStoredToken,
              hasSeenOnboarding: hasSeenOnboarding,
            ),
          );
        },
      ),
    );
  }
}

class AuthGate extends StatefulWidget {
  final bool hasStoredToken;
  final bool hasSeenOnboarding;

  const AuthGate({
    super.key,
    this.hasStoredToken = false,
    this.hasSeenOnboarding = false,
  });

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late bool _isCheckingInitialAuth;

  @override
  void initState() {
    super.initState();
    _isCheckingInitialAuth = widget.hasStoredToken;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) {
        return current is AuthAuthenticated || current is AuthUnauthenticated;
      },
      listener: (context, state) {
        if (_isCheckingInitialAuth) {
          setState(() {
            _isCheckingInitialAuth = false;
          });
        }
      },
      buildWhen: (previous, current) {
        return current is AuthAuthenticated ||
            current is AuthUnauthenticated ||
            current is AuthInitial;
      },
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return const HomeScreen();
        }
        if (_isCheckingInitialAuth && state is AuthLoading) {
          return const Scaffold(
            body: Center(
              child: SpinKitThreeBounce(color: AppColors.primary, size: 30),
            ),
          );
        }
        if (!widget.hasSeenOnboarding) {
          return const OnboardingScreen();
        }
        return const LoginScreen();
      },
    );
  }
}
