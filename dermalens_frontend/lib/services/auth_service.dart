import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';

class AuthService {
  Future<void> registerUser(String name, String email, String password) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/users/signup');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name.trim(),
          'email': email.trim(),
          'password': password,
        }),
      );

      if (response.statusCode != 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        // The FastAPI backend throws HTTPException which returns {"detail": "..."}
        final errorMessage = responseData['detail'] ?? 'Registration failed.';
        throw Exception(errorMessage);
      }
      // If statusCode == 201, registration was successful.
    } catch (e) {
      // Re-throw our custom parsing error if it exists, otherwise a generic one
      if (e.toString().startsWith('Exception:')) {
        rethrow;
      }
      throw Exception('Failed to connect to the server. Is it running?');
    }
  }

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/users/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email.trim(),
          'password': password,
        }),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode != 200) {
        final errorMessage = responseData['detail'] ?? 'Login failed.';
        throw Exception(errorMessage);
      }

      return responseData;
    } catch (e) {
      if (e.toString().startsWith('Exception:')) {
        rethrow;
      }
      throw Exception('Failed to connect to the server. Is it running?');
    }
  }
}
