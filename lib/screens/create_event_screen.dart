import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/booth_asset.dart';
import '../models/event.dart';
import '../providers/asset_library_provider.dart';
import '../providers/event_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/app_page.dart';
import '../widgets/primary_button.dart';
import '../widgets/section_card.dart';
import 'event_detail_screen.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _eventNameController = TextEditingController();
  final _customerNameController = TextEditingController();
  final _customerEmailController = TextEditingController();
  final _honoreeNameController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedOccasion = 'Birthday';
  String? _selectedThemeName;
  String _selectedLayout = '3-Photo Strip';
  DateTime _selectedDate = DateTime.now();
  int _printCopies = 2;
  bool _guestUploadsEnabled = true;
  bool _sendGalleryTomorrow = true;
  bool _greenScreenEnabled = false;
  int _countdownSeconds = 3;
  int _delayBetweenPhotosSeconds = 3;
  bool _showSmileMessage = true;
  bool _flashScreenEnabled = true;
  bool _soundEnabled = true;
  bool _retakeEnabled = true;
  String? _selectedTemplateId;
  String? _selectedPaletteId;
  String? _selectedBackgroundPackId;
  bool _isSaving = false;

  static const List<String> _occasions = [
    'Birthday',
    'Wedding',
    'Baptism',
    'Graduation',
    'Baby Shower',
    'Corporate',
    'Holiday',
    'Custom',
  ];

  static const List<String> _layouts = [
    'Single 4x6',
    '2x6 Strip',
    '3-Photo Strip',
    '4 Photo Grid',
  ];

  @override
  void dispose() {
    _eventNameController.dispose();
    _customerNameController.dispose();
    _customerEmailController.dispose();
    _honoreeNameController.dispose();
    _subtitleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _createEvent() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    final now = DateTime.now();
    final activeTheme = context.read<ThemeProvider>().currentTheme;
    final assets = context.read<AssetLibraryProvider>();
    final template = assets.getTemplateById(_selectedTemplateId ?? '') ?? assets.defaultTemplate;
    final palette = template.paletteById(_selectedPaletteId);
    final backgroundPack = assets.getBackgroundPackById(_selectedBackgroundPackId ?? '') ?? assets.defaultBackgroundPack;

    final event = BoothEvent(
      id: 'MB-${now.millisecondsSinceEpoch}',
      eventName: _eventNameController.text.trim(),
      customerName: _customerNameController.text.trim(),
      customerEmail: _customerEmailController.text.trim(),
      occasion: _selectedOccasion,
      eventTheme: _selectedThemeName ?? activeTheme.name,
      eventDate: _selectedDate,
      createdAt: now,
      photoLayout: _selectedLayout,
      printCopies: _printCopies,
      guestUploadsEnabled: _guestUploadsEnabled,
      sendGalleryTomorrow: _sendGalleryTomorrow,
      status: EventStatus.ready,
      notes: _notesController.text.trim(),
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
      captureSettings: CaptureSettings(
        countdownSeconds: _countdownSeconds,
        delayBetweenPhotosSeconds: _delayBetweenPhotosSeconds,
        showSmileMessage: _showSmileMessage,
        flashScreenEnabled: _flashScreenEnabled,
        soundEnabled: _soundEnabled,
        retakeEnabled: _retakeEnabled,
      ),
    );

    await context.read<EventProvider>().addEvent(event);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => EventDetailScreen(eventId: event.id),
      ),
    );
  }

  Future<void> _pickEventDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
    );

    if (pickedDate == null || !mounted) {
      return;
    }

    setState(() => _selectedDate = pickedDate);
  }

  void _syncTemplateForOccasion(AssetLibraryProvider assets, String occasion) {
    final recommendedTemplates = assets.templatesForOccasion(occasion);
    if (recommendedTemplates.isEmpty) {
      return;
    }

    final template = recommendedTemplates.first;
    _selectedTemplateId = template.id;
    _selectedPaletteId = template.palettes.first.id;
  }

  @override
  Widget build(BuildContext context) {
    final themes = context.watch<ThemeProvider>().themes;
    final activeTheme = context.watch<ThemeProvider>().currentTheme;
    final assetProvider = context.watch<AssetLibraryProvider>();
    final templates = assetProvider.templates;
    final backgroundPacks = assetProvider.backgroundPacks;

    _selectedThemeName ??= activeTheme.name;
    _selectedTemplateId ??= assetProvider.templatesForOccasion(_selectedOccasion).first.id;
    final selectedTemplate = assetProvider.getTemplateById(_selectedTemplateId!) ?? assetProvider.defaultTemplate;
    _selectedPaletteId ??= selectedTemplate.palettes.first.id;
    _selectedBackgroundPackId ??= backgroundPacks.first.id;

    return Scaffold(
      appBar: AppBar(title: const Text('Create Event')),
      body: AppPage(
        maxWidth: 760,
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'Create a professional booth event.',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'This event profile drives the booth session, editable border template, green screen backgrounds, countdown, print settings, gallery, and server workflow.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              _EventInfoSection(
                eventNameController: _eventNameController,
                customerNameController: _customerNameController,
                customerEmailController: _customerEmailController,
                honoreeNameController: _honoreeNameController,
                subtitleController: _subtitleController,
                selectedOccasion: _selectedOccasion,
                occasions: _occasions,
                selectedDate: _selectedDate,
                onOccasionChanged: (value) {
                  setState(() {
                    _selectedOccasion = value;
                    _syncTemplateForOccasion(assetProvider, value);
                  });
                },
                onPickDate: _pickEventDate,
              ),
              const SizedBox(height: 16),
              _TemplateSetupSection(
                templates: templates,
                selectedTemplate: selectedTemplate,
                selectedTemplateId: _selectedTemplateId!,
                selectedPaletteId: _selectedPaletteId!,
                backgroundPacks: backgroundPacks,
                selectedBackgroundPackId: _selectedBackgroundPackId!,
                greenScreenEnabled: _greenScreenEnabled,
                onTemplateChanged: (value) {
                  final template = assetProvider.getTemplateById(value);
                  setState(() {
                    _selectedTemplateId = value;
                    _selectedPaletteId = template?.palettes.first.id ?? _selectedPaletteId;
                    _selectedLayout = template?.layoutLabel ?? _selectedLayout;
                  });
                },
                onPaletteChanged: (value) => setState(() => _selectedPaletteId = value),
                onBackgroundChanged: (value) => setState(() => _selectedBackgroundPackId = value),
                onGreenScreenChanged: (value) => setState(() => _greenScreenEnabled = value),
              ),
              const SizedBox(height: 16),
              _BoothSetupSection(
                selectedThemeName: _selectedThemeName!,
                themeNames: themes.map((theme) => theme.name).toList(),
                selectedLayout: _selectedLayout,
                layouts: _layouts,
                printCopies: _printCopies,
                guestUploadsEnabled: _guestUploadsEnabled,
                sendGalleryTomorrow: _sendGalleryTomorrow,
                onThemeChanged: (value) => setState(() => _selectedThemeName = value),
                onLayoutChanged: (value) => setState(() => _selectedLayout = value),
                onPrintCopiesChanged: (copies) => setState(() => _printCopies = copies),
                onGuestUploadsChanged: (value) => setState(() => _guestUploadsEnabled = value),
                onGalleryFollowUpChanged: (value) => setState(() => _sendGalleryTomorrow = value),
              ),
              const SizedBox(height: 16),
              _CountdownSection(
                countdownSeconds: _countdownSeconds,
                delayBetweenPhotosSeconds: _delayBetweenPhotosSeconds,
                showSmileMessage: _showSmileMessage,
                flashScreenEnabled: _flashScreenEnabled,
                soundEnabled: _soundEnabled,
                retakeEnabled: _retakeEnabled,
                onCountdownChanged: (value) => setState(() => _countdownSeconds = value),
                onDelayChanged: (value) => setState(() => _delayBetweenPhotosSeconds = value),
                onSmileChanged: (value) => setState(() => _showSmileMessage = value),
                onFlashChanged: (value) => setState(() => _flashScreenEnabled = value),
                onSoundChanged: (value) => setState(() => _soundEnabled = value),
                onRetakeChanged: (value) => setState(() => _retakeEnabled = value),
              ),
              const SizedBox(height: 16),
              _NotesSection(controller: _notesController),
              const SizedBox(height: 24),
              PrimaryButton(
                text: _isSaving ? 'Creating Event...' : 'Create Event Profile',
                icon: Icons.arrow_forward,
                onPressed: _isSaving ? null : _createEvent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EventInfoSection extends StatelessWidget {
  final TextEditingController eventNameController;
  final TextEditingController customerNameController;
  final TextEditingController customerEmailController;
  final TextEditingController honoreeNameController;
  final TextEditingController subtitleController;
  final String selectedOccasion;
  final List<String> occasions;
  final DateTime selectedDate;
  final ValueChanged<String> onOccasionChanged;
  final VoidCallback onPickDate;

  const _EventInfoSection({
    required this.eventNameController,
    required this.customerNameController,
    required this.customerEmailController,
    required this.honoreeNameController,
    required this.subtitleController,
    required this.selectedOccasion,
    required this.occasions,
    required this.selectedDate,
    required this.onOccasionChanged,
    required this.onPickDate,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.event_note,
            title: 'Event Info',
            subtitle: 'Name the event and capture the customer details.',
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: eventNameController,
            decoration: const InputDecoration(labelText: 'Event Name'),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Enter an event name.';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: honoreeNameController,
            decoration: const InputDecoration(
              labelText: 'Person / Honoree Name',
              hintText: 'Example: Emily, Baby Lucas, Alyssa & Daniel, Acme Inc.',
            ),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: subtitleController,
            decoration: const InputDecoration(
              labelText: 'Template Subtitle / Age / Custom Line',
              hintText: 'Example: 10th Birthday, God bless you, Annual Gala',
            ),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: customerNameController,
            decoration: const InputDecoration(labelText: 'Customer Name'),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: customerEmailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Customer Email'),
            validator: (value) {
              final email = value?.trim() ?? '';
              if (email.isEmpty || email.contains('@')) {
                return null;
              }
              return 'Enter a valid email address.';
            },
          ),
          const SizedBox(height: 16),
          _DropdownField(
            label: 'Occasion',
            value: selectedOccasion,
            items: occasions,
            onChanged: onOccasionChanged,
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: onPickDate,
            icon: const Icon(Icons.calendar_month),
            label: Text('Event Date: ${selectedDate.month}/${selectedDate.day}/${selectedDate.year}'),
          ),
        ],
      ),
    );
  }
}

