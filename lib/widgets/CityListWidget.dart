import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pollen_track/providers/SelectedCitiesProvider.dart';
import 'package:pollen_track/services/firebase/FetchPollenCounts.dart';
import 'package:pollen_track/types/City.dart';
import 'package:pollen_track/types/CityPollenCount.dart';
import 'package:provider/provider.dart';

class CityListWidget extends StatelessWidget {  
  Widget _buildCities(List<CityId> cityIds) {
    return FutureBuilder<List<CityPollenCount>>(
        future: getReportsForCities(cityIds),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          print('Data loaded');
          final cities = snapshot.data;

          if (cities.length == 0) {
            return Center(child: Text('Tap anywhere to add a city'));
          }
          
          return ReorderableListView(
              children: snapshot.data.map(_buildCard).toList(),
              onReorder: (oldIndex, newIndex) {
                print('old: $oldIndex, new: $newIndex');
              });
        });
  }

  Widget _buildCard(CityPollenCount city) {
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
  }

  @override
  Widget build(BuildContext context) {
    
    final cityIds = Provider.of<SelectedCitiesProvider>(context, listen: true).getSelectedCities();
    print('Building cities $cityIds');

    return _buildCities(cityIds);
  }
}
