import 'package:flutter/material.dart';
import 'package:pollen_track/services/storage/user_settings_storage.dart';
import 'package:pollen_track/types/settings.dart';

class UserSettingsProvider extends ChangeNotifier {
  UserTheme _userTheme;

  UserSettingsProvider() {
    _init();
  }

  void _init() async {
    _userTheme = await readSavedUserTheme();

    notifyListeners();
  }

  UserTheme getUserTheme() {
    return _userTheme;
  }

  void setUserTheme(UserTheme theme) {
    _userTheme = theme;

    saveUserTheme(theme);

    notifyListeners();
  }
}