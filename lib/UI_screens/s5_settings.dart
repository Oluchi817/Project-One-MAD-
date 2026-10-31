import 'package:flutter/material.dart';

class S5SettingsScreen extends StatefulWidget {
  const S5SettingsScreen({super.key});

  @override
  State<S5SettingsScreen> createState() => _S5SettingsScreenState();
}

class _S5SettingsScreenState extends State<S5SettingsScreen> {
  String _preferredTag = 'Tech';
  double _groupSize = 4;

  void _saveSettings() {
    
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Preferences saved!'),
        backgroundColor: Color(0xFFFF8A50),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Preferred Interest Tag', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Used as your baseline for Pocket Picks (+2 pt bonus).', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    initialValue: _preferredTag,
                    items: ['Music', 'Tech', 'Art', 'Sports', 'Food'].map((t) {
                      return DropdownMenuItem(value: t, child: Text(t));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _preferredTag = val);
                        _saveSettings();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Default Group Size: ${_groupSize.round()} people', style: const TextStyle(fontWeight: FontWeight.bold)),
                  Slider(
                    value: _groupSize,
                    min: 1,
                    max: 20,
                    divisions: 19,
                    activeColor: const Color(0xFFFF8A50),
                    inactiveColor: const Color(0xFFFFF9C4),
                    label: _groupSize.round().toString(),
                    onChanged: (val) => setState(() => _groupSize = val),
                    onChangeEnd: (val) => _saveSettings(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
