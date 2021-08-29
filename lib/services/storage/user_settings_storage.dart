import 'package:pollen_track/extensions/string_extensions.dart';
import 'package:pollen_track/types/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';


void saveUserTheme(UserTheme theme) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  print('[setTheme] Saving theme $theme');
  preferences.setString('user_theme', theme.toString());
}

Future<UserTheme> readSavedUserTheme() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  final userTheme = preferences.getString('user_theme');

  if (userTheme == null || userTheme.isEmpty) {
    print('[getTheme] Failed to find user_theme in storage');
    return null;
  }

  print('[getTheme] Fetched user_theme: $userTheme');
  return userTheme.convertToEnum(UserTheme.values);
}