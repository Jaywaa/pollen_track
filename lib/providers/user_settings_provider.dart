import 'package:flutter/material.dart';
import 'package:pollen_track/types/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSettingsProvider extends ChangeNotifier {
  bool _darkMode;

  UserSettingsProvider() {
    _init();
  }

  void _init() async {
    final preferences = await SharedPreferences.getInstance();
    _darkMode = preferences.getBool(SettingsKey.DarkMode);

    notifyListeners();
  }

  bool isDarkMode() {
    return _darkMode;
  }

  void setDarkMode(bool isDarkMode) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setBool(SettingsKey.DarkMode, isDarkMode);

    _darkMode = isDarkMode;
    notifyListeners();
  }
}