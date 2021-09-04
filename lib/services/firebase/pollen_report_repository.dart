import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pollen_track/types/city.dart';
import 'package:pollen_track/types/city_pollen_count.dart';
import 'package:pollen_track/types/pollen_level.dart';
import 'package:pollen_track/types/pollen_reading.dart';
import 'package:pollen_track/extensions/city_extensions.dart';
import 'package:pollen_track/extensions/string_extensions.dart';

abstract class IPollenReportRepository {
  Future<CityPollenCount> fetchReportForCity(CityId cityId);
  Future<List<City>> fetchAllCities();
}

class PollenReportRepository implements IPollenReportRepository {

  Future<CityPollenCount> fetchReportForCity(CityId cityId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Dart stringifies enums as 'City.capetown'
    final cityIdString = cityId.toSimpleString();

    final citySnapshot =
        await firestore.collection('cities').doc(cityIdString).get();

    final DocumentReference latestReport = citySnapshot.get('latestReport');

    final report = await latestReport.get();
    
    final cityName = citySnapshot.get('cityName');

    return mapToDomain(cityId, cityName, report);
  }

  Future<List<City>> fetchAllCities() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    final citySnapshot = await firestore.collection('cities').get();

    return citySnapshot.docs
        .map((doc) => City(
              doc.id.convertToEnum(CityId.values),
              doc['cityName'],
              // doc['latestOverallRisk']
            ))
        .toList();
  }

  CityPollenCount mapToDomain(CityId cityId, String cityName, DocumentSnapshot<Map<String, dynamic>> report) {
    final overallReading = new PollenReading(
        'Overall', PollenLevel.fromString(report.get('overallRisk')));

    final pollenReadings = [
      new PollenReading(
          '🌾 Grass', PollenLevel.fromString(report.get('grassPollen'))),
      new PollenReading(
          '🌳 Tree', PollenLevel.fromString(report.get('treePollen'))),
      new PollenReading(
          '🌱 Weed', PollenLevel.fromString(report.get('weedPollen'))),
      new PollenReading(
          '🍄 Mould', PollenLevel.fromString(report.get('mouldSpores')))
    ];

    return new CityPollenCount(cityId, cityName, overallReading, pollenReadings, report['description']);
  }
}
