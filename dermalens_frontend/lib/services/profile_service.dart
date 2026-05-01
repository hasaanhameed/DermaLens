import 'api_base.dart';

class ProfileService extends ApiBase {
  // Fetch the user data from /profile route
  Future<Map<String, dynamic>> getUserProfile() async {
    final response = await get('/profile');
    return handleResponse(response);
  }

  // Update name/email using PUT /profile route
  Future<void> updateProfile(String name, String email) async {
    final response = await put('/profile', {'name': name, 'email': email});
    handleResponse(response);
  }

  // Update password using /profile/password route
  Future<void> updatePassword(String password) async {
    final response = await put('/profile/password', {'password': password});
    handleResponse(response);
  }

  // Delete account using DELETE /profile route
  Future<void> deleteAccount() async {
    final response = await delete('/profile');
    if (response.statusCode != 204) {
      handleResponse(response);
    }
  }
}
