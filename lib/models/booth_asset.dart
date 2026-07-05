import 'package:flutter/material.dart';

enum TemplateCategory {
  wedding,
  baptism,
  birthday,
  corporate,
  seasonal,
}

enum BoothPrintLayout {
  strip2x6,
  print4x6,
}

class TemplateColorPalette {
  final String id;
  final String name;
  final Color primary;
  final Color secondary;
  final Color accent;

  const TemplateColorPalette({
    required this.id,
    required this.name,
    required this.primary,
    required this.secondary,
    required this.accent,
  });

  String get displayName => name;
}

class TemplateTextSlot {
  final String key;
  final String label;
  final String placeholder;
  final bool required;

  const TemplateTextSlot({
    required this.key,
    required this.label,
    required this.placeholder,
    this.required = false,
  });
}

class BoothTemplate {
  final String id;
  final String familyId;
  final String name;
  final TemplateCategory category;
  final BoothPrintLayout layout;
  final String description;
  final int photoSlots;
  final List<TemplateColorPalette> palettes;
  final List<TemplateTextSlot> textSlots;
  final bool supportsGreenScreen;

  const BoothTemplate({
    required this.id,
    required this.familyId,
    required this.name,
    required this.category,
    required this.layout,
    required this.description,
    required this.photoSlots,
    required this.palettes,
    required this.textSlots,
    required this.supportsGreenScreen,
  });

  String get layoutLabel {
    switch (layout) {
      case BoothPrintLayout.strip2x6:
        return '2x6 Strip';
      case BoothPrintLayout.print4x6:
        return '4x6 Print';
    }
  }

  String get categoryLabel {
    switch (category) {
      case TemplateCategory.wedding:
        return 'Wedding';
      case TemplateCategory.baptism:
        return 'Baptism';
      case TemplateCategory.birthday:
        return 'Birthday';
      case TemplateCategory.corporate:
        return 'Corporate';
      case TemplateCategory.seasonal:
        return 'Seasonal';
    }
  }

  TemplateColorPalette paletteById(String? paletteId) {
    return palettes.firstWhere(
      (palette) => palette.id == paletteId,
      orElse: () => palettes.first,
    );
  }
}

class BackgroundPack {
  final String id;
  final String name;
  final String category;
  final String description;
  final int backgroundCount;
  final bool greenScreenReady;

  const BackgroundPack({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.backgroundCount,
    required this.greenScreenReady,
  });
}

class CaptureSettings {
  final int countdownSeconds;
  final int delayBetweenPhotosSeconds;
  final bool showSmileMessage;
  final bool flashScreenEnabled;
  final bool soundEnabled;
  final bool retakeEnabled;

  const CaptureSettings({
    required this.countdownSeconds,
    required this.delayBetweenPhotosSeconds,
    required this.showSmileMessage,
    required this.flashScreenEnabled,
    required this.soundEnabled,
    required this.retakeEnabled,
  });

  static const CaptureSettings defaults = CaptureSettings(
    countdownSeconds: 3,
    delayBetweenPhotosSeconds: 3,
    showSmileMessage: true,
    flashScreenEnabled: true,
    soundEnabled: true,
    retakeEnabled: true,
  );

  Map<String, dynamic> toJson() {
    return {
      'countdownSeconds': countdownSeconds,
      'delayBetweenPhotosSeconds': delayBetweenPhotosSeconds,
      'showSmileMessage': showSmileMessage,
      'flashScreenEnabled': flashScreenEnabled,
      'soundEnabled': soundEnabled,
      'retakeEnabled': retakeEnabled,
    };
  }

  factory CaptureSettings.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return defaults;
    }

    return CaptureSettings(
      countdownSeconds: json['countdownSeconds'] as int? ?? defaults.countdownSeconds,
      delayBetweenPhotosSeconds: json['delayBetweenPhotosSeconds'] as int? ?? defaults.delayBetweenPhotosSeconds,
      showSmileMessage: json['showSmileMessage'] as bool? ?? defaults.showSmileMessage,
      flashScreenEnabled: json['flashScreenEnabled'] as bool? ?? defaults.flashScreenEnabled,
      soundEnabled: json['soundEnabled'] as bool? ?? defaults.soundEnabled,
      retakeEnabled: json['retakeEnabled'] as bool? ?? defaults.retakeEnabled,
    );
  }
}

class PhotoStoragePlan {
  static const String root = 'mybooth_data';

  static const List<String> eventFolders = [
    'captures/original',
    'captures/processed',
    'captures/composited',
    'captures/bordered',
    'captures/thumbnails',
    'prints/strips',
    'prints/reprints',
    'gallery/final',
    'gallery/qr',
    'gallery/google_photos_exports',
    'logs',
  ];

  static const List<String> assetFolders = [
    'assets/backgrounds/wedding',
    'assets/backgrounds/baptism',
    'assets/backgrounds/birthday',
    'assets/backgrounds/corporate',
    'assets/templates/wedding',
    'assets/templates/baptism',
    'assets/templates/birthday',
    'assets/templates/corporate',
    'assets/borders/2x6',
    'assets/borders/4x6',
  ];
}
