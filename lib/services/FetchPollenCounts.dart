import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pollen_track/types/CityPollenCount.dart';
import 'http/PollenCountHttpService.dart';
import 'parsers/PollenCountParser.dart';

Future<List<CityPollenCount>> fetchPollenCounts() async {
  print('Fetching pollen HTML.');
  var html = await PollenCountHttpService.getPollenCountHtml();

  print('Parsing pollen HTML.');
  return (await PollenCountHTMLParser.parseCityPollenCounts(html)).toList();
}

const cityDocuments = ['cape_town'];

Future<Iterable<CityPollenCount>> fetchMostRecentPollenCounts() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final cities = await firestore.collection('cities').get();

  print('CITIES! ${cities.docs.length}');

  cities.docs.forEach((city) async {
    final report = await firestore
        .collection('cities')
        .doc(city.id)
        .collection('reports')
        .doc('latest')
        .get();

    final cityData = city.data();
    final reportData = report.data();
    print('city: $cityData');
    print('report: $reportData');
  });
}

CityPollenCount _mapToCityPollenCount(dynamic cityReport) {}
