import 'package:flutter/material.dart';
import '../models/event.dart';

class EventService extends ChangeNotifier {
  final List<BoothEvent> _events = [];

  List<BoothEvent> get events => List.unmodifiable(_events);

  void addEvent(BoothEvent event) {
    _events.add(event);
    notifyListeners();
  }

  void deleteEvent(BoothEvent event) {
    _events.remove(event);
    notifyListeners();
  }

  BoothEvent? getEventById(String id) {
    try {
      return _events.firstWhere((event) => event.id == id);
    } catch (_) {
      return null;
    }
  }
}