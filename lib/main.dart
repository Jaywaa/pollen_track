import 'package:flutter/material.dart';
import 'package:pollen_track/services/http/PollenCountHttpService.dart';
import 'package:pollen_track/services/parsers/PollenCountParser.dart';
import 'package:pollen_track/types/CityPollenCount.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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

class CityListWidget extends StatefulWidget {
  @override
  _CityListWidgetState createState() => _CityListWidgetState();
}

class _CityListWidgetState extends State<CityListWidget> {
  Widget _buildCities() {
    return FutureBuilder<List<CityPollenCount>>(
      future: _getPollenCounts(),
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
      }
    );
  }

  Widget _buildRow(CityPollenCount city) {
    return ExpansionTile(
      key: Key(city.cityName),
      initiallyExpanded: false,
      title: Text(city.cityName),
      children: city.pollenReadings.map((reading) => ListTile(title: Text(reading.type), leading: Icon(Icons.circle, color: reading.pollenLevel.color), trailing: Text(reading.pollenLevel.name),)).toList()
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Building cities.');
    _getPollenCounts();

    return _buildCities();
  }

  Future<List<CityPollenCount>> _getPollenCounts() async {
    print('Fetching pollen HTML.');
    var html = await PollenCountHttpService.getPollenCountHtml();
    
    print('Parsing pollen HTML.');
    return (await PollenCountHTMLParser().parseCityPollenCounts(html)).toList();
  }
}