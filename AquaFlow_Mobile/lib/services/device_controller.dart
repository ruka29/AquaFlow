import 'dart:convert';
import 'package:http/http.dart' as http;

class DeviceController {
  static Future<http.Response> controlValve(String macAddress, bool valveState) async {
    final url = Uri.parse('https://5fjm2w12-5000.asse.devtunnels.ms/api/device/control-valve');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'macAddress': macAddress,
        'valveState': valveState,
        'source': 'mobile',
      }),
    );

    if (response.statusCode == 200) {
      print('Valve control successful: ${response.body}');
    } else {
      print('Failed to control valve: ${response.body}');
    }

    return response;
  }
}