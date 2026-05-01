import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../notifiers/chat_notifier.dart';
import '../theme/app_colors.dart';

class ChatPage extends StatelessWidget {
  final String condition;

  const ChatPage({super.key, required this.condition});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = theme.scaffoldBackgroundColor;
    final cardColor = theme.cardColor;
    final textColor = theme.colorScheme.onSurface;
    final accentColor = theme.colorScheme.primary;
    final isLight = theme.brightness == Brightness.light;

    return Consumer<ChatNotifier>(
      builder: (context, notifier, child) {
        // Initialize if empty
        notifier.initChat(condition);

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dive Deep with AI',
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: isLight ? AppColors.deepVoid : textColor,
                  ),
                ),
                Text(
                  condition,
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 12,
                    color: isLight ? AppColors.deepVoid.withOpacity(0.7) : accentColor,
                  ),
                ),
              ],
            ),
            backgroundColor: isLight ? AppColors.sand : bgColor,
            iconTheme: IconThemeData(color: isLight ? AppColors.deepVoid : textColor),
            elevation: 0,
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: notifier.scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: notifier.messages.length + (notifier.isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == notifier.messages.length) {
                      return _buildLoadingBubble(accentColor, cardColor);
                    }
                    final msg = notifier.messages[index];
                    return _buildChatBubble(context, msg, accentColor, cardColor, textColor);
                  },
                ),
              ),
              _buildInputArea(context, notifier, cardColor, accentColor, textColor),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChatBubble(BuildContext context, Map<String, String> msg, Color accentColor, Color cardColor, Color textColor) {
    final isUser = msg['role'] == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isUser ? accentColor : cardColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isUser ? 20 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Text(
          msg['content']!,
          style: TextStyle(
            fontFamily: 'Raleway',
            color: isUser ? Colors.white : textColor,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingBubble(Color accentColor, Color cardColor) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2, color: accentColor),
        ),
      ),
    );
  }

  Widget _buildInputArea(BuildContext context, ChatNotifier notifier, Color cardColor, Color accentColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: notifier.messageController,
                style: TextStyle(fontFamily: 'Raleway', color: textColor),
                decoration: InputDecoration(
                  hintText: 'Ask about your condition...',
                  hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Colors.black.withOpacity(0.05),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onSubmitted: (_) => notifier.sendMessage(context, condition),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.send_rounded, color: accentColor),
              onPressed: () => notifier.sendMessage(context, condition),
            ),
          ],
        ),
      ),
    );
  }
}
