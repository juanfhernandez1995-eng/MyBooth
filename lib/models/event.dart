import 'booth_asset.dart';

enum EventStatus {
  draft,
  ready,
  live,
  completed,
}

class BoothEvent {
  final String id;
  final String eventName;
  final String customerName;
  final String customerEmail;
  final String occasion;
  final String eventTheme;
  final DateTime eventDate;
  final DateTime createdAt;
  final String photoLayout;
  final int printCopies;
  final bool guestUploadsEnabled;
  final bool sendGalleryTomorrow;
  final EventStatus status;
  final String notes;
  final String honoreeName;
  final String eventSubtitle;
  final String templateId;
  final String templateName;
  final String templateCategory;
  final String templatePaletteId;
  final String templatePaletteName;
  final String backgroundPackId;
  final String backgroundPackName;
  final bool greenScreenEnabled;
  final CaptureSettings captureSettings;

  const BoothEvent({
    required this.id,
    required this.eventName,
    required this.customerName,
    required this.customerEmail,
    required this.occasion,
    required this.eventTheme,
    required this.eventDate,
    required this.createdAt,
    required this.photoLayout,
    required this.printCopies,
    required this.guestUploadsEnabled,
    required this.sendGalleryTomorrow,
    required this.status,
    required this.notes,
    this.honoreeName = '',
    this.eventSubtitle = '',
    this.templateId = 'wedding_floral_2x6',
    this.templateName = 'Wedding Floral Strip',
    this.templateCategory = 'Wedding',
    this.templatePaletteId = 'rose_gold',
    this.templatePaletteName = 'Rose Gold',
    this.backgroundPackId = 'bg_wedding_romance',
    this.backgroundPackName = 'Wedding Romance',
    this.greenScreenEnabled = false,
    this.captureSettings = CaptureSettings.defaults,
  });

  String get displayName {
    return eventName.trim().isEmpty ? 'Untitled Event' : eventName.trim();
  }

  String get displayDate {
    return '${eventDate.month}/${eventDate.day}/${eventDate.year}';
  }

  String get displayHonoree {
    return honoreeName.trim().isEmpty ? customerName.trim() : honoreeName.trim();
  }

  String get templateSummary {
    return '$templateName • $templatePaletteName';
  }

  String get captureSummary {
    return '${captureSettings.countdownSeconds}s countdown • ${captureSettings.delayBetweenPhotosSeconds}s between photos';
  }

  String get statusLabel {
    switch (status) {
      case EventStatus.draft:
        return 'Draft';
      case EventStatus.ready:
        return 'Ready';
      case EventStatus.live:
        return 'Live';
      case EventStatus.completed:
        return 'Completed';
    }
  }

