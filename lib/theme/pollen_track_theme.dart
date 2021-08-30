import 'package:flutter/material.dart';

class PollenTrackTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.green,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      primaryColor: Colors.green,
      toggleableActiveColor: Colors.green,
      floatingActionButtonTheme:
        ThemeData.dark().floatingActionButtonTheme.copyWith(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white
        )

    );
  }

  static ThemeData getTheme(bool isDarkTheme) {
    if (isDarkTheme) {
      return darkTheme;
    }

    return lightTheme;
  }
}
