// S1 Catalog / Dashboard - Marquez J

import 'package:flutter/material.dart';
import '../data/event_store.dart';
import '../models/event.dart';
import 's2_create_edit_event.dart';
import 's3_event_detail.dart';

class S1CatalogDashboardScreen extends StatefulWidget {
  const S1CatalogDashboardScreen({super.key});

  @override
  State<S1CatalogDashboardScreen> createState() => _S1CatalogDashboardScreenState();
}

class _S1CatalogDashboardScreenState extends State<S1CatalogDashboardScreen> {
  String? _selectedTag;

  @override
  Widget build(BuildContext context) {
    final store = EventStore.instance;

    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final all = store.events;
        final shown = _selectedTag == null
            ? all
            : all.where((e) => e.tag == _selectedTag).toList();

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Festival Pocket'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Chip(
                  backgroundColor: const Color(0xFFFFF9C4), // Light yellow accent
                  label: Text(
                    '★ ${store.attendedCount} Attended',
                    style: const TextStyle(
                      color: Color(0xFFE65100),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: const Color(0xFFFF8A50), // Warm orange
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add),
            label: const Text('Add Event'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const S2CreateEditEventScreen(),
                ),
              );
            },
          ),
          body: Column(
            children: [
              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: kEventTags.map((tag) {
                    final isSelected = _selectedTag == tag;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        label: Text(tag),
                        selected: isSelected,
                        selectedColor: const Color(0xFFFF8A50),
                        backgroundColor: Colors.white,
                        showCheckmark: false,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        side: BorderSide(
                          color: isSelected ? const Color(0xFFFF8A50) : Colors.orange.shade100,
                        ),
                        onSelected: (selected) {
                          setState(() => _selectedTag = selected ? tag : null);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const Divider(height: 1),

              // Event list
              Expanded(
                child: shown.isEmpty
                    ? _EmptyState(
                        filtered: _selectedTag != null && all.isNotEmpty,
                        onClear: () => setState(() => _selectedTag = null),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: shown.length,
                        itemBuilder: (context, i) => _EventCard(event: shown[i]),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.filtered, required this.onClear});

  final bool filtered;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.festival_outlined, size: 48, color: Color(0xFFFF8A50)),
            const SizedBox(height: 12),
            Text(
              filtered
                  ? 'No events match this tag.'
                  : 'No events yet. Add your first event.',
              textAlign: TextAlign.center,
            ),
            if (filtered)
              TextButton(onPressed: onClear, child: const Text('Clear filter')),
          ],
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    final attended = event.status == EventStatus.attended;
    final venue = event.venue.isEmpty ? '' : ' • ${event.venue}';

    return Card(
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF9C4),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            attended ? Icons.check_circle : Icons.festival,
            color: attended ? Colors.green : const Color(0xFFFF8A50),
          ),
        ),
        title: Text(event.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('#${event.tag} • ${formatDate(event.startsAt)}$venue'),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFFFF8A50)),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => S3EventDetailScreen(eventId: event.id),
            ),
          );
        },
      ),
    );
  }
}