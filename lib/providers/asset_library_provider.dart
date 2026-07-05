import 'package:flutter/material.dart';

import '../models/booth_asset.dart';
import '../services/template_library_service.dart';

class AssetLibraryProvider extends ChangeNotifier {
  final TemplateLibraryService _service;
  late final List<BoothTemplate> _templates;
  late final List<BackgroundPack> _backgroundPacks;

  AssetLibraryProvider({TemplateLibraryService? service}) : _service = service ?? TemplateLibraryService() {
    _templates = _service.loadStarterTemplates();
    _backgroundPacks = _service.loadStarterBackgroundPacks();
  }

  List<BoothTemplate> get templates => List.unmodifiable(_templates);
  List<BackgroundPack> get backgroundPacks => List.unmodifiable(_backgroundPacks);

  BoothTemplate get defaultTemplate => _templates.first;
  BackgroundPack get defaultBackgroundPack => _backgroundPacks.first;

  BoothTemplate? getTemplateById(String id) {
    try {
      return _templates.firstWhere((template) => template.id == id);
    } catch (_) {
      return null;
    }
  }

  BackgroundPack? getBackgroundPackById(String id) {
    try {
      return _backgroundPacks.firstWhere((pack) => pack.id == id);
    } catch (_) {
      return null;
    }
  }

  List<BoothTemplate> templatesForOccasion(String occasion) {
    final normalized = occasion.toLowerCase();
    final category = switch (normalized) {
      'wedding' => TemplateCategory.wedding,
      'baptism' => TemplateCategory.baptism,
      'birthday' => TemplateCategory.birthday,
      'corporate' => TemplateCategory.corporate,
      _ => null,
    };

    if (category == null) {
      return templates;
    }

    final matches = _templates.where((template) => template.category == category).toList();
    return matches.isEmpty ? templates : matches;
  }
}
