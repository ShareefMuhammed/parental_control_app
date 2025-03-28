import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'settings_screen.dart'; // Import SettingsScreen
import 'home_screen.dart'; // Import HomeScreen (ensure this file exists)

class ParentalControlsScreen extends StatefulWidget {
  final Map<String, String> selectedApps; // Store both name and packageName

  const ParentalControlsScreen({super.key, required this.selectedApps});

  @override
  _ParentalControlsScreenState createState() => _ParentalControlsScreenState();
}

class _ParentalControlsScreenState extends State<ParentalControlsScreen> {
  late Map<String, bool> blockedApps;

  @override
  void initState() {
    super.initState();
    blockedApps = {for (var app in widget.selectedApps.keys) app: false};
  }

  void _openApp(String packageName) {
    DeviceApps.openApp(packageName);
  }

  void _showAuthenticationDialog({required VoidCallback onSuccess}) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Parent Sign-In"),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Enter email" : null,
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: "Password"),
                  obscureText: true,
                  validator: (value) =>
                      value == null || value.isEmpty ? "Enter password" : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  if (emailController.text == "test@example.com" &&
                      passwordController.text == "123456") {
                    Navigator.pop(context); // Close dialog
                    onSuccess();
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.red,
                        content: Row(
                          children: const [
                            Icon(Icons.error, color: Colors.white),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "Incorrect email or password, please try again.",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                }
              },
              child: const Text("Login"),
            ),
          ],
        );
      },
    );
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false, // Clears all previous routes
    );
  }

  void _handleBackButton() {
    _showAuthenticationDialog(onSuccess: () {
      Navigator.pop(context); // Navigate back if authentication is successful
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _handleBackButton(); // Trigger authentication on back press
        return false; // Prevent immediate navigation
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Child Interface'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _handleBackButton,
          ),
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'settings') {
                  _showAuthenticationDialog(onSuccess: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsScreen()),
                    );
                  });
                } else if (value == 'exit') {
                  _logout();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'settings',
                  child: Text('Parental controls'),
                ),
                const PopupMenuItem(
                  value: 'exit',
                  child: Text('Exit'),
                ),
              ],
            ),
          ],
        ),
        body: Container(
          color: Colors.lightBlue[50], // Light blue background
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Apps',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: widget.selectedApps.keys.map((appName) {
                    return _buildAppBlockToggle(
                      appName: appName,
                      packageName: widget.selectedApps[appName]!,
                      isBlocked: blockedApps[appName] ?? false,
                      onChanged: (value) {
                        setState(() {
                          blockedApps[appName] = value;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBlockToggle({
    required String appName,
    required String packageName,
    required bool isBlocked,
    required Function(bool) onChanged,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          if (!isBlocked) {
            _openApp(packageName); // Open the app when tapped
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                Icons.apps,
                size: 40,
                color: isBlocked ? Colors.red : Colors.green,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appName,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isBlocked ? 'Blocked' : 'Allowed',
                      style: TextStyle(
                          fontSize: 14,
                          color: isBlocked ? Colors.red : Colors.green),
                    ),
                  ],
                ),
              ),
              Switch(
                value: isBlocked,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}