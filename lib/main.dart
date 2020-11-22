import 'package:flutter/material.dart';
import 'widgets/CityListWidget.dart';

void main() => runApp(PollenTrack());

class PollenTrack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
  }
}
