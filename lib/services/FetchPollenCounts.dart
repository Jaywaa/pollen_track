import 'package:pollen_track/types/CityPollenCount.dart';
import 'http/PollenCountHttpService.dart';
import 'parsers/PollenCountParser.dart';

Future<List<CityPollenCount>> fetchPollenCounts() async {
  print('Fetching pollen HTML.');
  var html = await PollenCountHttpService.getPollenCountHtml();

  print('Parsing pollen HTML.');
  return (await PollenCountHTMLParser().parseCityPollenCounts(html)).toList();
}
