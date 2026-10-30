import 'package:flutter/material.dart';
import 's3_event_detail.dart';

class S4HistoryInsightsScreen extends StatefulWidget {
  const S4HistoryInsightsScreen({super.key});

  @override
  State<S4HistoryInsightsScreen> createState() => _S4HistoryInsightsScreenState();
}

class _S4HistoryInsightsScreenState extends State<S4HistoryInsightsScreen> {
  bool _dismissedPick = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('History & Insights'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Pocket Picks Card
          if (!_dismissedPick) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9C4), // Light yellow accent background
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.auto_awesome, color: Color(0xFFFF8A50), size: 18),
                      SizedBox(width: 8),
                      Text('Pocket Picks', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Spacer(),
                      Chip(
                        label: Text('+2 PTS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                        backgroundColor: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Rule-based smart helper: local scoring, not a prediction or guarantee.',
                    style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic),
                  ),
                  const Divider(height: 16),
                  const Text('Hackathon & Sound Sprint', style: TextStyle(fontWeight: FontWeight.bold)),
                  const Text('Reason: Matches your preferred Tech tag (+2 pts)'),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => setState(() => _dismissedPick = true),
                        child: const Text('Not now', style: TextStyle(color: Colors.black54)),
                      ),
                      FilledButton(
                        style: FilledButton.styleFrom(backgroundColor: const Color(0xFFFF8A50)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const S3EventDetailScreen()),
                          );
                        },
                        child: const Text('Apply'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          const Text('Past Records', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: const Text('Campus Sound Clash'),
              subtitle: const Text('Attended • Oct 14, 2026'),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: Color(0xFFFF1744)), // Red alert
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
