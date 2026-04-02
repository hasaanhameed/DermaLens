import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';




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
    // NEW: Update password using Ali's /profile/password route
  Future<void> updatePassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';
    final url = Uri.parse('${ApiConstants.baseUrl}/profile/password');

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'password': password}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update password.');
    }
  }

    // NEW: Fetch the real user data from Ali's /profile route
  Future<Map<String, dynamic>> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';
    final url = Uri.parse('${ApiConstants.baseUrl}/profile');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch profile.');
    }
  }

  // NEW: Update name/email using Ali's PUT /profile route
  Future<void> updateProfile(String name, String email) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';
    final url = Uri.parse('${ApiConstants.baseUrl}/profile');

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'name': name, 'email': email}),
    );

    if (response.statusCode != 200) {
      // THIS is the important part:
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['detail'] ?? 'Failed to update profile.');
    }
  }


  // NEW: Delete account using Ali's DELETE /profile route
  Future<void> deleteAccount() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';
    final url = Uri.parse('${ApiConstants.baseUrl}/profile');

    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete account.');
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
