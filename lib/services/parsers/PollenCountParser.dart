import 'package:html/parser.dart';
import 'package:pollen_track/types/CityPollenCount.dart';
import 'package:pollen_track/types/PollenLevel.dart';
import 'package:pollen_track/types/PollenReading.dart';

class PollenCountHTMLParser {
  static Future<Iterable<CityPollenCount>> parseCityPollenCounts(
      String html) async {
    var document = parse(html);

    // Extract the city rows from the table. [row, ...]
    var cityRows = document
        .querySelectorAll('#wpv-view-layout-300 > div > div > div')
        .skip(2);

    // Pulls out the city and pollen classnames for each city. [[city, overall, tree, grass, weed, mould], ...]
    var pollenNodes = cityRows.map((cityRow) => cityRow
        .querySelectorAll('.col-xs-2 > *')
        .map((node) => node.outerHtml.contains('h5')
                ? node.text // city column
                : node.className.replaceFirst('pollen-', '') // pollen column
            ));

    return pollenNodes.map(_buildCityPollenCount);
  }

  static CityPollenCount _buildCityPollenCount(Iterable<String> row) {
    var rowList = row.toList();
    var pollenLevel = {
      "green": PollenLevel.VeryLow,
      "yellow": PollenLevel.Low,
      "lightorange": PollenLevel.Moderate,
      "darkorange": PollenLevel.High,
      "red": PollenLevel.VeryHigh
    };

    var readings = [
      new PollenReading('Tree', pollenLevel[rowList[2]]),
      new PollenReading('Grass', pollenLevel[rowList[3]]),
      new PollenReading('Weed', pollenLevel[rowList[4]]),
      new PollenReading('Mould', pollenLevel[rowList[5]])
    ];

    var overallReading = new PollenReading('Overall', pollenLevel[rowList[1]]);

    return new CityPollenCount(rowList[0], overallReading, readings);
  }
}
