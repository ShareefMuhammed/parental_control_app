import 'package:flutter/material.dart';
import 'added_apps_screen.dart'; // Import AddedAppsScreen
import 'eyesight_protection_screen.dart'; // Import EyesightProtectionScreen
import 'time_limit_screen.dart'; // Import TimeLimitScreen

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Track Wi-Fi and Mobile Network states
  bool _isWiFiEnabled = false;
  bool _isMobileNetworkEnabled = false;

  // Track Home Screen Shortcut state
  bool _isHomeScreenShortcutEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildNetworkOption(
              icon: Icons.wifi,
              title: 'Wi-Fi',
              isEnabled: _isWiFiEnabled,
              onChanged: (value) {
                setState(() {
                  _isWiFiEnabled = value;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildNetworkOption(
              icon: Icons.network_cell,
              title: 'Mobile Network',
              isEnabled: _isMobileNetworkEnabled,
              onChanged: (value) {
                setState(() {
                  _isMobileNetworkEnabled = value;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildSettingsOption(
              icon: Icons.apps,
              title: 'Added Apps',
              onTap: () {
                // Navigate to AddedAppsScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddedAppsScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildSettingsOption(
              icon: Icons.remove_red_eye,
              title: 'Eyesight Protection Statistics and Management',
              onTap: () {
                // Navigate to EyesightProtectionScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EyesightProtectionScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildSettingsOption(
              icon: Icons.timer,
              title: 'Time Limit',
              onTap: () {
                // Navigate to TimeLimitScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TimeLimitScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildSettingsOptionWithSwitch(
              icon: Icons.home,
              title: 'Create Home Screen Shortcut',
              isEnabled: _isHomeScreenShortcutEnabled,
              onChanged: (value) {
                setState(() {
                  _isHomeScreenShortcutEnabled = value;
                });
                // Add logic to create/remove home screen shortcut
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      value
                          ? 'Home screen shortcut created!'
                          : 'Home screen shortcut removed!',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Reusable widget for network options (Wi-Fi and Mobile Network)
  Widget _buildNetworkOption({
    required IconData icon,
    required String title,
    required bool isEnabled,
    required Function(bool) onChanged,
  }) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: isEnabled ? Colors.blue : Colors.grey),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Switch(
              value: isEnabled,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }

  // Reusable widget for settings options with a switch
  Widget _buildSettingsOptionWithSwitch({
    required IconData icon,
    required String title,
    required bool isEnabled,
    required Function(bool) onChanged,
  }) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.blue), // Icon for the option
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Switch(
              value: isEnabled,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }

  // Reusable widget for settings options without a switch
  Widget _buildSettingsOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.blue), // Icon for the option
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios), // Forward arrow icon
            ],
          ),
        ),
      ),
    );
  }
}