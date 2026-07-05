import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/booth_asset.dart';
import '../models/event.dart';
import '../providers/asset_library_provider.dart';
import '../providers/event_provider.dart';
import '../widgets/app_page.dart';
import '../widgets/empty_state.dart';
import '../widgets/primary_button.dart';
import '../widgets/section_card.dart';

class TemplateDesignerScreen extends StatefulWidget {
  final String? eventId;

  const TemplateDesignerScreen({
    super.key,
    this.eventId,
  });

  @override
  State<TemplateDesignerScreen> createState() => _TemplateDesignerScreenState();
}

class _TemplateDesignerScreenState extends State<TemplateDesignerScreen> {
  final _eventTitleController = TextEditingController();
  final _honoreeNameController = TextEditingController();
  final _subtitleController = TextEditingController();

  String? _loadedEventId;
  String? _selectedTemplateId;
  String? _selectedPaletteId;
  String? _selectedBackgroundPackId;
  bool _greenScreenEnabled = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _eventTitleController.dispose();
    _honoreeNameController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }

  BoothEvent? _resolveEvent(EventProvider eventProvider) {
    final id = widget.eventId;
    if (id == null) {
      return eventProvider.latestEvent;
    }
    return eventProvider.getEventById(id);
  }

  void _loadEventIfNeeded(BoothEvent event) {
    if (_loadedEventId == event.id) {
      return;
    }

    _loadedEventId = event.id;
    _eventTitleController.text = event.eventName;
    _honoreeNameController.text = event.honoreeName;
    _subtitleController.text = event.eventSubtitle;
    _selectedTemplateId = event.templateId;
    _selectedPaletteId = event.templatePaletteId;
    _selectedBackgroundPackId = event.backgroundPackId;
    _greenScreenEnabled = event.greenScreenEnabled;
  }

  Future<void> _saveTemplate(BoothEvent event, AssetLibraryProvider assets) async {
    final template = assets.getTemplateById(_selectedTemplateId ?? '') ?? assets.defaultTemplate;
    final palette = template.paletteById(_selectedPaletteId);
    final backgroundPack = assets.getBackgroundPackById(_selectedBackgroundPackId ?? '') ?? assets.defaultBackgroundPack;

    setState(() => _isSaving = true);

    await context.read<EventProvider>().updateEvent(
          event.copyWith(
            eventName: _eventTitleController.text.trim(),
            honoreeName: _honoreeNameController.text.trim(),
            eventSubtitle: _subtitleController.text.trim(),
            templateId: template.id,
            templateName: template.name,
            templateCategory: template.categoryLabel,
            templatePaletteId: palette.id,
            templatePaletteName: palette.name,
            backgroundPackId: backgroundPack.id,
            backgroundPackName: backgroundPack.name,
            greenScreenEnabled: _greenScreenEnabled,
            photoLayout: template.layoutLabel,
          ),
        );

    if (!mounted) {
      return;
    }

    setState(() => _isSaving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Template design saved for this event.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = context.watch<EventProvider>();
    final assets = context.watch<AssetLibraryProvider>();
    final event = _resolveEvent(eventProvider);

    if (event == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Template Designer')),
        body: const AppPage(
          child: EmptyState(
            icon: Icons.filter_frames,
            title: 'Create an event first',
            message: 'Template Designer saves names, dates, colors, and border choices to a specific event.',
          ),
        ),
      );
    }

    _loadEventIfNeeded(event);

    final selectedTemplate = assets.getTemplateById(_selectedTemplateId ?? '') ?? assets.defaultTemplate;
    _selectedTemplateId ??= selectedTemplate.id;
    _selectedPaletteId ??= selectedTemplate.palettes.first.id;
    _selectedBackgroundPackId ??= assets.defaultBackgroundPack.id;
    final selectedPalette = selectedTemplate.paletteById(_selectedPaletteId);

    return Scaffold(
      appBar: AppBar(title: const Text('Template Designer')),
      body: AppPage(
        maxWidth: 920,
        child: ListView(
          children: [
            Text(
              'Design the event border.',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose a wedding, baptism, birthday, corporate, or seasonal template. Edit the event text and color palette that will appear on the final bordered guest photo.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 820;
                if (!isWide) {
                  return Column(
                    children: [
                      _TemplatePreviewCard(
                        event: event,
                        eventTitle: _eventTitleController.text,
                        honoreeName: _honoreeNameController.text,
                        subtitle: _subtitleController.text,
                        template: selectedTemplate,
                        palette: selectedPalette,
                      ),
                      const SizedBox(height: 16),
                      _TemplateControlsCard(
                        assets: assets,
                        selectedTemplate: selectedTemplate,
                        selectedTemplateId: _selectedTemplateId!,
                        selectedPaletteId: _selectedPaletteId!,
                        selectedBackgroundPackId: _selectedBackgroundPackId!,
                        greenScreenEnabled: _greenScreenEnabled,
                        eventTitleController: _eventTitleController,
                        honoreeNameController: _honoreeNameController,
                        subtitleController: _subtitleController,
                        onChanged: () => setState(() {}),
                        onTemplateChanged: (value) => _changeTemplate(assets, value),
                        onPaletteChanged: (value) => setState(() => _selectedPaletteId = value),
                        onBackgroundChanged: (value) => setState(() => _selectedBackgroundPackId = value),
                        onGreenScreenChanged: (value) => setState(() => _greenScreenEnabled = value),
                      ),
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: _TemplatePreviewCard(
                        event: event,
                        eventTitle: _eventTitleController.text,
                        honoreeName: _honoreeNameController.text,
                        subtitle: _subtitleController.text,
                        template: selectedTemplate,
                        palette: selectedPalette,
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      flex: 4,
                      child: _TemplateControlsCard(
                        assets: assets,
                        selectedTemplate: selectedTemplate,
                        selectedTemplateId: _selectedTemplateId!,
                        selectedPaletteId: _selectedPaletteId!,
                        selectedBackgroundPackId: _selectedBackgroundPackId!,
                        greenScreenEnabled: _greenScreenEnabled,
                        eventTitleController: _eventTitleController,
                        honoreeNameController: _honoreeNameController,
                        subtitleController: _subtitleController,
                        onChanged: () => setState(() {}),
                        onTemplateChanged: (value) => _changeTemplate(assets, value),
                        onPaletteChanged: (value) => setState(() => _selectedPaletteId = value),
                        onBackgroundChanged: (value) => setState(() => _selectedBackgroundPackId = value),
                        onGreenScreenChanged: (value) => setState(() => _greenScreenEnabled = value),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 18),
            _TemplateRulesCard(template: selectedTemplate),
            const SizedBox(height: 20),
            PrimaryButton(
              text: _isSaving ? 'Saving Template...' : 'Save Template Design',
              icon: Icons.save,
              onPressed: _isSaving ? null : () => _saveTemplate(event, assets),
            ),
          ],
        ),
      ),
    );
  }

  void _changeTemplate(AssetLibraryProvider assets, String value) {
    final template = assets.getTemplateById(value) ?? assets.defaultTemplate;
    setState(() {
      _selectedTemplateId = template.id;
      _selectedPaletteId = template.palettes.first.id;
      if (!template.supportsGreenScreen) {
        _greenScreenEnabled = false;
      }
    });
  }
}

class _TemplateControlsCard extends StatelessWidget {
  final AssetLibraryProvider assets;
  final BoothTemplate selectedTemplate;
  final String selectedTemplateId;
  final String selectedPaletteId;
  final String selectedBackgroundPackId;
  final bool greenScreenEnabled;
  final TextEditingController eventTitleController;
  final TextEditingController honoreeNameController;
  final TextEditingController subtitleController;
  final VoidCallback onChanged;
  final ValueChanged<String> onTemplateChanged;
  final ValueChanged<String> onPaletteChanged;
  final ValueChanged<String> onBackgroundChanged;
  final ValueChanged<bool> onGreenScreenChanged;

  const _TemplateControlsCard({
    required this.assets,
    required this.selectedTemplate,
    required this.selectedTemplateId,
    required this.selectedPaletteId,
    required this.selectedBackgroundPackId,
    required this.greenScreenEnabled,
    required this.eventTitleController,
    required this.honoreeNameController,
    required this.subtitleController,
    required this.onChanged,
    required this.onTemplateChanged,
    required this.onPaletteChanged,
    required this.onBackgroundChanged,
    required this.onGreenScreenChanged,
  });

  @override
  Widget build(BuildContext context) {
    final templateItems = assets.templates.map((template) {
      return DropdownMenuItem(
        value: template.id,
        child: Text('${template.categoryLabel} • ${template.name}'),
      );
    }).toList();

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _DesignerHeader(
            icon: Icons.tune,
            title: 'Editable Template Settings',
            subtitle: 'This is where you put the name, title, date, subtitle, color palette, and event border choice.',
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: selectedTemplateId,
            decoration: const InputDecoration(labelText: 'Template / Border Family'),
            items: templateItems,
            onChanged: (value) {
              if (value != null) {
                onTemplateChanged(value);
              }
            },
          ),
          const SizedBox(height: 14),
          TextField(
            controller: eventTitleController,
            decoration: const InputDecoration(
              labelText: 'Event Title',
              hintText: 'Wedding, Holy Baptism, Birthday Party, Company Gala',
            ),
            onChanged: (_) => onChanged(),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: honoreeNameController,
            decoration: const InputDecoration(
              labelText: 'Person / Honoree / Company Name',
              hintText: 'Alyssa & Daniel, Baby Lucas, Emily, Acme Inc.',
            ),
            onChanged: (_) => onChanged(),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: subtitleController,
            decoration: const InputDecoration(
              labelText: 'Subtitle / Age / Custom Line',
              hintText: '10th Birthday, God bless you, Annual Gala',
            ),
            onChanged: (_) => onChanged(),
          ),
          const SizedBox(height: 16),
          Text(
            'Color Palette',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: selectedTemplate.palettes.map((palette) {
              return ChoiceChip(
                selected: palette.id == selectedPaletteId,
                label: _PaletteLabel(palette: palette),
                onSelected: (_) => onPaletteChanged(palette.id),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: selectedBackgroundPackId,
            decoration: const InputDecoration(labelText: 'Background Pack'),
            items: assets.backgroundPacks.map((pack) {
              return DropdownMenuItem(
                value: pack.id,
                child: Text('${pack.category} • ${pack.name}'),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                onBackgroundChanged(value);
              }
            },
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Use green screen background workflow'),
            subtitle: Text(selectedTemplate.supportsGreenScreen ? 'This template supports background replacement.' : 'This template is designed as a clean non-green-screen layout.'),
            value: greenScreenEnabled,
            onChanged: selectedTemplate.supportsGreenScreen ? onGreenScreenChanged : null,
          ),
        ],
      ),
    );
  }
}

class _TemplatePreviewCard extends StatelessWidget {
  final BoothEvent event;
  final String eventTitle;
  final String honoreeName;
  final String subtitle;
  final BoothTemplate template;
  final TemplateColorPalette palette;

  const _TemplatePreviewCard({
    required this.event,
    required this.eventTitle,
    required this.honoreeName,
    required this.subtitle,
    required this.template,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final title = eventTitle.trim().isEmpty ? event.displayName : eventTitle.trim();
    final name = honoreeName.trim().isEmpty ? event.displayHonoree : honoreeName.trim();
    final customLine = subtitle.trim().isEmpty ? 'Thanks for celebrating with us' : subtitle.trim();

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _DesignerHeader(
            icon: Icons.preview,
            title: 'Live Template Preview',
            subtitle: 'Foundation preview for the future rendered 2x6 strip or 4x6 print file.',
          ),
          const SizedBox(height: 16),
          Center(
            child: template.layout == BoothPrintLayout.strip2x6
                ? _StripPreview(
                    title: title,
                    name: name,
                    subtitle: customLine,
                    date: event.displayDate,
                    palette: palette,
                    photoSlots: template.photoSlots,
                  )
                : _PrintPreview(
                    title: title,
                    name: name,
                    subtitle: customLine,
                    date: event.displayDate,
                    palette: palette,
                    photoSlots: template.photoSlots,
                  ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _PreviewChip(label: template.categoryLabel),
              _PreviewChip(label: template.layoutLabel),
              _PreviewChip(label: '${template.photoSlots} photo slot${template.photoSlots == 1 ? '' : 's'}'),
              _PreviewChip(label: palette.name),
            ],
          ),
        ],
      ),
    );
  }
}

class _StripPreview extends StatelessWidget {
  final String title;
  final String name;
  final String subtitle;
  final String date;
  final TemplateColorPalette palette;
  final int photoSlots;

  const _StripPreview({
    required this.title,
    required this.name,
    required this.subtitle,
    required this.date,
    required this.palette,
    required this.photoSlots,
  });

  @override
  Widget build(BuildContext context) {
    final slotCount = photoSlots < 1 ? 1 : (photoSlots > 4 ? 4 : photoSlots);

    return Container(
      width: 190,
      padding: const EdgeInsets.all(12),
      decoration: _previewDecoration(palette),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(color: palette.primary, fontWeight: FontWeight.w900, letterSpacing: 1.2),
          ),
          const SizedBox(height: 10),
          ...List.generate(slotCount, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _PhotoSlot(label: 'Photo ${index + 1}', palette: palette, height: 80),
            );
          }),
          const SizedBox(height: 4),
          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(color: palette.primary, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(
            date,
            style: TextStyle(color: palette.accent, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: palette.primary),
          ),
        ],
      ),
    );
  }
}

