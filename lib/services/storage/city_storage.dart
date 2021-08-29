import 'package:pollen_track/types/city.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<CityId>> getSavedCityIds() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  
  final cityIds = prefs.getStringList('user_cities') ?? [];

  print('Cities in storage $cityIds');
  
  return cityIds
    .map((id) => id.convertToEnum(CityId.values))
    .toList();
}

Future<void> addSavedCity(CityId cityId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final savedCities = prefs.getStringList('user_cities') ?? [];
  
  if (!savedCities.contains(cityId.toString())) {
    print('saving city $cityId to storage');
    savedCities.add(cityId.toString());
    prefs.setStringList('user_cities', savedCities);
  }
}

Future<void> removeSavedCity(CityId cityId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final savedCities = prefs.getStringList('user_cities') ?? [];
  
  if (savedCities.contains(cityId.toString())) {
    print('removing city $cityId from storage');
    savedCities.remove(cityId.toString());
    prefs.setStringList('user_cities', savedCities);
  }
}