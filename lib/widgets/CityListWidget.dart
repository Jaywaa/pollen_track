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
        future: fetchRecentPollenCountsForAllCities(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
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
    return Card(
      key: Key(city.cityName),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Title(
            color: Colors.black,
            child: Text(
              city.cityName,
              textScaleFactor: 2,
            ),
            title: city.cityName,
          ),
        ),
        ...city.pollenReadings
            .map((reading) => ListTile(
                  title: Text(reading.type),
                  leading: Icon(Icons.circle, color: reading.pollenLevel.color),
                  trailing: Text(reading.pollenLevel.name),
                ))
            .toList()
      ]),
    );
    // trailing: (Icon(Icons.circle, color: city.overallRisk.pollenLevel.color)),
  }

  @override
  Widget build(BuildContext context) {
    print('Building cities.');
    return _buildCities();
  }
}
