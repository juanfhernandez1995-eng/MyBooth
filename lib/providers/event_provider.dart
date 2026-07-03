import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/event.dart';

class EventProvider extends ChangeNotifier {
  static const String _storageKey = 'mybooth_events';

  final List<BoothEvent> _events = [];
  bool _isLoading = true;

  List<BoothEvent> get events => List.unmodifiable(_events);
  bool get isLoading => _isLoading;

  Future<void> loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEvents = prefs.getStringList(_storageKey) ?? [];

    _events.clear();

    for (final eventJson in savedEvents) {
      final decoded = jsonDecode(eventJson);
      _events.add(BoothEvent.fromJson(decoded));
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addEvent(BoothEvent event) async {
    _events.add(event);
    await _saveEvents();
    notifyListeners();
  }

  Future<void> deleteEvent(BoothEvent event) async {
    _events.remove(event);
    await _saveEvents();
    notifyListeners();
  }

  BoothEvent? getEventById(String id) {
    try {
      return _events.firstWhere((event) => event.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveEvents() async {
    final prefs = await SharedPreferences.getInstance();

    final encodedEvents = _events.map((event) {
      return jsonEncode(event.toJson());
    }).toList();

    await prefs.setStringList(_storageKey, encodedEvents);
  }
}