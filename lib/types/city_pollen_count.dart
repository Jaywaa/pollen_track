import 'city.dart';
import 'pollen_reading.dart';

class CityPollenCount {
  final CityId cityId;
  final String cityName;
  final String description;
  final PollenReading overallRisk;
  final List<PollenReading> pollenReadings;

  CityPollenCount(this.cityId, this.cityName, this.overallRisk, this.pollenReadings, this.description);
}
