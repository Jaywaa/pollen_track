import 'package:flutter/material.dart';
import 'package:pollen_track/providers/cities_provider.dart';
import 'package:pollen_track/providers/selected_cities_provider.dart';
import 'package:pollen_track/types/city.dart';
import 'package:provider/provider.dart';

class CitySelectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final fetchAllCitiesFuture = Provider.of<PollenReportProvider>(context, listen: false).fetchAllCities();

    return Scaffold(
      body: FutureBuilder<List<City>>(
        future: fetchAllCitiesFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final cities = snapshot.data;

          return ListView(children: cities.map((id) => _cityListItem(context, id)).toList());
        },
      ),
      appBar: AppBar(
        title: Text('Select Cities'),
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context))
      )
    )
    ;
  }

  Widget _cityListItem(BuildContext context, City city) {
    final selectedCitiesProvider = Provider.of<SelectedCitiesProvider>(context, listen: true);

    return ListTile(
      title: Text(city.name),
      trailing: Checkbox(
        value: selectedCitiesProvider.getSelectedCityIds().contains(city.id), 
        onChanged: (selected) => 
          selected 
            ? selectedCitiesProvider.addSelectedCity(city.id) 
            : selectedCitiesProvider.removeSelectedCity(city.id)
      )
    );
  }
}