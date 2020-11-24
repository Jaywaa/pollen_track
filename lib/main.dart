import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pollen_track/services/FetchPollenCounts.dart';
import 'widgets/CityListWidget.dart';

void main() => runApp(PollenTrack());

class PollenTrack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Create the initialization Future outside of `build`:
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();

    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text("Failed to initialize. ${snapshot.error}");
          }
          print('Initialized.');
          fetchMostRecentPollenCounts();

          return MaterialApp(
            theme: ThemeData(primarySwatch: Colors.deepOrange),
            title: 'Pollen Track',
            home: Scaffold(
              appBar: AppBar(
                title: Text('Pollen Track'),
              ),
              body: Center(
                child: CityListWidget(),
              ),
            ),
          );
        });
  }
}
