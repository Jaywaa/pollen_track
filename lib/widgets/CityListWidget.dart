import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pollen_track/services/FetchPollenCounts.dart';
import 'package:pollen_track/types/CityPollenCount.dart';

class CityListWidget extends StatefulWidget {
  @override
  _CityListWidgetState createState() => _CityListWidgetState();
}

class _CityListWidgetState extends State<CityListWidget> {
  Widget _buildCities() {
    return FutureBuilder<List<CityPollenCount>>(
        future: fetchPollenCounts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            print('Loading...');
            return Center(child: CircularProgressIndicator());
          }

          print('Data loaded');
          snapshot.data.map((e) => print(e.cityName));
          return ReorderableListView(
              children: snapshot.data.map(_buildRow).toList(),
              onReorder: (oldIndex, newIndex) {
                print('old: $oldIndex, new: $newIndex');
              });
        });
  }

  Widget _buildRow(CityPollenCount city) {
    return ExpansionTile(
        key: Key(city.cityName),
        initiallyExpanded: false,
        title: Text(city.cityName),
        trailing: Icon(Icons.circle, color: city.overallRisk.pollenLevel.color),
        children: city.pollenReadings
            .map((reading) => ListTile(
                  title: Text(reading.type),
                  leading: Icon(Icons.circle, color: reading.pollenLevel.color),
                  trailing: Text(reading.pollenLevel.name),
                ))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    print('Building cities.');
    return _buildCities();
  }
}
