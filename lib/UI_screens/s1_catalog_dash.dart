// S1 Catalog / Dashboard - Marquez J

import 'package:flutter/material.dart';
import 's2_create_edit_event.dart';
import 's3_event_detail.dart';

class S1CatalogDashboardScreen extends StatefulWidget {
  const S1CatalogDashboardScreen({super.key});

  @override
  State<S1CatalogDashboardScreen> createState() => _S1CatalogDashboardScreenState();
}

class _S1CatalogDashboardScreenState extends State<S1CatalogDashboardScreen> {
  String? _selectedTag;
  final int _attendedCount = 0; // TODO: Query attendance records

  final List<String> _tags = ['Music', 'Tech', 'Art', 'Sports', 'Food'];

  @override
  Widget build(BuildContext context) {
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
                '★ $_attendedCount Attended',
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
              children: _tags.map((tag) {
                final isSelected = _selectedTag == tag;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(tag),
                    selected: isSelected,
                    selectedColor: const Color(0xFFFF8A50),
                    backgroundColor: Colors.white,
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

          // Starter Event List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF9C4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.festival, color: Color(0xFFFF8A50)),
                    ),
                    title: const Text('Campus Sound Clash', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('Nov 12 • Student Amphitheater'),
                    trailing: const Icon(Icons.chevron_right, color: Color(0xFFFF8A50)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const S3EventDetailScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}