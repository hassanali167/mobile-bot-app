import 'dart:convert';
import 'package:http/http.dart' as http;
import 'prompt_temp.dart'; // Importing developer details and prompt template

class ChatService {
  // API endpoint and key
  final String apiUrl = 'https://api.groq.com/openai/v1/chat/completions';
  final String apiKey =
      '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'; // Replace with your actual API key

  // Method to send message and receive response from the chatbot API
  Future<String> getBotResponse(String message) async {
    try {
      final prompt = generatePrompt(message);

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'llama3-8b-8192', // Using the Groq model
          'temperature': 0.7,
          'messages': [
            {'role': 'system', 'content': prompt},
            {'role': 'user', 'content': message},
          ],
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final botResponse = responseBody['choices']?[0]?['message']
                ?['content'] ??
            'Sorry, I did not understand that.';
        return botResponse;
      } else {
        return 'Error: Unable to fetch response from the chatbot.';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  String generatePrompt(String userInput) {
    // Generate the complete prompt with developer details and context
    return promptTemplate
        .replaceFirst('{developer_details}', DEVELOPER_DETAILS)
        .replaceFirst('{context}', 'User wants to know something')
        .replaceFirst('{user_input}', userInput);
  }
}
