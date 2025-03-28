import 'dart:async';
import 'package:flutter/material.dart';
import 'home_screen.dart'; // Ensure this file exists

class TimeLimitScreen extends StatefulWidget {
  const TimeLimitScreen({super.key});

  @override
  _TimeLimitScreenState createState() => _TimeLimitScreenState();
}

class _TimeLimitScreenState extends State<TimeLimitScreen> {
  bool _isTimeLimitEnabled = false;
  int? _selectedTimeLimit;
  Timer? _logoutTimer;

  void _startLogoutTimer() {
    if (_logoutTimer != null) {
      _logoutTimer!.cancel();
    }
    if (_selectedTimeLimit != null) {
      _logoutTimer = Timer(Duration(minutes: _selectedTimeLimit!), _logout);
    }
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _logoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Time Limit')),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text('Enable Time Limit'),
            value: _isTimeLimitEnabled,
            onChanged: (bool value) {
              setState(() {
                _isTimeLimitEnabled = value;
                if (!value) {
                  _logoutTimer?.cancel();
                }
              });
            },
          ),
          if (_isTimeLimitEnabled) ...[
            _buildTimeLimitOption('15 minutes', 15),
            _buildTimeLimitOption('30 minutes', 30),
            _buildTimeLimitOption('45 minutes', 45),
            _buildTimeLimitOption('1 hour', 60),
            _buildCustomTimeLimitOption(),
          ],
        ],
      ),
    );
  }

  Widget _buildTimeLimitOption(String label, int minutes) {
    return RadioListTile<int>(
      title: Text(label),
      value: minutes,
      groupValue: _selectedTimeLimit,
      onChanged: (int? value) {
        setState(() {
          _selectedTimeLimit = value;
          _startLogoutTimer();
        });
      },
    );
  }

  Widget _buildCustomTimeLimitOption() {
    return ListTile(
      title: const Text('Custom'),
      onTap: () {
        _showCustomTimeLimitDialog();
      },
    );
  }

  void _showCustomTimeLimitDialog() {
    TextEditingController customTimeController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Set Custom Time Limit'),
          content: TextField(
            controller: customTimeController,
            decoration: const InputDecoration(hintText: 'Enter time in minutes'),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                int? customTime = int.tryParse(customTimeController.text);
                if (customTime != null && customTime > 0) {
                  setState(() {
                    _selectedTimeLimit = customTime;
                    _startLogoutTimer();
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Set'),
            ),
          ],
        );
      },
    );
  }
}

class ParentalControlsScreen extends StatefulWidget {
  const ParentalControlsScreen({super.key});

  @override
  _ParentalControlsScreenState createState() => _ParentalControlsScreenState();
}

class _ParentalControlsScreenState extends State<ParentalControlsScreen> {
  Timer? _logoutTimer;

  @override
  void initState() {
    super.initState();
    _startLogoutTimer();
  }

  void _startLogoutTimer() {
    _logoutTimer?.cancel();
    _logoutTimer = Timer(const Duration(minutes: 15), _logout);
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _logoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parental Controls'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _logout,
          ),
        ],
      ),
      body: Center(
        child: const Text('Parental Controls Screen - Time Restricted'),
      ),
    );
  }
}