class _TemplateSetupSection extends StatelessWidget {
  final List<BoothTemplate> templates;
  final BoothTemplate selectedTemplate;
  final String selectedTemplateId;
  final String selectedPaletteId;
  final List<BackgroundPack> backgroundPacks;
  final String selectedBackgroundPackId;
  final bool greenScreenEnabled;
  final ValueChanged<String> onTemplateChanged;
  final ValueChanged<String> onPaletteChanged;
  final ValueChanged<String> onBackgroundChanged;
  final ValueChanged<bool> onGreenScreenChanged;

  const _TemplateSetupSection({
    required this.templates,
    required this.selectedTemplate,
    required this.selectedTemplateId,
    required this.selectedPaletteId,
    required this.backgroundPacks,
    required this.selectedBackgroundPackId,
    required this.greenScreenEnabled,
    required this.onTemplateChanged,
    required this.onPaletteChanged,
    required this.onBackgroundChanged,
    required this.onGreenScreenChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.filter_frames,
            title: 'Event Template + Assets',
            subtitle: 'Choose editable borders, colors, and green screen background packs.',
          ),
          const SizedBox(height: 16),
          _DropdownField(
            label: 'Border / Print Template',
            value: selectedTemplateId,
            items: templates.map((template) => template.id).toList(),
            itemLabels: {for (final template in templates) template.id: '${template.name} (${template.layoutLabel})'},
            onChanged: onTemplateChanged,
          ),
          const SizedBox(height: 12),
          Text(
            selectedTemplate.description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: const Color(0xFF6B7280)),
          ),
          const SizedBox(height: 16),
          _PalettePreview(
            selectedTemplate: selectedTemplate,
            selectedPaletteId: selectedPaletteId,
            onChanged: onPaletteChanged,
          ),
          const SizedBox(height: 16),
          _DropdownField(
            label: 'Background Pack',
            value: selectedBackgroundPackId,
            items: backgroundPacks.map((pack) => pack.id).toList(),
            itemLabels: {for (final pack in backgroundPacks) pack.id: '${pack.name} (${pack.category})'},
            onChanged: onBackgroundChanged,
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Green Screen Background Replacement'),
            subtitle: const Text('Prepared for future chroma key / AI background workflow.'),
            value: greenScreenEnabled,
            onChanged: onGreenScreenChanged,
          ),
        ],
      ),
    );
  }
}

