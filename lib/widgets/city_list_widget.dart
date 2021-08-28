import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pollen_track/providers/selected_cities_provider.dart';
import 'package:pollen_track/services/firebase/pollen_report_repository.dart';
import 'package:pollen_track/types/city.dart';
import 'package:pollen_track/types/city_pollen_count.dart';
import 'package:provider/provider.dart';

class CityListWidget extends StatelessWidget {
    @override
  Widget build(BuildContext context) {
    
    final cityIds = Provider.of<SelectedCitiesProvider>(context, listen: true).getSelectedCities();
    print('Building cities $cityIds');
    
    if (cityIds.length == 0) {
      return Center(child: Text('Tap anywhere to add a city'));
    }
    
    return ReorderableListView(
        children: cityIds.map(_buildCard).toList(),
        onReorder: (oldIndex, newIndex) {
          print('old: $oldIndex, new: $newIndex');
        });
        
  }

  Widget _buildCard(CityId cityId) {
    return FutureBuilder<CityPollenCount>(
        key: Key(cityId.toString()),
        future: getReportForCity(cityId),
        builder: (context, snapshot) {
          
          if (!snapshot.hasData) {
            return Card(child: Center(child: Padding(child: CircularProgressIndicator(), padding: EdgeInsets.all(100.0))), margin: EdgeInsets.all(10));
          }

          final city = snapshot.data;
    
          return Card(
            key: Key(cityId.toString()),
            margin: EdgeInsets.all(10),
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
                        subtitle: Text(reading.pollenLevel.name),
                        trailing: Icon(Icons.circle, color: reading.pollenLevel.color)
                        )

                      )
                  .toList()
            ]),
          );
        });
  }
}
