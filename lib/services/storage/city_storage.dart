import 'package:pollen_track/services/storage/storage_keys.dart';
import 'package:pollen_track/types/city.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pollen_track/extensions/string_extensions.dart';

Future<List<CityId>> readSavedCityIds() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  
  final cityIds = prefs.getStringList(StorageKeys.SelectedCities) ?? [];

  print('Cities in storage $cityIds');
  
  return cityIds
    .map((id) => id.convertToEnum(CityId.values))
    .toList();
}

Future<void> saveSelectedCity(CityId cityId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final selectedCities = prefs.getStringList(StorageKeys.SelectedCities) ?? [];
  
  if (!selectedCities.contains(cityId.toString())) {
    print('saving city $cityId to storage');
    selectedCities.add(cityId.toString());
    prefs.setStringList(StorageKeys.SelectedCities, selectedCities);
  }
}

Future<void> removeSavedCity(CityId cityId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final savedCities = prefs.getStringList(StorageKeys.SelectedCities) ?? [];
  
  if (savedCities.contains(cityId.toString())) {
    print('removing city $cityId from storage');
    savedCities.remove(cityId.toString());
    prefs.setStringList(StorageKeys.SelectedCities, savedCities);
  }
}