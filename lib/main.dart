import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'core/app_colors.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/presentation/screens/home_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initDependencies();

  final storage = const FlutterSecureStorage();
  final apiKey = await storage.read(key: 'api_key');
  final isAuthenticated = apiKey != null && apiKey.isNotEmpty;

  runApp(StartupetApp(isAuthenticated: isAuthenticated));
}

class StartupetApp extends StatelessWidget {
  final bool isAuthenticated;

  const StartupetApp({super.key, required this.isAuthenticated});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StartupEt',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,

          primary: AppColors.primary,
        ),
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => di.sl<AuthBloc>(),
        child: isAuthenticated ? const HomeScreen() : const LoginScreen(),
      ),
    );
  }
}
