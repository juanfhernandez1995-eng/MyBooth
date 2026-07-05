import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../branding/mybooth_brand.dart';
import '../providers/theme_provider.dart';
import '../widgets/brand_lockup.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activeTheme = context.watch<ThemeProvider>().currentTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const BrandLockup(logoWidth: 280),
          const SizedBox(height: 24),
          Text(
            'MyBooth Settings',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 6),
          Text('Active theme: ${activeTheme.name}'),
          const SizedBox(height: 20),
          const _SettingTile(
            icon: Icons.computer,
            title: 'Server',
            subtitle: 'Gaming laptop server foundation, module status, and future API boundaries.',
          ),
          const _SettingTile(
            icon: Icons.camera_alt,
            title: 'Camera',
            subtitle: 'Canon EOS R50 integration coming soon.',
          ),
          const _SettingTile(
            icon: Icons.print,
            title: 'Printer',
            subtitle: 'DNP DS-RX1HS print queue coming soon.',
          ),
          const _SettingTile(
            icon: Icons.wifi,
            title: 'Network',
            subtitle: 'Private Wi-Fi tablet/server connection model prepared.',
          ),
          const _SettingTile(
            icon: Icons.wifi_tethering,
            title: 'Local Connection',
            subtitle: 'Server IP, port, real health/status handshake, and mock fallback enabled.',
          ),
          const _SettingTile(
            icon: Icons.palette,
            title: 'Themes',
            subtitle: 'Live theme engine enabled and branded.',
          ),
          const _SettingTile(
            icon: Icons.filter_frames,
            title: 'Templates + Assets',
            subtitle: 'Editable wedding, baptism, birthday, corporate, and seasonal border templates prepared.',
          ),
          const _SettingTile(
            icon: Icons.timer,
            title: 'Capture Countdown',
            subtitle: 'Event-level countdown, delay, sound, flash, smile message, and retake settings prepared.',
          ),
          const _SettingTile(
            icon: Icons.auto_awesome,
            title: 'Branding',
            subtitle: 'MyBooth logo, splash screen, and web identity enabled.',
          ),
          const _SettingTile(
            icon: Icons.info_outline,
            title: 'Version',
            subtitle: 'MyBooth ${MyBoothBrand.version} photo, template, and capture foundation release.',
          ),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}
