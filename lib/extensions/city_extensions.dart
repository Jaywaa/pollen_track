import 'package:pollen_track/types/city.dart';

extension Strings on CityId {
  /// Excludes the enum type name and period from the final string.
  String toSimpleString() {
    return this.toString().split('.').last;
  }
}