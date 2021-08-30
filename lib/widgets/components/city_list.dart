import 'package:flutter/material.dart';
import 'package:pollen_track/providers/selected_cities_provider.dart';
import 'package:pollen_track/widgets/pages/city_select_page.dart';
import 'package:provider/provider.dart';

import 'city_card.dart';

class CityListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    final selectedCityIds = Provider.of<SelectedCitiesProvider>(context, listen: true).getSelectedCityIds();
    print('Building cities $selectedCityIds');
    
    if (selectedCityIds.length == 0) {
      return Center(
        child: GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CitySelectPage()),
            ),
          child: Text('Tap anywhere to add a city'),
        ),
      );
    }
    
    return ReorderableListView(
        children: selectedCityIds.map((id) => CityCard(key: Key(id.toString()), cityId: id)).toList(),
        onReorder: (oldIndex, newIndex) {
          print('old: $oldIndex, new: $newIndex');
        });
        
  }
}
