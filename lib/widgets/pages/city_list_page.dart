import 'package:flutter/material.dart';
import 'package:pollen_track/providers/selected_cities_provider.dart';
import 'package:pollen_track/providers/user_settings_provider.dart';
import 'package:pollen_track/types/city.dart';
import 'package:pollen_track/widgets/components/city_card.dart';
import 'package:pollen_track/widgets/nav_drawer.dart';
import 'package:pollen_track/widgets/pages/city_select_page.dart';
import 'package:provider/provider.dart';

class CityListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final selectedCityIds = Provider.of<SelectedCitiesProvider>(context, listen: true).getSelectedCityIds();
    final isDarkMode = Provider.of<UserSettingsProvider>(context, listen: true).isDarkMode();

    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('Pollen Track'),
      ),

      body: selectedCityIds.isNotEmpty 
          ? CityListWidget(selectedCityIds) 
          : TextButton(
              style: ButtonStyle(foregroundColor: isDarkMode ? MaterialStateProperty.all(Colors.white) : MaterialStateProperty.all(Colors.black)),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CitySelectPage()),
              ),
            child: Center(
              child: Text('Tap anywhere to add a city'),
            ),
          ),

      floatingActionButton: selectedCityIds.isNotEmpty ? Padding(
        child: FloatingActionButton(
          child: Icon(Icons.edit), 
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CitySelectPage()),
          )
        ), 
        padding: EdgeInsets.all(20.0)
      ) : null,
    );
  }
}

class CityListWidget extends StatelessWidget {
  CityListWidget(this.selectedCityIds);

  final List<CityId> selectedCityIds;

  @override
  Widget build(BuildContext context) {
    
    print('Building cities $selectedCityIds');
    
    return ReorderableListView(
        children: selectedCityIds.map((id) => CityCard(key: Key(id.toString()), cityId: id)).toList(),
        onReorder: (oldIndex, newIndex) {
          print('old: $oldIndex, new: $newIndex');
        });
        
  }
}
