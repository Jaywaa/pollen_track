
import 'package:flutter/material.dart';
import 'package:pollen_track/providers/cities_provider.dart';
import 'package:pollen_track/types/city.dart';
import 'package:pollen_track/types/city_pollen_count.dart';
import 'package:provider/provider.dart';

class CityCard extends StatelessWidget {
  const CityCard({
    Key key,
    @required this.cityId,
  }) : super(key: key);

  final CityId cityId;

  @override
  Widget build(BuildContext context) {
    final fetchReportFuture = Provider.of<PollenReportProvider>(context, listen: false).fetchReportForCity(cityId);

    return FutureBuilder<CityPollenCount>(
        key: Key(cityId.toString()),
        future: fetchReportFuture,
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
