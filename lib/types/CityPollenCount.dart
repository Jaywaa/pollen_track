import 'PollenReading.dart';

class CityPollenCount {
  String cityName;
  String detail;
  String overallRisk;
  List<PollenReading> pollenReadings;

  CityPollenCount(String name, String overall, List<PollenReading> readings) {
    this.cityName = name;
    this.pollenReadings = readings;
    this.overallRisk = overall;
  }

  // addReading()

  // addDetail()
}