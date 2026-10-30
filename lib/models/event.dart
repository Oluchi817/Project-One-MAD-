// Event model shared by all screens

enum EventStatus { none, planned, attended, cancelled }

class Event {
  Event({
    required this.id,
    required this.title,
    required this.tag,
    required this.venue,
    required this.startsAt,
    required this.capacity,
    this.status = EventStatus.none,
    this.reflection = '',
  });

  final int id;
  String title;
  String tag;
  String venue;
  DateTime startsAt;
  int capacity;
  EventStatus status;
  String reflection;
}

const List<String> kEventTags = ['Music', 'Tech', 'Art', 'Sports', 'Food'];

String formatDate(DateTime d) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '${months[d.month - 1]} ${d.day}, ${d.year}';
}
