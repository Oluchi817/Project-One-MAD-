// S2 Create / Edit Event Form - Marquez J

import 'package:flutter/material.dart';
import '../data/event_store.dart';
import '../models/event.dart';

class S2CreateEditEventScreen extends StatefulWidget {
  /// Pass an event to edit it. Leave null to create a new one.
  const S2CreateEditEventScreen({super.key, this.event});

  final Event? event;

  @override
  State<S2CreateEditEventScreen> createState() => _S2CreateEditEventScreenState();
}

class _S2CreateEditEventScreenState extends State<S2CreateEditEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _venueController = TextEditingController();
  final _capacityController = TextEditingController();
  final _dateController = TextEditingController();
  String _selectedTag = kEventTags.first;
  DateTime? _selectedDate;
  bool _saving = false;

  bool get _isEditing => widget.event != null;

  @override
  void initState() {
    super.initState();
    final e = widget.event;
    if (e != null) {
      _titleController.text = e.title;
      _venueController.text = e.venue;
      _capacityController.text = e.capacity.toString();
      _selectedTag = e.tag;
      _selectedDate = e.startsAt;
      _dateController.text = formatDate(e.startsAt);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _venueController.dispose();
    _capacityController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _selectedDate = picked;
      _dateController.text = formatDate(picked);
    });
  }

  void _saveEvent() {
    if (_saving) return; // block double taps
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final store = EventStore.instance;
    final title = _titleController.text.trim();
    final venue = _venueController.text.trim();
    final capacity = int.parse(_capacityController.text.trim());
    final date = _selectedDate!;

    final existing = widget.event;
    if (existing == null) {
      store.add(
        title: title,
        tag: _selectedTag,
        venue: venue,
        startsAt: date,
        capacity: capacity,
      );
    } else {
      store.edit(
        existing.id,
        title: title,
        tag: _selectedTag,
        venue: venue,
        startsAt: date,
        capacity: capacity,
      );
    }
    Navigator.pop(context);
  }

  void _confirmDelete() {
    final existing = widget.event;
    if (existing == null) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Delete Event?', style: TextStyle(color: Color(0xFFFF1744))),
        content: const Text('This will remove the event and its attendance record.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Keep', style: TextStyle(color: Colors.black54)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFFF1744)),
            onPressed: () {
              Navigator.pop(ctx);
              EventStore.instance.remove(existing.id);
              // Back to the catalog (the detail screen is gone too).
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  InputDecoration _decoration(String label, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      suffixIcon: suffixIcon,
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFFF8A50), width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Event' : 'New Event'),
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
                decoration: _decoration('Event Title *'),
                validator: (val) {
                  final v = val?.trim() ?? '';
                  if (v.length < 2 || v.length > 60) {
                    return 'Title must be 2 to 60 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedTag,
                decoration: _decoration('Category Tag'),
                items: kEventTags.map((t) {
                  return DropdownMenuItem(value: t, child: Text(t));
                }).toList(),
                onChanged: (val) =>
                    setState(() => _selectedTag = val ?? kEventTags.first),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                onTap: _pickDate,
                decoration: _decoration(
                  'Date *',
                  suffixIcon: const Icon(Icons.calendar_today, color: Color(0xFFFF8A50)),
                ),
                validator: (val) =>
                    (val == null || val.isEmpty) ? 'Pick a date' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _venueController,
                decoration: _decoration('Venue Note'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _capacityController,
                keyboardType: TextInputType.number,
                decoration: _decoration('Capacity (1 to 500) *'),
                validator: (val) {
                  final n = int.tryParse(val?.trim() ?? '');
                  if (n == null || n < 1 || n > 500) {
                    return 'Capacity must be a number from 1 to 500';
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
                onPressed: _saving ? null : _saveEvent,
                child: const Text('Save Event', style: TextStyle(fontSize: 16)),
              ),
              if (_isEditing) ...[
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _confirmDelete,
                  child: const Text(
                    'Delete Event',
                    style: TextStyle(color: Color(0xFFFF1744)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}