import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/event.dart';
import '../providers/event_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/app_page.dart';
import '../widgets/connection_status_card.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_menu.dart';
import '../widgets/recent_events_card.dart';
import '../widgets/system_status_card.dart';
import 'asset_library_screen.dart';
import 'booth_mode_screen.dart';
import 'create_event_screen.dart';
import 'event_detail_screen.dart';
import 'gallery_screen.dart';
import 'local_connection_screen.dart';
import 'settings_screen.dart';
import 'server_dashboard_screen.dart';
import 'theme_gallery_screen.dart';
import 'template_designer_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = context.watch<EventProvider>();
    final activeTheme = context.watch<ThemeProvider>().currentTheme;

    return Scaffold(
      body: AppPage(
        child: ListView(
          children: [
            const DashboardHeader(),
            const SizedBox(height: 20),
            ConnectionStatusCard(onOpenConnection: () => _openLocalConnection(context)),
            const SizedBox(height: 20),
            SystemStatusCard(onViewDetails: () => _openServerDashboard(context)),
            const SizedBox(height: 20),
            DashboardMenu(
              onNewEvent: () => _openNewEvent(context),
              onContinueEvent: () => _continueLatestEvent(context, eventProvider.latestEvent),
              onThemeGallery: () => _openThemeGallery(context),
              onBoothMode: () => _openBoothMode(context, eventProvider.latestEvent),
              onServerStatus: () => _openServerDashboard(context),
              onLocalConnection: () => _openLocalConnection(context),
              onGallery: () => _openGallery(context),
              onAssetLibrary: () => _openAssetLibrary(context),
              onTemplateDesigner: () => _openTemplateDesigner(context, eventProvider.latestEvent),
              onSettings: () => _openSettings(context),
            ),
            const SizedBox(height: 12),
            Text(
              'Active theme: ${activeTheme.name}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: activeTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            const SizedBox(
              height: 360,
              child: RecentEventsCard(),
            ),
          ],
        ),
      ),
    );
  }

  void _openNewEvent(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateEventScreen()),
    );
  }

  void _continueLatestEvent(BuildContext context, BoothEvent? latestEvent) {
    if (latestEvent == null) {
      _showMessage(context, 'Create an event first, then continue it here.');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EventDetailScreen(eventId: latestEvent.id),
      ),
    );
  }

  void _openBoothMode(BuildContext context, BoothEvent? latestEvent) {
    if (latestEvent == null) {
      _showMessage(context, 'Create an event first, then Booth Mode will be ready.');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BoothModeScreen(event: latestEvent),
      ),
    );
  }

  void _openThemeGallery(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ThemeGalleryScreen()),
    );
  }


  void _openLocalConnection(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LocalConnectionScreen()),
    );
  }

  void _openServerDashboard(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ServerDashboardScreen()),
    );
  }


  void _openGallery(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const GalleryScreen()),
    );
  }

  void _openAssetLibrary(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AssetLibraryScreen()),
    );
  }

  void _openTemplateDesigner(BuildContext context, BoothEvent? latestEvent) {
    if (latestEvent == null) {
      _showMessage(context, 'Create an event first, then design its template.');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TemplateDesignerScreen(eventId: latestEvent.id),
      ),
    );
  }

  void _openSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SettingsScreen()),
    );
  }
}
