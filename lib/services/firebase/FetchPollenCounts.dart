import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pollen_track/types/CityPollenCount.dart';
import 'package:pollen_track/types/PollenLevel.dart';
import 'package:pollen_track/types/PollenReading.dart';

Future<List<CityPollenCount>> fetchRecentPollenCountsForAllCities() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final citySnapshots = await firestore.collection('cities').get();

  List<CityPollenCount> cityPollenCounts = [];
  for (var citySnapshot in citySnapshots.docs) {
    final cityId = citySnapshot.id;
    final cityName = citySnapshot['cityName'];
    final reportDateString = citySnapshot.get('latestReportDate');
    print('getting report for city $cityId and reportdate $reportDateString');
    cityPollenCounts.add(await getReportForCity(cityId, cityName, reportDateString));
  }

  return cityPollenCounts;
}

Future<CityPollenCount> getReportForCity(
    String cityId, String cityName, String reportDateString) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final report = await firestore
      .collection('reports')
      .where('reportDate', isEqualTo: reportDateString)
      .where('cityId', isEqualTo: cityId)
      .limit(1)
      .get();

  if (report.docs.isEmpty) {
    print('No report found for $cityId - $reportDateString');
  } else if (report.docs.length > 1) {
    print('Multiple reports found for $cityId - $reportDateString');
  }

  return mapToDomain(cityName, report.docs.first.data());
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