  BoothEvent copyWith({
    String? id,
    String? eventName,
    String? customerName,
    String? customerEmail,
    String? occasion,
    String? eventTheme,
    DateTime? eventDate,
    DateTime? createdAt,
    String? photoLayout,
    int? printCopies,
    bool? guestUploadsEnabled,
    bool? sendGalleryTomorrow,
    EventStatus? status,
    String? notes,
    String? honoreeName,
    String? eventSubtitle,
    String? templateId,
    String? templateName,
    String? templateCategory,
    String? templatePaletteId,
    String? templatePaletteName,
    String? backgroundPackId,
    String? backgroundPackName,
    bool? greenScreenEnabled,
    CaptureSettings? captureSettings,
  }) {
    return BoothEvent(
      id: id ?? this.id,
      eventName: eventName ?? this.eventName,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      occasion: occasion ?? this.occasion,
      eventTheme: eventTheme ?? this.eventTheme,
      eventDate: eventDate ?? this.eventDate,
      createdAt: createdAt ?? this.createdAt,
      photoLayout: photoLayout ?? this.photoLayout,
      printCopies: printCopies ?? this.printCopies,
      guestUploadsEnabled: guestUploadsEnabled ?? this.guestUploadsEnabled,
      sendGalleryTomorrow: sendGalleryTomorrow ?? this.sendGalleryTomorrow,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      honoreeName: honoreeName ?? this.honoreeName,
      eventSubtitle: eventSubtitle ?? this.eventSubtitle,
      templateId: templateId ?? this.templateId,
      templateName: templateName ?? this.templateName,
      templateCategory: templateCategory ?? this.templateCategory,
      templatePaletteId: templatePaletteId ?? this.templatePaletteId,
      templatePaletteName: templatePaletteName ?? this.templatePaletteName,
      backgroundPackId: backgroundPackId ?? this.backgroundPackId,
      backgroundPackName: backgroundPackName ?? this.backgroundPackName,
      greenScreenEnabled: greenScreenEnabled ?? this.greenScreenEnabled,
      captureSettings: captureSettings ?? this.captureSettings,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventName': eventName,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'occasion': occasion,
      'eventTheme': eventTheme,
      'eventDate': eventDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'photoLayout': photoLayout,
      'printCopies': printCopies,
      'guestUploadsEnabled': guestUploadsEnabled,
      'sendGalleryTomorrow': sendGalleryTomorrow,
      'status': status.name,
      'notes': notes,
      'honoreeName': honoreeName,
      'eventSubtitle': eventSubtitle,
      'templateId': templateId,
      'templateName': templateName,
      'templateCategory': templateCategory,
      'templatePaletteId': templatePaletteId,
      'templatePaletteName': templatePaletteName,
      'backgroundPackId': backgroundPackId,
      'backgroundPackName': backgroundPackName,
      'greenScreenEnabled': greenScreenEnabled,
      'captureSettings': captureSettings.toJson(),
    };
  }

  factory BoothEvent.fromJson(Map<String, dynamic> json) {
    final eventDate = DateTime.tryParse(json['eventDate'] as String? ?? '') ?? DateTime.now();
    final createdAt = DateTime.tryParse(json['createdAt'] as String? ?? '') ?? eventDate;
    final captureJson = json['captureSettings'];

    return BoothEvent(
      id: json['id'] as String? ?? '',
      eventName: json['eventName'] as String? ?? 'Untitled Event',
      customerName: json['customerName'] as String? ?? '',
      customerEmail: json['customerEmail'] as String? ?? '',
      occasion: json['occasion'] as String? ?? 'Custom',
      eventTheme: json['eventTheme'] as String? ?? 'Classic Purple',
      eventDate: eventDate,
      createdAt: createdAt,
      photoLayout: json['photoLayout'] as String? ?? '3-Photo Strip',
      printCopies: json['printCopies'] as int? ?? 2,
      guestUploadsEnabled: json['guestUploadsEnabled'] as bool? ?? true,
      sendGalleryTomorrow: json['sendGalleryTomorrow'] as bool? ?? true,
      status: _statusFromName(json['status'] as String?),
      notes: json['notes'] as String? ?? '',
      honoreeName: json['honoreeName'] as String? ?? '',
      eventSubtitle: json['eventSubtitle'] as String? ?? '',
      templateId: json['templateId'] as String? ?? 'wedding_floral_2x6',
      templateName: json['templateName'] as String? ?? 'Wedding Floral Strip',
      templateCategory: json['templateCategory'] as String? ?? 'Wedding',
      templatePaletteId: json['templatePaletteId'] as String? ?? 'rose_gold',
      templatePaletteName: json['templatePaletteName'] as String? ?? 'Rose Gold',
      backgroundPackId: json['backgroundPackId'] as String? ?? 'bg_wedding_romance',
      backgroundPackName: json['backgroundPackName'] as String? ?? 'Wedding Romance',
      greenScreenEnabled: json['greenScreenEnabled'] as bool? ?? false,
      captureSettings: CaptureSettings.fromJson(
        captureJson is Map<String, dynamic> ? captureJson : null,
      ),
    );
  }

  static EventStatus _statusFromName(String? statusName) {
    return EventStatus.values.firstWhere(
      (status) => status.name == statusName,
      orElse: () => EventStatus.ready,
    );
  }
}
