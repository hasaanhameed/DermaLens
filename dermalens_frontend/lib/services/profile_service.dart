import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';

class ProfileService {
  // Fetch the user data from /profile route
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

  // Update name/email using PUT /profile route
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
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['detail'] ?? 'Failed to update profile.');
    }
  }

  // Update password using /profile/password route
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

  // Delete account using DELETE /profile route
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
}
