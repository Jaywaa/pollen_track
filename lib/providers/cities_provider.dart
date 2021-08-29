import 'package:pollen_track/services/firebase/pollen_report_repository.dart';
import 'package:pollen_track/types/city.dart';
import 'package:pollen_track/types/city_pollen_count.dart';

class PollenReportProvider implements IPollenReportRepository {
  List<City> _cities;
  Map<CityId, CityPollenCount> _pollenReports;
  final PollenReportRepository _pollenReportRepository;

  PollenReportProvider(this._pollenReportRepository) {
    _cities = List.empty();
    _pollenReports = {};
  }

  @override
  Future<CityPollenCount> fetchReportForCity(CityId cityId) async {
    final report = _pollenReports[cityId];

    if (report != null) {
      print('[getReportForCity] cache hit for $cityId');
      return report;
    }

    print('[getReportForCity] cache miss for $cityId');
    final fetchedReport = await _pollenReportRepository.fetchReportForCity(cityId);

    _pollenReports[cityId] = fetchedReport;

    return fetchedReport;
  }

  @override
  Future<List<City>> fetchAllCities() async {
    if (_cities.isNotEmpty) {
      print('[fetchAllCities] cache hit');
      return _cities;
    }

    print('[fetchAllCities] cache miss');
    _cities = await _pollenReportRepository.fetchAllCities();

    return _cities;
  }}