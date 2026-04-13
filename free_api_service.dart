import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';
import 'openai_service.dart';

class FreeApiService {
  // Using the same API key and URL as OpenAIService since it's already working
  static const String _apiKey = OpenAIService.apiKey;

  Future<String> getResponse(String message) async {
    try {
      final res = await http.post(
        Uri.parse(AppConstants.openAiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $_apiKey",
          "HTTP-Referer": "http://localhost",
          "X-Title": "AI Chat App",
        },
        body: jsonEncode({
          "model": AppConstants.freeAiModel, // Using the free Gemma model
          "messages": [
            {"role": "user", "content": message}
          ],
        }),
      ).timeout(const Duration(seconds: 20));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data["choices"][0]["message"]["content"];
      } else {
        throw Exception("Free API error: ${res.statusCode}");
      }
    } on http.ClientException {
      throw Exception("Network error. Check your connection.");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}