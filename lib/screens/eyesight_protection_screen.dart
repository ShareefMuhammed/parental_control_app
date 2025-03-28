import 'package:flutter/material.dart';

class EyesightProtectionScreen extends StatefulWidget {
  const EyesightProtectionScreen({super.key});

  @override
  _EyesightProtectionScreenState createState() => _EyesightProtectionScreenState();
}

class _EyesightProtectionScreenState extends State<EyesightProtectionScreen> {
  bool _ambientLightReminder = true;
  bool _eyeProtectingDisplay = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eyesight Protection'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Statistics',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Used Kid Space for 0 min',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    const Text('0 reminders', style: TextStyle(fontSize: 14, color: Colors.grey)),
                    const SizedBox(height: 2),
                    const Text('For ambient light', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Features',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Eyesight protection guide',
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
              ],
            ),
            _buildFeatureTile(
              title: 'Ambient light reminder',
              subtitle: 'Remind your child to move to a brighter area when the ambient light is too low.',
              value: _ambientLightReminder,
              onChanged: (bool newValue) {
                setState(() {
                  _ambientLightReminder = newValue;
                });
              },
            ),
            _buildFeatureTile(
              title: 'Eye-protecting display',
              subtitle: "Filter blue light to protect your child's eyesight.",
              value: _eyeProtectingDisplay,
              onChanged: (bool newValue) {
                setState(() {
                  _eyeProtectingDisplay = newValue;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 14)),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
        ),
      ),
    );
  }
}