import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';

class ScanService {
  Future<Map<String, dynamic>> analyzeScan(File imageFile) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    final url = Uri.parse('${ApiConstants.baseUrl}/scans/analyze');

    // Multipart request because we are sending an image file, not plain JSON
    final request = http.MultipartRequest('POST', url);

    // Attach the auth token
    request.headers['Authorization'] = 'Bearer $token';

    // Attach the image file
    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Scan analysis failed.');
    }
  }
    Future<List<dynamic>> getScanHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    final url = Uri.parse('${ApiConstants.baseUrl}/scans');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Failed to fetch history.');
    }
  }

}
