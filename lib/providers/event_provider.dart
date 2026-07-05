import 'package:flutter/material.dart';

import '../models/event.dart';
import '../services/event_service.dart';

class EventProvider extends ChangeNotifier {
  final EventService _eventService;
  final List<BoothEvent> _events = [];
  bool _isLoading = true;

  EventProvider({EventService? eventService})
      : _eventService = eventService ?? EventService();

  List<BoothEvent> get events => List.unmodifiable(_events);
  bool get isLoading => _isLoading;

  BoothEvent? get latestEvent {
    if (_events.isEmpty) {
      return null;
    }

    return _events.first;
  }

  Future<void> loadEvents() async {
    final loadedEvents = await _eventService.loadEvents();

    _events
      ..clear()
      ..addAll(_sortEvents(loadedEvents));

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addEvent(BoothEvent event) async {
    _events
      ..add(event)
      ..sort(_compareNewestFirst);

    await _eventService.saveEvents(_events);
    notifyListeners();
  }

  Future<void> updateEvent(BoothEvent updatedEvent) async {
    final index = _events.indexWhere((event) => event.id == updatedEvent.id);

    if (index == -1) {
      return;
    }

    _events[index] = updatedEvent;
    _events.sort(_compareNewestFirst);

    await _eventService.saveEvents(_events);
    notifyListeners();
  }

  Future<void> deleteEvent(BoothEvent event) async {
    _events.removeWhere((savedEvent) => savedEvent.id == event.id);
    await _eventService.saveEvents(_events);
    notifyListeners();
  }

  BoothEvent? getEventById(String id) {
    try {
      return _events.firstWhere((event) => event.id == id);
    } catch (_) {
      return null;
    }
  }

  List<BoothEvent> _sortEvents(List<BoothEvent> events) {
    return List<BoothEvent>.from(events)..sort(_compareNewestFirst);
  }

  int _compareNewestFirst(BoothEvent a, BoothEvent b) {
    return b.createdAt.compareTo(a.createdAt);
  }
}
