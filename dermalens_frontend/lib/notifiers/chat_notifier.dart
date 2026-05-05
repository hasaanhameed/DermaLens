import 'package:flutter/material.dart';
import '../services/chat_service.dart';

class ChatNotifier extends ChangeNotifier {
  final ChatService _chatService = ChatService();
  final ScrollController scrollController = ScrollController();
  final TextEditingController messageController = TextEditingController();

  final List<Map<String, String>> messages = [];
  bool isLoading = false;

  void initChat(String condition) {
    messages.clear();
    messages.add({
      'role': 'assistant',
      'content': 'Hello! I am your DermaLens assistant. I can help you understand more about $condition. What would you like to know?'
    });
    notifyListeners();
  }

  Future<void> sendMessage(BuildContext context, String condition) async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    messages.add({'role': 'user', 'content': text});
    messageController.clear();
    isLoading = true;
    notifyListeners();
    _scrollToBottom();

    try {
      final history = messages.sublist(0, messages.length - 1);
      final response = await _chatService.sendChatMessage(
        message: text,
        condition: condition,
        history: history,
      );

      messages.add({'role': 'assistant', 'content': response});
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      isLoading = false;
      notifyListeners();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    messageController.dispose();
    super.dispose();
  }
}