class _PalettePreview extends StatelessWidget {
  final BoothTemplate selectedTemplate;
  final String selectedPaletteId;
  final ValueChanged<String> onChanged;

  const _PalettePreview({
    required this.selectedTemplate,
    required this.selectedPaletteId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Template Colors',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: selectedTemplate.palettes.map((palette) {
            final isSelected = palette.id == selectedPaletteId;
            return ChoiceChip(
              selected: isSelected,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ColorDot(color: palette.primary),
                  _ColorDot(color: palette.secondary),
                  _ColorDot(color: palette.accent),
                  const SizedBox(width: 6),
                  Text(palette.name),
                ],
              ),
              onSelected: (_) => onChanged(palette.id),
            );
          }).toList(),
        ),
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
      width: 14,
      height: 14,
      margin: const EdgeInsets.only(right: 2),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black12),
      ),
    );
  }
}

class _BoothSetupSection extends StatelessWidget {
  final String selectedThemeName;
  final List<String> themeNames;
  final String selectedLayout;
  final List<String> layouts;
  final int printCopies;
  final bool guestUploadsEnabled;
  final bool sendGalleryTomorrow;
  final ValueChanged<String> onThemeChanged;
  final ValueChanged<String> onLayoutChanged;
  final ValueChanged<int> onPrintCopiesChanged;
  final ValueChanged<bool> onGuestUploadsChanged;
  final ValueChanged<bool> onGalleryFollowUpChanged;

