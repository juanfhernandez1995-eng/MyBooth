import 'package:flutter/material.dart';

import '../models/mybooth_theme.dart';
import '../services/theme_service.dart';

class ThemeProvider extends ChangeNotifier {
  static const List<MyBoothTheme> availableThemes = [
    MyBoothTheme(
      id: 'classic',
      name: 'Classic Purple',
      description: 'Clean MyBooth default theme for general events.',
      primaryColor: Colors.deepPurple,
      accentColor: Colors.purpleAccent,
      backgroundColor: Color(0xFFF8F5FF),
      icon: Icons.camera_alt,
    ),
    MyBoothTheme(
      id: 'wedding',
      name: 'Wedding Gold',
      description: 'Warm premium look for weddings and formal events.',
      primaryColor: Color(0xFFD4AF37),
      accentColor: Color(0xFF7A5C00),
      backgroundColor: Color(0xFFFFFBEE),
      icon: Icons.favorite,
    ),
    MyBoothTheme(
      id: 'birthday',
      name: 'Birthday Confetti',
      description: 'Bright, playful styling for parties and birthdays.',
      primaryColor: Colors.pink,
      accentColor: Colors.orange,
      backgroundColor: Color(0xFFFFF4FA),
      icon: Icons.cake,
    ),
    MyBoothTheme(
      id: 'graduation',
      name: 'Graduation Blue',
      description: 'Polished school-event theme with a strong blue brand.',
      primaryColor: Colors.indigo,
      accentColor: Colors.lightBlueAccent,
      backgroundColor: Color(0xFFF3F6FF),
      icon: Icons.school,
    ),
    MyBoothTheme(
      id: 'corporate',
      name: 'Corporate Black',
      description: 'Simple modern style for conferences and brand activations.',
      primaryColor: Color(0xFF212121),
      accentColor: Color(0xFF757575),
      backgroundColor: Color(0xFFF6F6F6),
      icon: Icons.business,
    ),
    MyBoothTheme(
      id: 'holiday',
      name: 'Holiday Red',
      description: 'Festive event style for seasonal celebrations.',
      primaryColor: Colors.red,
      accentColor: Colors.green,
      backgroundColor: Color(0xFFFFF5F5),
      icon: Icons.celebration,
    ),
  ];

  final ThemeService _themeService;
  MyBoothTheme _currentTheme = availableThemes.first;
  bool _isLoading = true;

  ThemeProvider({ThemeService? themeService})
      : _themeService = themeService ?? ThemeService();

  List<MyBoothTheme> get themes => List.unmodifiable(availableThemes);
  MyBoothTheme get currentTheme => _currentTheme;
  bool get isLoading => _isLoading;

  bool isSelected(String themeId) => _currentTheme.id == themeId;

  Future<void> loadTheme() async {
    final savedThemeId = await _themeService.loadSelectedThemeId();

    if (savedThemeId != null) {
      _currentTheme = _themeById(savedThemeId);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> selectTheme(String themeId) async {
    final nextTheme = _themeById(themeId);

    if (nextTheme.id == _currentTheme.id) {
      return;
    }

    _currentTheme = nextTheme;
    notifyListeners();
    await _themeService.saveSelectedThemeId(nextTheme.id);
  }

  MyBoothTheme themeByName(String name) {
    return availableThemes.firstWhere(
      (theme) => theme.name == name,
      orElse: () => availableThemes.first,
    );
  }

  MyBoothTheme _themeById(String id) {
    return availableThemes.firstWhere(
      (theme) => theme.id == id,
      orElse: () => availableThemes.first,
    );
  }
}
