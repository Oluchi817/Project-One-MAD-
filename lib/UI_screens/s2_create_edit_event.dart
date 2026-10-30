// S2 Create / Edit Event Form - Marquez J

import 'package:flutter/material.dart';

class S2CreateEditEventScreen extends StatefulWidget {
  const S2CreateEditEventScreen({super.key});

  @override
  State<S2CreateEditEventScreen> createState() => _S2CreateEditEventScreenState();
}

class _S2CreateEditEventScreenState extends State<S2CreateEditEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _venueController = TextEditingController();
  final _capacityController = TextEditingController();
  String _selectedTag = 'Music';

  @override
  void dispose() {
    _titleController.dispose();
    _venueController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  void _saveEvent() {
    if (!_formKey.currentState!.validate()) return;
    // TODO: Connect to SQLite insert/update
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('New Event'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Event Title *',
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFFF8A50), width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (val) =>
                    (val == null || val.trim().isEmpty) ? 'Title cannot be empty' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedTag,
                decoration: InputDecoration(
                  labelText: 'Category Tag',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: ['Music', 'Tech', 'Art', 'Sports', 'Food'].map((t) {
                  return DropdownMenuItem(value: t, child: Text(t));
                }).toList>,
                onChanged: (val) => setState(() => _selectedTag = val ?? 'Music'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _venueController,
                decoration: InputDecoration(
                  labelText: 'Venue Note',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _capacityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Capacity (Numeric)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (val) {
                  if (val != null && val.trim().isNotEmpty && int.tryParse(val.trim()) == null) {
                    return 'Must be a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFFF8A50),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _saveEvent,
                child: const Text('Save Event', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}