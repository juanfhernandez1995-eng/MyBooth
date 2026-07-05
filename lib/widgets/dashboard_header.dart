import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../branding/mybooth_brand.dart';
import '../providers/theme_provider.dart';
import 'brand_lockup.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final activeTheme = context.watch<ThemeProvider>().currentTheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 34),
        child: Column(
          children: [
            const BrandLockup(logoWidth: 360),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: activeTheme.primaryColor.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: activeTheme.primaryColor.withValues(alpha: 0.20),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    activeTheme.icon,
                    size: 18,
                    color: activeTheme.primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Active theme: ${activeTheme.name}',
                    style: textTheme.labelLarge?.copyWith(
                      color: activeTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '${MyBoothBrand.operatorTagline} • ${MyBoothBrand.version}',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
