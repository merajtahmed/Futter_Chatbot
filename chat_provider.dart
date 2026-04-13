import 'package:flutter/material.dart';
import '../models/message_model.dart';
import '../services/openai_service.dart';
import '../services/free_api_service.dart';

class ChatProvider extends ChangeNotifier {
  final OpenAIService _openAI = OpenAIService();
  final FreeApiService _freeApi = FreeApiService();

  bool useOpenAI = true;
  bool isTyping = false;
  List<MessageModel> messages = [];

  Future<void> sendMessage(String msg) async {
    messages.add(MessageModel(
      role: 'user',
      text: msg,
      time: DateTime.now(),
    ));
    isTyping = true;
    notifyListeners();

    try {
      final String reply = useOpenAI
          ? await _openAI.sendMessage(msg)
          : await _freeApi.getResponse(msg);

      messages.add(MessageModel(
        role: 'bot',
        text: reply,
        time: DateTime.now(),
      ));
    } catch (e) {
      messages.add(MessageModel(
        role: 'bot',
        text: '⚠️ ${e.toString().replaceAll("Exception: ", "")}',
        time: DateTime.now(),
      ));
    }

    isTyping = false;
    notifyListeners();
  }

  void toggleApi(bool val) {
    useOpenAI = val;
    notifyListeners();
  }

  void clearMessages() {
    messages.clear();
    notifyListeners();
  }
}