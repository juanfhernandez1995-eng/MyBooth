import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/mybooth_theme.dart';
import 'providers/asset_library_provider.dart';
import 'providers/event_provider.dart';
import 'providers/local_connection_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/server_status_provider.dart';
import 'screens/splash_screen.dart';
import 'themes/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final assetLibraryProvider = AssetLibraryProvider();
  final eventProvider = EventProvider();
  final themeProvider = ThemeProvider();
  final serverStatusProvider = ServerStatusProvider();
  final localConnectionProvider = LocalConnectionProvider();

  await Future.wait([
    eventProvider.loadEvents(),
    themeProvider.loadTheme(),
    serverStatusProvider.loadStatus(),
    localConnectionProvider.loadConnection(),
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AssetLibraryProvider>.value(value: assetLibraryProvider),
        ChangeNotifierProvider<EventProvider>.value(value: eventProvider),
        ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
        ChangeNotifierProvider<ServerStatusProvider>.value(value: serverStatusProvider),
        ChangeNotifierProvider<LocalConnectionProvider>.value(value: localConnectionProvider),
      ],
      child: const MyBoothApp(),
    ),
  );
}

class MyBoothApp extends StatelessWidget {
  const MyBoothApp({super.key});

  @override
  Widget build(BuildContext context) {
    final myBoothTheme = context.select<ThemeProvider, MyBoothTheme>(
      (provider) => provider.currentTheme,
    );

    return MaterialApp(
      title: 'MyBooth',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme(myBoothTheme),
      home: const SplashScreen(),
    );
  }
}
