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
  final cities2 = await firestore.collectionGroup('cities').get();

  print('CITIES! ${cities.docs.length} ${cities.docs.map((d) => d.reference)}');
  print(
      'CITIES 2! ${cities2.docs.length} ${cities2.docs.map((e) => e.reference)}');

  final reports = await firestore.collection('reports').get();

  print('REPORT ${reports.docs.length} ${reports.docs.map((e) => e.data())}');
}

CityPollenCount _mapToCityPollenCount(dynamic cityReport) {}
