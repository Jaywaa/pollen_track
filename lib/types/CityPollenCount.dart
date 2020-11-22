import 'PollenReading.dart';

class CityPollenCount {
  String cityName;
  String detail;
  PollenReading overallRisk;
  List<PollenReading> pollenReadings;

  CityPollenCount(
      String name, PollenReading overall, List<PollenReading> readings) {
    this.cityName = name;
    this.pollenReadings = readings;
    this.overallRisk = overall;
  }

  // addReading()

  // addDetail()
}
