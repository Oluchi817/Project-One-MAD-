// In-memory event storage shared by every screen.
// TODO: swap the list for SQLite (sqflite) later.

import 'package:flutter/foundation.dart';
import '../models/event.dart';

class EventStore extends ChangeNotifier {
  EventStore._();
  static final EventStore instance = EventStore._();

  final List<Event> _events = [];
  int _nextId = 1;

  /// Events sorted by date (soonest first).
  List<Event> get events {
    final sorted = List<Event>.of(_events);
    sorted.sort((a, b) => a.startsAt.compareTo(b.startsAt));
    return sorted;
  }

  int get attendedCount =>
      _events.where((e) => e.status == EventStatus.attended).length;

  Event? byId(int id) {
    for (final e in _events) {
      if (e.id == id) return e;
    }
    return null;
  }

  Event add({
    required String title,
    required String tag,
    required String venue,
    required DateTime startsAt,
    required int capacity,
  }) {
    final event = Event(
      id: _nextId++,
      title: title,
      tag: tag,
      venue: venue,
      startsAt: startsAt,
      capacity: capacity,
    );
    _events.add(event);
    notifyListeners();
    return event;
  }

  void edit(
    int id, {
    required String title,
    required String tag,
    required String venue,
    required DateTime startsAt,
    required int capacity,
  }) {
    final event = byId(id);
    if (event == null) return;
    event.title = title;
    event.tag = tag;
    event.venue = venue;
    event.startsAt = startsAt;
    event.capacity = capacity;
    notifyListeners();
  }

  void setStatus(int id, EventStatus status) {
    final event = byId(id);
    if (event == null) return;
    event.status = status;
    notifyListeners();
  }

  void setReflection(int id, String text) {
    final event = byId(id);
    if (event == null) return;
    event.reflection = text;
    notifyListeners();
  }

  void remove(int id) {
    _events.removeWhere((e) => e.id == id);
    notifyListeners();
  }
}
