import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pollen_track/providers/cities_provider.dart';
import 'package:pollen_track/providers/selected_cities_provider.dart';
import 'package:pollen_track/providers/user_settings_provider.dart';
import 'package:pollen_track/services/firebase/pollen_report_repository.dart';
import 'package:pollen_track/theme/pollen_track_theme.dart';
import 'package:pollen_track/widgets/pages/city_list.dart';
import 'package:provider/provider.dart';

void main() => runApp(PollenTrack());

class PollenTrack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // call firebase from outside build, but breaks when you do
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: SelectedCitiesProvider()),
        ChangeNotifierProvider.value(value: UserSettingsProvider()),
        Provider.value(value: PollenReportProvider(new PollenReportRepository()))
      ],
      child: MediaQuery(
      data: MediaQueryData(),
      child: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text("Failed to initialize. ${snapshot.error}");
          }

          print('[Initialized]');

          return PollenTrackMaterialAppWidget();
        })
    )
    );
  }
}

class PollenTrackMaterialAppWidget extends StatelessWidget {
  const PollenTrackMaterialAppWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<UserSettingsProvider>(context, listen: true).getUserTheme();

    return MaterialApp(
        theme: PollenTrackTheme.getTheme(context, theme),
        title: 'Pollen Track',
        home: CityListPage()
      );
  }
}
