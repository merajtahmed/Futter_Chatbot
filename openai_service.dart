import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';

class OpenAIService {
  static const String apiKey =
      "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";

  Future<String> sendMessage(String message) async {
    try {
      final res = await http.post(
        Uri.parse(AppConstants.openAiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey",
          "HTTP-Referer": "http://localhost",
          "X-Title": "AI Chat App",
        },
        body: jsonEncode({
          "model": AppConstants.openAiModel,
          "messages": [
            {"role": "user", "content": message}
          ],
        }),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data["choices"][0]["message"]["content"];
      } else if (res.statusCode == 401) {
        throw Exception("Invalid API Key.");
      } else if (res.statusCode == 404) {
        throw Exception("Model not found. Check the model name.");
      } else if (res.statusCode == 429) {
        throw Exception("Rate limit exceeded. Try again later.");
      } else {
        throw Exception("OpenRouter error: ${res.statusCode}");
      }
    } on http.ClientException {
      throw Exception("Network error. Check your connection.");
    }
  }
}