  const _BoothSetupSection({
    required this.selectedThemeName,
    required this.themeNames,
    required this.selectedLayout,
    required this.layouts,
    required this.printCopies,
    required this.guestUploadsEnabled,
    required this.sendGalleryTomorrow,
    required this.onThemeChanged,
    required this.onLayoutChanged,
    required this.onPrintCopiesChanged,
    required this.onGuestUploadsChanged,
    required this.onGalleryFollowUpChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.tune,
            title: 'Booth Setup',
            subtitle: 'Choose the app theme, print count, and gallery behavior.',
          ),
          const SizedBox(height: 16),
          _DropdownField(
            label: 'Event Theme',
            value: selectedThemeName,
            items: themeNames,
            onChanged: onThemeChanged,
          ),
          const SizedBox(height: 16),
          _DropdownField(
            label: 'Photo Layout',
            value: selectedLayout,
            items: layouts,
            onChanged: onLayoutChanged,
          ),
          const SizedBox(height: 16),
          _PrintCopiesStepper(copies: printCopies, onChanged: onPrintCopiesChanged),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Guest Uploads'),
            subtitle: const Text('Allow guests to upload photos to the gallery.'),
            value: guestUploadsEnabled,
            onChanged: onGuestUploadsChanged,
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Send Gallery Tomorrow'),
            subtitle: const Text('Schedule gallery follow-up for the customer.'),
            value: sendGalleryTomorrow,
            onChanged: onGalleryFollowUpChanged,
          ),
        ],
      ),
    );
  }
}

