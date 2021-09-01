import 'package:flutter/material.dart';
import 'package:pollen_track/types/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSettingsProvider extends ChangeNotifier {
  bool _darkMode;
  bool _notificationsEnabled;

  UserSettingsProvider() {
    _init();
  }

  void _init() async {
    final preferences = await SharedPreferences.getInstance();
    
    _darkMode = preferences.getBool(SettingsKey.DarkMode) ?? false;
    _notificationsEnabled = preferences.getBool(SettingsKey.NotificationsEnabled) ?? true;

    notifyListeners();
  }

  bool isDarkMode() {
    return _darkMode;
  }

  bool notificationsEnabled() {
    return _notificationsEnabled;
  }

  void setDarkMode(bool isDarkMode) async {
    _darkMode = isDarkMode;
    notifyListeners();

    final preferences = await SharedPreferences.getInstance();
    preferences.setBool(SettingsKey.DarkMode, isDarkMode);
  }

  void setNotificationsEnabled(bool notificationsEnabled) async {
    _notificationsEnabled = notificationsEnabled;
    notifyListeners();

    final preferences = await SharedPreferences.getInstance();
    preferences.setBool(SettingsKey.NotificationsEnabled, notificationsEnabled);
  }
}