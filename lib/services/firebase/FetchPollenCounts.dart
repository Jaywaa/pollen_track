import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pollen_track/types/City.dart';
import 'package:pollen_track/types/CityPollenCount.dart';
import 'package:pollen_track/types/PollenLevel.dart';
import 'package:pollen_track/types/PollenReading.dart';


Future<List<CityPollenCount>> getReportsForCities(List<CityId> cityIds) async {
  if (cityIds.length == 0) {
    return [];
  }

  print('fetching reports for $cityIds');

  List<CityPollenCount> cityPollenCounts = [];

  for (final id in cityIds) {
    cityPollenCounts.add(await getReportForCity(id));
  }

  return Future.wait(cityIds.map(getReportForCity));
}

Future<CityPollenCount> getReportForCity(CityId cityId) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Dart stringifies enums as 'City.capetown'
  final cityIdString = cityId.toString().split('.').last;
  
  final citySnapshot = await firestore
    .collection('cities')
    .doc(cityIdString)
    .get();

  final latestReportDate = citySnapshot.get('latestReportDate');

  final reportQuery = await firestore
      .collection('reports')
      .where('reportDate', isEqualTo: latestReportDate)
      .where('cityId', isEqualTo: cityIdString)
      .limit(1)
      .get();

  if (reportQuery.docs.isEmpty) {
    print('No report found for $cityId - $latestReportDate');
  } else if (reportQuery.docs.length > 1) {
    print('Multiple reports found for $cityId - $latestReportDate');
  }

  final report = reportQuery.docs.first.data();
  final cityName = citySnapshot.get('cityName');

  return mapToDomain(cityName, report);
}

CityPollenCount mapToDomain(String cityName, Map<String, dynamic> report) {
  final overallReading = new PollenReading(
      'Overall', PollenLevel.fromString(report['overallRisk']));

  final pollenReadings = [
    new PollenReading('Grass', PollenLevel.fromString(report['grassPollen'])),
    new PollenReading('Tree', PollenLevel.fromString(report['treePollen'])),
    new PollenReading('Weed', PollenLevel.fromString(report['weedPollen'])),
    new PollenReading('Mould', PollenLevel.fromString(report['mouldSpores']))
  ];

  return new CityPollenCount(
      cityName, overallReading, pollenReadings);
}
