import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String getMLIP() {
    final mlIP = dotenv.env['MLIP']?.isEmpty ?? true
        ? dotenv.env['DEFAULT_MLIP']
        : dotenv.env['MLIP'];
    return mlIP ?? 'default_ip';
  }

  static Uri getBaseUrl(String endpoint) {
    final mlIP = getMLIP();
    return Uri.parse('http://$mlIP:8000/$endpoint');
  }

  static Uri getMLUrl(String endpoint) {
    final mlIP = getMLIP();
    return Uri.parse('http://$mlIP:8080/$endpoint');
  }

  static Uri getChatbotUrl(String endpoint) {
    final mlIP = getMLIP();
    return Uri.parse('http://$mlIP:3000/$endpoint');
  }
}
