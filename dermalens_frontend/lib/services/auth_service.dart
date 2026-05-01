import 'api_base.dart';

class AuthService extends ApiBase {
  Future<void> registerUser(String name, String email, String password) async {
    final response = await post('/users/signup', {
      'name': name.trim(),
      'email': email.trim(),
      'password': password,
    });
    handleResponse(response);
  }

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final response = await post('/users/login', {
      'email': email.trim(),
      'password': password,
    });
    return handleResponse(response);
  }
}
