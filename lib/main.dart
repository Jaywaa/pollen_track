import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pollen_track/providers/SelectedCitiesProvider.dart';
import 'package:pollen_track/types/City.dart';
import 'package:pollen_track/widgets/NavDrawer.dart';
import 'widgets/CityListWidget.dart';
import 'package:provider/provider.dart';

void main() => runApp(PollenTrack());

class PollenTrack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Create the initialization Future outside of `build`:
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: SelectedCitiesProvider(),
        )
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
            home: Scaffold(
              drawer: NavDrawer(),
              appBar: AppBar(
                title: Text('Pollen Track'),
              ),
              body: Center(
                child: CityListWidget(),
              ),
              floatingActionButton: Padding(
                child: FloatingActionButton(
                  child: Icon(Icons.edit), 
                  onPressed: () => Provider.of<SelectedCitiesProvider>(context, listen: false).addSelectedCity(CityId.capetown)
                ), 
                padding: const EdgeInsets.all(20.0)
              ),
            ),
          );
        })
    );
  }
}
