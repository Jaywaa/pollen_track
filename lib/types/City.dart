import 'package:pollen_track/types/pollen_level.dart';

enum CityId { 
  capetown,
  bloemfontein,
  durban,
  portelizabeth,
  pretoria,
  johannesburg,
  kimberley
}

extension Strings on CityId {
  /// Excludes the enum type name and period from the final string.
  String toSimpleString() {
    return this.toString().split('.').last;
  }
}

extension Enums on String {
  /// Can convert either format: 'MyEnum.myvalue' or 'myvalue'
  T convertToEnum<T>(Iterable<T> values) {
    return values.firstWhere((type) => type.toString().split(".").last == this || type.toString() == this,
      orElse: () => null);
  }
}

class City {
  final CityId id;
  final String name;

  City(this.id, this.name);
}

Map<CityId, String> cityNameByIdMap = {
  CityId.capetown: 'Cape Town',
  CityId.durban: 'Durban',
  CityId.bloemfontein: 'Bloemfontein',
  CityId.pretoria: 'Pretoria',
  CityId.portelizabeth: 'Gqeberha',
  CityId.kimberley: 'Kimberley',
  CityId.johannesburg: 'Johannesburg',
};