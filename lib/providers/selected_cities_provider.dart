import 'package:flutter/material.dart';
import 'package:pollen_track/services/storage/city_storage.dart';
import 'package:pollen_track/types/city.dart';

class SelectedCitiesProvider extends ChangeNotifier {
  List<CityId> _selectedCityIds;

  SelectedCitiesProvider() {
    _selectedCityIds = List.empty();
    _init();
  }

  _init() async {
    _selectedCityIds = await getSavedCityIds();
    print('set saved cities in provider to: $_selectedCityIds');
  }

  List<CityId> getSelectedCityIds() {
    return _selectedCityIds;
  }

  void addSelectedCity(CityId cityId) {
    if (_selectedCityIds.contains(cityId)) {
      print('Attempted to add $cityId but it was in state: $_selectedCityIds');
      return;
    }

    _selectedCityIds.add(cityId);

    // save to preferences too
    addSavedCity(cityId);

    notifyListeners();
  }

  void removeSelectedCity(CityId cityId) {
    if (!_selectedCityIds.contains(cityId)) {
      print('Attempted to remove $cityId but it was not in state: $_selectedCityIds');
      return;
    }

    _selectedCityIds.remove(cityId);

    // remove from preferences too
    removeSavedCity(cityId);

    notifyListeners();
  }
}