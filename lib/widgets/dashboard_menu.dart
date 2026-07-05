import 'package:flutter/material.dart';

class DashboardMenu extends StatelessWidget {
  final VoidCallback onNewEvent;
  final VoidCallback onContinueEvent;
  final VoidCallback onThemeGallery;
  final VoidCallback onBoothMode;
  final VoidCallback onServerStatus;
  final VoidCallback onLocalConnection;
  final VoidCallback onGallery;
  final VoidCallback onAssetLibrary;
  final VoidCallback onTemplateDesigner;
  final VoidCallback onSettings;

  const DashboardMenu({
    super.key,
    required this.onNewEvent,
    required this.onContinueEvent,
    required this.onThemeGallery,
    required this.onBoothMode,
    required this.onServerStatus,
    required this.onLocalConnection,
    required this.onGallery,
    required this.onAssetLibrary,
    required this.onTemplateDesigner,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _DashboardButton(
          icon: Icons.add_circle_outline,
          title: 'New Event',
          onTap: onNewEvent,
          isPrimary: true,
        ),
        const SizedBox(height: 12),
        _DashboardButton(
          icon: Icons.folder_open,
          title: 'Continue Event',
          onTap: onContinueEvent,
        ),
        const SizedBox(height: 12),
        _DashboardButton(
          icon: Icons.photo_camera_front,
          title: 'Booth Mode',
          onTap: onBoothMode,
        ),
        const SizedBox(height: 12),
        _DashboardButton(
          icon: Icons.palette,
          title: 'Theme Gallery',
          onTap: onThemeGallery,
        ),
        const SizedBox(height: 12),
        _DashboardButton(
          icon: Icons.hub,
          title: 'Server Status',
          onTap: onServerStatus,
        ),
        const SizedBox(height: 12),
        _DashboardButton(
          icon: Icons.wifi_tethering,
          title: 'Local Connection',
          onTap: onLocalConnection,
        ),
        const SizedBox(height: 12),
        _DashboardButton(
          icon: Icons.photo_library,
          title: 'Gallery',
          onTap: onGallery,
        ),
        const SizedBox(height: 12),
        _DashboardButton(
          icon: Icons.filter_frames,
          title: 'Templates + Assets',
          onTap: onAssetLibrary,
        ),
        const SizedBox(height: 12),
        _DashboardButton(
          icon: Icons.design_services,
          title: 'Template Designer',
          onTap: onTemplateDesigner,
        ),
        const SizedBox(height: 12),
        _DashboardButton(
          icon: Icons.settings,
          title: 'Settings',
          onTap: onSettings,
        ),
      ],
    );
  }
}

class _DashboardButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isPrimary;

  const _DashboardButton({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: isPrimary ? 68 : 56,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(
          title,
          style: TextStyle(
            fontSize: isPrimary ? 20 : 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
