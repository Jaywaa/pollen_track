import 'package:pollen_track/types/City.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<CityId>> fetchSavedCityIds() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  
  final cityIds = prefs.getStringList('user_cities') ?? [];

  print('Cities in storage $cityIds');
  
  return cityIds
    .map((id) => CityId.values.firstWhere((e) => e.toString() == id))
    .toList();
}

Future<void> addSavedCity(CityId cityId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final savedCities = prefs.getStringList('user_cities') ?? [];
  
  if (!savedCities.contains(cityId.toString())) {
    print('saving city $cityId');
    prefs.setStringList('user_cities', [ ...savedCities, cityId.toString() ]);
  }
}