class _CountdownSection extends StatelessWidget {
  final int countdownSeconds;
  final int delayBetweenPhotosSeconds;
  final bool showSmileMessage;
  final bool flashScreenEnabled;
  final bool soundEnabled;
  final bool retakeEnabled;
  final ValueChanged<int> onCountdownChanged;
  final ValueChanged<int> onDelayChanged;
  final ValueChanged<bool> onSmileChanged;
  final ValueChanged<bool> onFlashChanged;
  final ValueChanged<bool> onSoundChanged;
  final ValueChanged<bool> onRetakeChanged;

  const _CountdownSection({
    required this.countdownSeconds,
    required this.delayBetweenPhotosSeconds,
    required this.showSmileMessage,
    required this.flashScreenEnabled,
    required this.soundEnabled,
    required this.retakeEnabled,
    required this.onCountdownChanged,
    required this.onDelayChanged,
    required this.onSmileChanged,
    required this.onFlashChanged,
    required this.onSoundChanged,
    required this.onRetakeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.timer,
            title: 'Capture Countdown',
            subtitle: 'Prepare the guest-facing countdown flow before each photo.',
          ),
          const SizedBox(height: 16),
          _SegmentedNumberChooser(
            label: 'Countdown Length',
            value: countdownSeconds,
            values: const [3, 5, 10],
            suffix: 'sec',
            onChanged: onCountdownChanged,
          ),
          const SizedBox(height: 12),
          _SegmentedNumberChooser(
            label: 'Delay Between Strip Photos',
            value: delayBetweenPhotosSeconds,
            values: const [2, 3, 5],
            suffix: 'sec',
            onChanged: onDelayChanged,
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Show “Smile!” Message'),
            value: showSmileMessage,
            onChanged: onSmileChanged,
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Flash Screen Effect'),
            value: flashScreenEnabled,
            onChanged: onFlashChanged,
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Countdown Sound'),
            value: soundEnabled,
            onChanged: onSoundChanged,
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Allow Retake Before Print'),
            value: retakeEnabled,
            onChanged: onRetakeChanged,
          ),
        ],
      ),
    );
  }
}

class _SegmentedNumberChooser extends StatelessWidget {
  final String label;
  final int value;
  final List<int> values;
  final String suffix;
  final ValueChanged<int> onChanged;

  const _SegmentedNumberChooser({
    required this.label,
    required this.value,
    required this.values,
    required this.suffix,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: values.map((option) {
            return ChoiceChip(
              selected: value == option,
              label: Text('$option $suffix'),
              onSelected: (_) => onChanged(option),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _NotesSection extends StatelessWidget {
  final TextEditingController controller;

  const _NotesSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.notes,
            title: 'Operator Notes',
            subtitle: 'Optional notes for setup, timing, venue, or customer requests.',
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Notes'),
            minLines: 3,
            maxLines: 5,
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SectionTitle({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: colorScheme.primary),
        const SizedBox(width: 12),
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

class _DropdownField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final Map<String, String> itemLabels;
  final ValueChanged<String> onChanged;

  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.itemLabels = const {},
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(labelText: label),
      items: items
          .map(
            (item) => DropdownMenuItem(
              value: item,
              child: Text(itemLabels[item] ?? item),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value != null) {
          onChanged(value);
        }
      },
    );
  }
}

class _PrintCopiesStepper extends StatelessWidget {
  final int copies;
  final ValueChanged<int> onChanged;

  const _PrintCopiesStepper({
    required this.copies,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Print Copies', style: TextStyle(fontSize: 18)),
        Row(
          children: [
            IconButton(
              tooltip: 'Decrease print copies',
              onPressed: copies > 1 ? () => onChanged(copies - 1) : null,
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Text('$copies', style: const TextStyle(fontSize: 22)),
            IconButton(
              tooltip: 'Increase print copies',
              onPressed: copies < 10 ? () => onChanged(copies + 1) : null,
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
      ],
    );
  }
}
