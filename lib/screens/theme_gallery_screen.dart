import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/mybooth_theme.dart';
import '../providers/theme_provider.dart';

class ThemeGalleryScreen extends StatelessWidget {
  const ThemeGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final themes = themeProvider.themes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Gallery'),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return GridView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: themes.length,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: _gridMaxExtent(constraints.maxWidth),
                mainAxisExtent: _gridMainExtent(constraints.maxWidth),
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
              ),
              itemBuilder: (context, index) {
                final theme = themes[index];

                return _ThemeCard(
                  theme: theme,
                  isSelected: themeProvider.isSelected(theme.id),
                  onTap: () => _selectTheme(context, theme),
                );
              },
            );
          },
        ),
      ),
    );
  }

  double _gridMaxExtent(double width) {
    if (width < 520) return 420;
    if (width < 900) return 320;
    return 280;
  }

  double _gridMainExtent(double width) {
    if (width < 520) return 292;
    if (width < 900) return 304;
    return 286;
  }

  Future<void> _selectTheme(BuildContext context, MyBoothTheme theme) async {
    await context.read<ThemeProvider>().selectTheme(theme.id);

    if (!context.mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('${theme.name} selected.')),
      );
  }
}

class _ThemeCard extends StatelessWidget {
  final MyBoothTheme theme;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeCard({
    required this.theme,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      button: true,
      selected: isSelected,
      label: '${theme.name} theme',
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: isSelected ? 8 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(
            color: isSelected ? theme.primaryColor : Colors.transparent,
            width: 3,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _ThemeIcon(theme: theme),
                const SizedBox(height: 14),
                Text(
                  theme.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Center(
                    child: Text(
                      theme.description,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _ThemeSelectionPill(
                  theme: theme,
                  isSelected: isSelected,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ThemeIcon extends StatelessWidget {
  final MyBoothTheme theme;

  const _ThemeIcon({required this.theme});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 32,
      backgroundColor: theme.primaryColor.withValues(alpha: 0.14),
      child: Icon(
        theme.icon,
        size: 34,
        color: theme.primaryColor,
      ),
    );
  }
}

class _ThemeSelectionPill extends StatelessWidget {
  final MyBoothTheme theme;
  final bool isSelected;

  const _ThemeSelectionPill({
    required this.theme,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final Color foreground = isSelected ? Colors.white : theme.primaryColor;
    final Color background = isSelected
        ? theme.primaryColor
        : theme.primaryColor.withValues(alpha: 0.08);

    return Container(
      height: 40,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: theme.primaryColor.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? Icons.check_circle : Icons.palette_outlined,
            size: 18,
            color: foreground,
          ),
          const SizedBox(width: 8),
          Text(
            isSelected ? 'Selected' : 'Use Theme',
            style: TextStyle(
              color: foreground,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
