import 'pollen_level.dart';

class PollenReading {
  String type;
  PollenLevel pollenLevel;

  PollenReading(String type, PollenLevel level) {
    this.type = type;
    this.pollenLevel = level;
  }
}
