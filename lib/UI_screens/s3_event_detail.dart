// S3 Event Detail / Activity - Marquez J

import 'package:flutter/material.dart';
import 's2_create_edit_event.dart';

class S3EventDetailScreen extends StatefulWidget {
  const S3EventDetailScreen({super.key});

  @override
  State<S3EventDetailScreen> createState() => _S3EventDetailScreenState();
}

class _S3EventDetailScreenState extends State<S3EventDetailScreen> {
  String _status = 'none'; // 'none', 'planned', 'attended'
  bool _isProcessing = false;

  void _progressStatus() {
    if (_isProcessing) return; // Prevent double taps
    setState(() => _isProcessing = true);

    setState(() {
      if (_status == 'none') {
        _status = 'planned';
      } else if (_status == 'planned') {
        _status = 'attended';
      }
      _isProcessing = false;
    });
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Delete Event?', style: TextStyle(color: Color(0xFFFF1744))), // Bright red alert
        content: const Text('This will remove the event and cascade delete its attendance record.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Keep', style: TextStyle(color: Colors.black54)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFFF1744)), // Red alert action
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context); // Pop back to catalog
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  builder: (context) => const S2CreateEditEventScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Color(0xFFFF1744)),
            onPressed: _confirmDelete,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '#Music • Campus',
                          style: TextStyle(color: Color(0xFFFF8A50), fontWeight: FontWeight.bold),
                        ),
                        Chip(
                          backgroundColor: _status == 'attended'
                              ? Colors.green.shade100
                              : const Color(0xFFFFF9C4),
                          label: Text(
                            _status.toUpperCase(),
                            style: TextStyle(
                              color: _status == 'attended' ? Colors.green.shade800 : const Color(0xFFE65100),
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Campus Sound Clash',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    const Text('📍 Student Amphitheater'),
                    const Text('📅 Nov 12, 2026'),
                    const Divider(height: 28),
                    if (_status == 'attended')
                      const Center(
                        child: Text(
                          '★ REFLECTION STAMP: ATTENDED ★',
                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      )
                    else
                      Center(
                        child: Text(
                          _status == 'planned' ? 'Planned — ready to attend!' : 'Not planned yet',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            if (_status != 'attended')
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFF8A50),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _isProcessing ? null : _progressStatus,
                  child: Text(_status == 'none' ? 'Start Plan' : 'Mark Attended'),
                ),
              ),
            const SizedBox(height: 10),
            if (_status != 'none')
              TextButton(
                onPressed: () => setState(() => _status = 'cancelled'),
                child: const Text('Cancel Attendance', style: TextStyle(color: Color(0xFFFF1744))),
              ),
          ],
        ),
      ),
    );
  }
}