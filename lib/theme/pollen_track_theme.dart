import 'package:flutter/material.dart';
import 'package:pollen_track/types/settings.dart';

class PollenTrackTheme {
  static ThemeData get lightTheme {
    return ThemeData(
        primarySwatch: Colors.green, scaffoldBackgroundColor: Colors.white);
  }

  static ThemeData get darkTheme {
    return ThemeData();
  }

  static _getSystemTheme(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;

    switch (brightness) {
      case Brightness.dark:
        return darkTheme;
      case Brightness.light:
        return lightTheme;
    }

    print('[getTheme] Failed to get brightness from platform, defaulting to light.');
    return lightTheme;
  }

  static ThemeData getTheme(BuildContext context, UserTheme userTheme) {
      switch (userTheme) {
        case UserTheme.default_light:
          return lightTheme;
        case UserTheme.default_dark:
          return darkTheme;
        case UserTheme.system:
        default:
          print('[getTheme] Using system theme');
          return _getSystemTheme(context);
      }
  }
}