class _PrintPreview extends StatelessWidget {
  final String title;
  final String name;
  final String subtitle;
  final String date;
  final TemplateColorPalette palette;
  final int photoSlots;

  const _PrintPreview({
    required this.title,
    required this.name,
    required this.subtitle,
    required this.date,
    required this.palette,
    required this.photoSlots,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 330,
      constraints: const BoxConstraints(maxWidth: 360),
      padding: const EdgeInsets.all(16),
      decoration: _previewDecoration(palette),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title.toUpperCase(),
                  style: TextStyle(color: palette.primary, fontWeight: FontWeight.w900, letterSpacing: 1.1),
                ),
              ),
              Text(date, style: TextStyle(color: palette.accent, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          _PhotoSlot(label: photoSlots <= 1 ? 'Final Photo' : '$photoSlots Photo Grid', palette: palette, height: 230),
          const SizedBox(height: 12),
          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(color: palette.primary, fontWeight: FontWeight.bold, fontSize: 22),
          ),
          Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: palette.primary),
          ),
        ],
      ),
    );
  }
}

BoxDecoration _previewDecoration(TemplateColorPalette palette) {
  return BoxDecoration(
    color: palette.secondary,
    borderRadius: BorderRadius.circular(28),
    border: Border.all(color: palette.accent, width: 4),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.14),
        blurRadius: 22,
        offset: const Offset(0, 12),
      ),
    ],
  );
}

