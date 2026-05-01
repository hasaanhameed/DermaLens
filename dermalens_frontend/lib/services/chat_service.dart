import 'api_base.dart';

class ChatService extends ApiBase {
  Future<String> sendChatMessage({
    required String message,
    required String condition,
    required List<Map<String, String>> history,
  }) async {
    final response = await post('/chat/', {
      'message': message,
      'condition': condition,
      'history': history,
    });
    
    final data = handleResponse(response);
    return data['response'];
  }
}
