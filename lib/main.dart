import 'package:flutter/material.dart';

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
  final _cities = ["Cape Town", "Johannesburg", "Bloemfontein", "Durban", "Pretoria", "Port Elizabeth", "Kimberly"];
  final _pollenTypes = ["Tree", "Grass", "Weed", "Mould"];
  final _pollenAmounts = [
    new PollenReading("Very Low", "No action required. Pollen levels pose no risk to allergy sufferers.", Colors.green),
    new PollenReading("Low", "< 20% of pollen allergy sufferers will experience symptoms. Known seasonal allergy sufferers should commence preventative therapies e.g. nasal steroid sprays.", Colors.yellow),
    new PollenReading("Moderate", "> 50% of pollen allergy sufferers will experience symptoms. Need for increased use of acute treatments e.g. non-sedating antihistamines.", Colors.orange),
    new PollenReading("High", "> 90% of pollen allergy sufferers will experience symptoms. Very allergic patients and asthmatics should limit outdoor activities and keep indoor areas free from wind exposure. Check section on pollen and day-to-day weather changes for planning activities.", Colors.deepOrange),
    new PollenReading("Very High", "These levels are potentially very dangerous for pollen allergy sufferers, especially asthmatics. Outdoor activities should be avoided.", Colors.red),
    new PollenReading("No data", "There is currently no data available for this period.", Colors.blueGrey)
  ];
  final _biggerFont = TextStyle(fontSize: 18.0);

  Widget _buildCities() {
    return ReorderableListView(children: _cities.map(_buildRow).toList(),
      onReorder: (oldIndex, newIndex) {
        print("$oldIndex, $newIndex");
      }
      // padding: EdgeInsets.all(16.0), 
      // itemBuilder: (context, i) {
      //   print('test $i');

      //   // if (i.isOdd) return Divider();
      //   // final index = i ~/ 2;
      //   return _buildRow(_cities[i]);
      // },
      // itemCount: _cities.length);
    );
  }

  Widget _buildRow(String city) {
    return ExpansionTile(
      key: Key(city),
      initiallyExpanded: false,
      title: Text(city),
      children: _pollenTypes.map((e) => ListTile(title: Text(e), leading: Icon(Icons.circle, color: Colors.grey), trailing: Text("No data"),)).toList()
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildCities();
  }
}