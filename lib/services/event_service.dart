import '../models/event.dart';

class EventService {
  static final List<BoothEvent> _events = [];

  static List<BoothEvent> getEvents() {
    return _events;
  }

  static void addEvent(BoothEvent event) {
    _events.add(event);
  }

  static void deleteEvent(BoothEvent event) {
    _events.remove(event);
  }
}