class _PhotoSlot extends StatelessWidget {
  final String label;
  final TemplateColorPalette palette;
  final double height;

  const _PhotoSlot({
    required this.label,
    required this.palette,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: palette.primary.withValues(alpha: 0.35), width: 2),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(color: palette.primary.withValues(alpha: 0.72), fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _TemplateRulesCard extends StatelessWidget {
  final BoothTemplate template;

  const _TemplateRulesCard({required this.template});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _DesignerHeader(
            icon: Icons.rule,
            title: 'Template Render Rules',
            subtitle: 'These metadata rules prepare MyBooth for final PNG/JPEG border rendering later.',
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: template.textSlots.map((slot) {
              return Chip(
                avatar: Icon(slot.required ? Icons.star : Icons.edit, size: 16),
                label: Text('${slot.label}${slot.required ? ' required' : ''}'),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          Text(
            'QR delivery and Google Photos export should use the future final bordered/composited output generated from this design. Raw originals remain operator-only.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _PaletteLabel extends StatelessWidget {
  final TemplateColorPalette palette;

  const _PaletteLabel({required this.palette});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ColorDot(color: palette.primary),
        _ColorDot(color: palette.secondary),
        _ColorDot(color: palette.accent),
        const SizedBox(width: 6),
        Text(palette.name),
      ],
    );
  }
}

class _ColorDot extends StatelessWidget {
  final Color color;

  const _ColorDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      margin: const EdgeInsets.only(right: 2),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black12),
      ),
    );
  }
}

class _DesignerHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _DesignerHeader({
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
              const SizedBox(height: 3),
              Text(subtitle),
            ],
          ),
        ),
      ],
    );
  }
}

class _PreviewChip extends StatelessWidget {
  final String label;

  const _PreviewChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(label));
  }
}
