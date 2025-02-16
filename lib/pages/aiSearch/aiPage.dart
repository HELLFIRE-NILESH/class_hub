import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:class_hub/theme/themeData.dart';

import 'dart:async';

import '../../api_data/chatBotapi.dart';
import '../../widgets/chat/chat_bouble.dart';
import '../../widgets/chat/typingIndicator.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final List<String> messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _showScrollDownButton = false;
  String chatContext = '';

  final ChatApiService _chatService = ChatApiService();

  @override
  void initState() {
    super.initState();
    _loadChatHistory();

    _scrollController.addListener(() {
      setState(() {
        _showScrollDownButton = _scrollController.offset <
            _scrollController.position.maxScrollExtent - 100;
      });
    });
  }

  void _loadChatHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? storedMessages = prefs.getStringList('chat_messages');
    String? storedContext = prefs.getString('chat_context');

    if (storedMessages != null) {
      setState(() {
        messages.addAll(storedMessages);
        chatContext = storedContext ?? '';
      });
    }
  }

  void _saveChatHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('chat_messages', messages);
    await prefs.setString('chat_context', chatContext);
  }

  void _sendMessage() async {
    String message = _controller.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        messages.add("You: $message");
        chatContext += "You: $message\n";
      });
      _controller.clear();
      _scrollToBottom();
      _saveChatHistory();

      setState(() {
        _isLoading = true;
      });

      final String botResponse = await _chatService.getAIResponse(message);
      _displayBotResponseWordByWord(botResponse);
    }
  }

  void _displayBotResponseWordByWord(String botResponse) {
    List<String> words = botResponse.split(' ');
    String currentResponse = '';
    int index = 0;

    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (index < words.length) {
        setState(() {
          currentResponse += '${words[index]} ';
          if (messages.isNotEmpty && messages.last.startsWith("Bot: ")) {
            messages[messages.length - 1] = "Bot: $currentResponse";
          } else {
            messages.add("Bot: $currentResponse");
          }
          chatContext += "Bot: $currentResponse\n";
        });
        _scrollToBottom();
        index++;
      } else {
        timer.cancel();
        _saveChatHistory();
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 50), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  void _clearChat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('chat_messages');
    await prefs.remove('chat_context');

    setState(() {
      messages.clear();
      chatContext = '';
    });
  }

  Widget _buildMessage(String message, bool isUser) {
    return ChatBubble(message: message, isUser: isUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatBot'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: _clearChat,
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            color: MyTheme.backgroundColor,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: messages.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == messages.length) {
                        return const TypingIndicator();
                      }
                      final isUser = messages[index].startsWith("You:");
                      return _buildMessage(messages[index], isUser);
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
                          minLines: 1,
                          maxLines: 5,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.normal),
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            hintText: "Type a message...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                          ),
                          textInputAction: TextInputAction.newline,
                          onSubmitted: (value) => _sendMessage(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.send, color: MyTheme.accentColor),
                        onPressed: _sendMessage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

            Positioned(
              bottom: 80,
              right: 16,
              child: FloatingActionButton(
                backgroundColor: MyTheme.accentColor,
                onPressed: _scrollToBottom,
                shape: const CircleBorder(),
                child: const Icon(Icons.arrow_downward),
              ),
            ),
        ],
      ),
    );
  }
}
