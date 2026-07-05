import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/event.dart';

class EventService {
  static const String _storageKey = 'mybooth_events';

  Future<List<BoothEvent>> loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEvents = prefs.getStringList(_storageKey) ?? [];

    return savedEvents.map(_decodeEvent).whereType<BoothEvent>().toList();
  }

  Future<void> saveEvents(List<BoothEvent> events) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedEvents = events.map((event) => jsonEncode(event.toJson())).toList();

    await prefs.setStringList(_storageKey, encodedEvents);
  }

  BoothEvent? _decodeEvent(String eventJson) {
    try {
      final decoded = jsonDecode(eventJson) as Map<String, dynamic>;
      return BoothEvent.fromJson(decoded);
    } catch (_) {
      return null;
    }
  }
}
