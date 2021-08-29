import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pollen_track/providers/cities_provider.dart';
import 'package:pollen_track/providers/selected_cities_provider.dart';
import 'package:pollen_track/services/firebase/pollen_report_repository.dart';
import 'package:pollen_track/widgets/pages/city_list.dart';
import 'package:provider/provider.dart';

void main() => runApp(PollenTrack());

class PollenTrack extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: SelectedCitiesProvider()),
        Provider.value(value: PollenReportProvider(new PollenReportRepository()))
      ],
      child: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text("Failed to initialize. ${snapshot.error}");
          }

          print('[Initialized]');

          return MaterialApp(
            theme: ThemeData(primarySwatch: Colors.lightGreen),
            title: 'Pollen Track',
            home: CityListPage(),
          );
        })
    );
  }
}
