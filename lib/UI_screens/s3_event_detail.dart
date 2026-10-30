// S3 Event Detail / Activity - Marquez J

import 'package:flutter/material.dart';
import '../data/event_store.dart';
import '../models/event.dart';
import 's2_create_edit_event.dart';

class S3EventDetailScreen extends StatefulWidget {
  const S3EventDetailScreen({super.key, required this.eventId});

  final int eventId;

  @override
  State<S3EventDetailScreen> createState() => _S3EventDetailScreenState();
}

class _S3EventDetailScreenState extends State<S3EventDetailScreen> {
  final _store = EventStore.instance;

  /// Start plan -> Mark attended -> Edit reflection
  void _progressStatus(Event event) {
    switch (event.status) {
      case EventStatus.none:
      case EventStatus.cancelled:
        _store.setStatus(event.id, EventStatus.planned);
      case EventStatus.planned:
        _store.setStatus(event.id, EventStatus.attended);
      case EventStatus.attended:
        _editReflection(event);
    }
  }

  void _editReflection(Event event) {
    final controller = TextEditingController(text: event.reflection);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Reflection'),
        content: TextField(
          controller: controller,
          maxLines: 4,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'How was it?'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.black54)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFFF8A50)),
            onPressed: () {
              _store.setReflection(event.id, controller.text.trim());
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    ).then((_) => controller.dispose());
  }

  void _confirmDelete(Event event) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Delete Event?', style: TextStyle(color: Color(0xFFFF1744))), // Bright red alert
        content: const Text('This will remove the event and its attendance record.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Keep', style: TextStyle(color: Colors.black54)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFFF1744)), // Red alert action
            onPressed: () {
              Navigator.pop(ctx);
              _store.remove(event.id);
              Navigator.pop(context); // Pop back to where we came from
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _buttonLabel(EventStatus status) {
    switch (status) {
      case EventStatus.none:
        return 'Start Plan';
      case EventStatus.planned:
        return 'Mark Attended';
      case EventStatus.cancelled:
        return 'Plan Again';
      case EventStatus.attended:
        return 'Edit Reflection';
    }
  }

  String _statusText(EventStatus status) {
    switch (status) {
      case EventStatus.none:
        return 'Not planned yet';
      case EventStatus.planned:
        return 'Planned — ready to attend!';
      case EventStatus.cancelled:
        return 'Cancelled';
      case EventStatus.attended:
        return 'ATTENDED';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _store,
      builder: (context, _) {
        final event = _store.byId(widget.eventId);

        // Event was deleted while this screen was open.
        if (event == null) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(title: const Text('Event Pass')),
            body: const Center(child: Text('This event no longer exists.')),
          );
        }

        final attended = event.status == EventStatus.attended;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Event Pass'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => S2CreateEditEventScreen(event: event),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Color(0xFFFF1744)),
                onPressed: () => _confirmDelete(event),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                GestureDetector(
                  onLongPress: () => _progressStatus(event), // shortcut
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '#${event.tag}',
                                  style: const TextStyle(
                                    color: Color(0xFFFF8A50),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Chip(
                                  backgroundColor: attended
                                      ? Colors.green.shade100
                                      : const Color(0xFFFFF9C4),
                                  label: Text(
                                    event.status.name.toUpperCase(),
                                    style: TextStyle(
                                      color: attended
                                          ? Colors.green.shade800
                                          : const Color(0xFFE65100),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              event.title,
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            if (event.venue.isNotEmpty) Text('📍 ${event.venue}'),
                            Text('📅 ${formatDate(event.startsAt)}'),
                            Text('👥 Capacity ${event.capacity}'),
                            const Divider(height: 28),
                            Center(
                              child: Text(
                                attended
                                    ? '★ REFLECTION STAMP: ATTENDED ★'
                                    : _statusText(event.status),
                                style: TextStyle(
                                  color: attended ? Colors.green : Colors.grey.shade600,
                                  fontWeight: attended ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                            if (attended && event.reflection.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Text(event.reflection),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFFF8A50),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => _progressStatus(event),
                    child: Text(_buttonLabel(event.status)),
                  ),
                ),
                const SizedBox(height: 10),
                if (event.status == EventStatus.planned || attended)
                  TextButton(
                    onPressed: () => _store.setStatus(event.id, EventStatus.cancelled),
                    child: const Text(
                      'Cancel Attendance',
                      style: TextStyle(color: Color(0xFFFF1744)),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}