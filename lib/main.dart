import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pollen_track/providers/cities_provider.dart';
import 'package:pollen_track/providers/selected_cities_provider.dart';
import 'package:pollen_track/providers/user_settings_provider.dart';
import 'package:pollen_track/services/firebase/pollen_report_repository.dart';
import 'package:pollen_track/theme/pollen_track_theme.dart';
import 'package:pollen_track/widgets/pages/city_list_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(PollenTrack());
}

class PollenTrack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // call firebase from outside build, but breaks when you do. try move it inside main?
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: SelectedCitiesProvider()),
        ChangeNotifierProvider.value(value: UserSettingsProvider()),
        Provider.value(value: PollenReportProvider(new PollenReportRepository()))
      ],
      child: FutureBuilder(
        future: Future.wait([_initialization]),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Failed to initialize. ${snapshot.error}');
          }

          return PollenTrackMaterialAppWidget();
        })
    );
  }
}

class PollenTrackMaterialAppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userSettingsProvider = Provider.of<UserSettingsProvider>(context, listen: true);
    final isDarkMode = userSettingsProvider.isDarkMode();
    final notificationsEnabled = userSettingsProvider.notificationsEnabled();

    if (notificationsEnabled) {
      print('subscribing to notifications');
      FirebaseMessaging.instance.getToken().then((token) => print('token: $token'));
      FirebaseMessaging.instance.subscribeToTopic('reports');
    } else { print('notifications disabled. did not subscribe.'); }

    return MaterialApp(
        theme: PollenTrackTheme.getTheme(isDarkMode),
        title: 'Pollen Track',
        home: SafeArea(child: CityListPage())
      );
  }
}
