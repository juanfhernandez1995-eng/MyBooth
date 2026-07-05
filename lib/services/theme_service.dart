import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const String _storageKey = 'mybooth_selected_theme_id';

  Future<String?> loadSelectedThemeId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_storageKey);
  }

  Future<void> saveSelectedThemeId(String themeId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, themeId);
  }
}
