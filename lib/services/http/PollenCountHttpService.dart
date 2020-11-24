import 'package:http/http.dart' as http;

class PollenCountHttpService {
  static final String pollenCountUrl = "https://pollencount.co.za/";

  static Future<String> getPollenCountHtml() async {
      return await http.read(pollenCountUrl);
  }
}
