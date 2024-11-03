import 'package:flutter/material.dart';
import 'package:playhub/core/api/chatbot_api.dart';
import 'package:playhub/core/common/widgets/custom_app_bar.dart';
import 'package:playhub/core/theme/app_pallete.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  void _sendMessage() async {
    String message = _controller.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _messages.add({"sender": "user", "text": message});
      _isLoading = true;
    });
    _controller.clear();

    try {
      String response = await ChatBot.sendMessage(message);
      setState(() {
        _messages.add({"sender": "bot", "text": response});
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add({"sender": "bot", "text": "Failed to get a response."});
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(text: "Chatbot"),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  // Show loading indicator at the end of the list if loading
                  if (_isLoading && index == _messages.length) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Center(
                        child: TypingIndicator(),
                      ),
                    );
                  }

                  final message = _messages[index];
                  bool isUser = message["sender"] == "user";

                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    child: Align(
                      alignment:
                          isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                              isUser ? AppPalettes.primary : Colors.grey[300],
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 6,
                              offset: Offset(2, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          message["text"] ?? '',
                          style: TextStyle(
                              color: isUser ? Colors.white : Colors.black87),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        prefixIcon:
                            Icon(Icons.message, color: AppPalettes.accent),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey),
                          onPressed: () => _controller.clear(),
                        ),
                        hintText: "Type a message...",
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        filled: true,
                        fillColor: Colors.grey[850],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppPalettes.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TypingIndicator extends StatefulWidget {
  @override
  _TypingIndicatorState createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDot(),
        const SizedBox(width: 5),
        _buildDot(),
        const SizedBox(width: 5),
        _buildDot(),
      ],
    );
  }

  Widget _buildDot() {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: AppPalettes.primary,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
