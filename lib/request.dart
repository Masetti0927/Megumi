import 'package:http/http.dart' as http;

class Request {
  // 常量请求头
  static const Map<String, String> headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Cookie': 'os=pc; appver=3.1.4.203507',
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36',
  };

  static Future<String> sendRequest(String params, {required String url}) async {
    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: {'params': params});

      if (response.statusCode != 200) {
        return "Error: HTTP ${response.statusCode} - ${response.reasonPhrase}";
      }

      return response.bodyBytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join('');

    } catch (e) {
      return "Error: $e";
    }
  }
}

