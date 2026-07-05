import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/booth_asset.dart';
import '../providers/asset_library_provider.dart';
import '../widgets/app_page.dart';
import '../widgets/section_card.dart';

class AssetLibraryScreen extends StatelessWidget {
  const AssetLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AssetLibraryProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Template Library')),
      body: AppPage(
        maxWidth: 820,
        child: ListView(
          children: [
            Text(
              'Photo + Asset Foundation',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Starter foundation for editable borders, background packs, green screen workflow, one-screen Booth Mode, countdown capture, and QR delivery for final bordered photos.',
            ),
            const SizedBox(height: 18),
            _StoragePlanCard(),
            const SizedBox(height: 18),
            _TemplateCategorySection(
              title: 'Wedding Templates',
              templates: provider.templates.where((template) => template.category == TemplateCategory.wedding).toList(),
            ),
            const SizedBox(height: 18),
            _TemplateCategorySection(
              title: 'Baptism Templates',
              templates: provider.templates.where((template) => template.category == TemplateCategory.baptism).toList(),
            ),
            const SizedBox(height: 18),
            _TemplateCategorySection(
              title: 'Birthday Templates',
              templates: provider.templates.where((template) => template.category == TemplateCategory.birthday).toList(),
            ),
            const SizedBox(height: 18),
            _TemplateCategorySection(
              title: 'Corporate Templates',
              templates: provider.templates.where((template) => template.category == TemplateCategory.corporate).toList(),
            ),
            const SizedBox(height: 18),
            _TemplateCategorySection(
              title: 'Seasonal Templates',
              templates: provider.templates.where((template) => template.category == TemplateCategory.seasonal).toList(),
            ),
            const SizedBox(height: 18),
            _BackgroundPacksCard(backgroundPacks: provider.backgroundPacks),
          ],
        ),
      ),
    );
  }
}

class _StoragePlanCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeaderRow(
            icon: Icons.folder_copy,
            title: 'Server Storage Plan',
            subtitle: '${PhotoStoragePlan.root}/events keeps originals, composites, bordered files, prints, thumbnails, final QR gallery exports, and logs.',
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: PhotoStoragePlan.eventFolders
                .map((folder) => Chip(label: Text(folder)))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _TemplateCategorySection extends StatelessWidget {
  final String title;
  final List<BoothTemplate> templates;

  const _TemplateCategorySection({
    required this.title,
    required this.templates,
  });

  @override
  Widget build(BuildContext context) {
    if (templates.isEmpty) {
      return const SizedBox.shrink();
    }

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeaderRow(
            icon: Icons.filter_frames,
            title: title,
            subtitle: 'Editable text, interchangeable colors, and 2x6 / 4x6 layout foundations.',
          ),
          const SizedBox(height: 14),
          ...templates.map((template) => _TemplateTile(template: template)),
        ],
      ),
    );
  }
}

class _TemplateTile extends StatelessWidget {
  final BoothTemplate template;

  const _TemplateTile({required this.template});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.photo_size_select_actual, color: colorScheme.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    template.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                _Badge(label: template.layoutLabel),
              ],
            ),
            const SizedBox(height: 8),
            Text(template.description),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: template.palettes.map((palette) => _PaletteChip(palette: palette)).toList(),
            ),
            const SizedBox(height: 10),
            Text(
              'Editable text: ${template.textSlots.map((slot) => slot.label).join(', ')}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: const Color(0xFF6B7280)),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaletteChip extends StatelessWidget {
  final TemplateColorPalette palette;

  const _PaletteChip({required this.palette});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.black26),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ColorDot(color: palette.primary),
          const SizedBox(width: 3),
          _ColorDot(color: palette.secondary),
          const SizedBox(width: 3),
          _ColorDot(color: palette.accent),
          const SizedBox(width: 8),
          Text(
            palette.name,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  final Color color;

  const _ColorDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 9,
      height: 9,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black12),
      ),
    );
  }
}

class _BackgroundPacksCard extends StatelessWidget {
  final List<BackgroundPack> backgroundPacks;

  const _BackgroundPacksCard({required this.backgroundPacks});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _HeaderRow(
            icon: Icons.wallpaper,
            title: 'Background Packs',
            subtitle: 'Green screen and AI background libraries will live on the MyBooth Server.',
          ),
          const SizedBox(height: 14),
          ...backgroundPacks.map((pack) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  pack.greenScreenReady ? Icons.auto_fix_high : Icons.image,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(pack.name),
                subtitle: Text(pack.description),
                trailing: _Badge(label: pack.category),
              )),
        ],
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _HeaderRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Text(subtitle),
            ],
          ),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;

  const _Badge({required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
