import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/event_provider.dart';
import 'screens/home_screen.dart';
import 'themes/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final eventProvider = EventProvider();
  await eventProvider.loadEvents();

  runApp(
    ChangeNotifierProvider(
      create: (_) => eventProvider,
      child: const MyBoothApp(),
    ),
  );
}

class MyBoothApp extends StatelessWidget {
  const MyBoothApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyBooth',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme(),
      home: const HomeScreen(),
    );
  }
}