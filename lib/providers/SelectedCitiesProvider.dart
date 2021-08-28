import 'package:flutter/material.dart';
import 'package:pollen_track/services/storage/CityStorage.dart';
import 'package:pollen_track/types/City.dart';

class SelectedCitiesProvider extends ChangeNotifier {
  List<CityId> _cities;

  SelectedCitiesProvider() {
    _init();
  }

  _init() async {
    _cities = await fetchSavedCityIds();
    print('set saved cities in provider to: $_cities');
  }

  List<CityId> getSelectedCities() {
    return _cities;
  }

  void addSelectedCity(CityId cityId) {
    if (_cities.contains(cityId)) {
      return;
    }

    _cities.add(cityId);

    // save to preferences too
    addSavedCity(cityId);

    notifyListeners();
  }
}