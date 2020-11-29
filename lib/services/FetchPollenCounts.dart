import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pollen_track/types/CityPollenCount.dart';
import 'package:pollen_track/types/PollenLevel.dart';
import 'package:pollen_track/types/PollenReading.dart';
import 'http/PollenCountHttpService.dart';
import 'parsers/PollenCountParser.dart';

Future<List<CityPollenCount>> fetchPollenCounts() async {
  print('Fetching pollen HTML.');
  var html = await PollenCountHttpService.getPollenCountHtml();

  print('Parsing pollen HTML.');
  return (await PollenCountHTMLParser.parseCityPollenCounts(html)).toList();
}

Future<List<CityPollenCount>> fetchRecentPollenCountsForAllCities() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final citySnapshots = await firestore.collection('cities').get();

  List<CityPollenCount> cityPollenCounts = [];
  for (var citySnapshot in citySnapshots.docs) {
    final cityId = citySnapshot.id;
    final reportDate = citySnapshot.get('latestReportDate');
    print('getting report for city $cityId and reportdate $reportDate');
    cityPollenCounts.add(await getReportForCity(cityId, reportDate));
  }

  return cityPollenCounts;
}

Future<CityPollenCount> getReportForCity(
    String cityId, Timestamp reportDate) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final report = await firestore
      .collection('reports')
      .where('reportDate', isEqualTo: reportDate.toDate())
      .where('cityId', isEqualTo: cityId)
      .limit(1)
      .get();

  if (report.docs.isEmpty) {
    print('No report found for $cityId - ${reportDate.toDate()}');
  } else if (report.docs.length > 1) {
    print('Multiple reports found for $cityId - ${reportDate.toDate()}');
  }

  return mapToDomain(report.docs.first.data());
}

CityPollenCount mapToDomain(Map<String, dynamic> report) {
  final overallReading = new PollenReading(
      'Overall', PollenLevel.fromString(report['overallRisk']));

  final pollenReadings = [
    new PollenReading('Grass', PollenLevel.fromString(report['grassPollen'])),
    new PollenReading('Tree', PollenLevel.fromString(report['treePollen'])),
    new PollenReading('Weed', PollenLevel.fromString(report['weedPollen'])),
    new PollenReading('Mould', PollenLevel.fromString(report['mouldSpores']))
  ];

  return new CityPollenCount(
      report['cityName'], overallReading, pollenReadings);
}
