import 'package:flutter/material.dart';

class TimeLimitProvider extends ChangeNotifier {
  bool _isTimeLimitEnabled = false;
  int? _selectedTimeLimit;

  bool get isTimeLimitEnabled => _isTimeLimitEnabled;
  int? get selectedTimeLimit => _selectedTimeLimit;

  void setTimeLimit(int? timeLimit, bool isEnabled) {
    _selectedTimeLimit = timeLimit;
    _isTimeLimitEnabled = isEnabled;
    notifyListeners();
  }
}
