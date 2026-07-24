import 'package:flutter/material.dart';

import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initDependencies();
  runApp(const StartupetApp());
}

class StartupetApp extends StatelessWidget {
  const StartupetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StartupEt',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Scaffold(body: Center(child: Text('StartupEt'))),
    );
  }
}
