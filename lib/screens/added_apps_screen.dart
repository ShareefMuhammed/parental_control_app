import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'parental_controls_screen.dart';

class AddedAppsScreen extends StatefulWidget {
  const AddedAppsScreen({super.key});

  @override
  _AddedAppsScreenState createState() => _AddedAppsScreenState();
}

class _AddedAppsScreenState extends State<AddedAppsScreen> {
  List<Application> installedApps = [];
  final Map<String, String> selectedApps = {}; // Store appName -> packageName

  @override
  void initState() {
    super.initState();
    _fetchInstalledApps();
  }

  Future<void> _fetchInstalledApps() async {
    List<Application> apps = await DeviceApps.getInstalledApplications(
      includeSystemApps: false, // Exclude system apps
      onlyAppsWithLaunchIntent: true, // Only apps that can be launched
    );

    setState(() {
      installedApps = apps;
    });
  }

  void _openApp(String packageName) {
    DeviceApps.openApp(packageName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Installed Apps')),
      body: installedApps.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: installedApps.length,
              itemBuilder: (context, index) {
                final app = installedApps[index];

                return ListTile(
                  leading: app is ApplicationWithIcon
                      ? Image.memory(app.icon, width: 40, height: 40) // Show app icon
                      : const Icon(Icons.apps), // Default icon if no icon found
                  title: Text(app.appName),
                  trailing: Switch(
                    value: selectedApps.containsKey(app.appName),
                    onChanged: (value) {
                      setState(() {
                        if (value) {
                          selectedApps[app.appName] = app.packageName; // Store both values
                        } else {
                          selectedApps.remove(app.appName);
                        }
                      });
                    },
                  ),
                  onTap: () {
                    _openApp(app.packageName); // Open the app when clicked
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.arrow_forward),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ParentalControlsScreen(selectedApps: selectedApps),
            ),
          );
        },
      ),
    );
  }
}
