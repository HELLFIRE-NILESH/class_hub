import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatApiService {
  final GenerativeModel _model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: dotenv.env["api_key"] ?? "",
    generationConfig: GenerationConfig(
      temperature: 0.7, // Adjust for more diverse responses
      topP: 0.9, // Improve response probability
      topK: 40, // Control sampling diversity
      maxOutputTokens: 250, // Allow a bit more room for word count range
    ),
  );

  List<Content> chatHistory = []; // Store past messages for context

  Future<String> getAIResponse(String message) async {
    try {
      // Append instruction to enforce word limit
      String userMessage =
          "$message\n(Keep the response between 10 and 150 words max 200 world if asked for long, do not exceed or go below this limit.)";

      chatHistory.add(Content.text(userMessage));

      final response = await _model.generateContent(chatHistory);

      if (response.text != null && response.text!.isNotEmpty) {
        String botResponse = response.text!;

        // Keep only the last 10 messages for context
        if (chatHistory.length > 10) {
          chatHistory.removeRange(0, chatHistory.length - 10);
        }

        chatHistory.add(Content.text(botResponse)); // Store bot response
        return botResponse;
      } else {
        return "I'm not sure how to respond. Could you clarify?";
      }
    } catch (e) {
      return "Something went wrong. Please try again.";
    }
  }
}
