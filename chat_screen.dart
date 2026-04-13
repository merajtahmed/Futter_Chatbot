import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Chat"),
        actions: [
          Tooltip(
            message: "Toggle: OpenAI / Free API",
            child: Row(
              children: [
                const Text("Free", style: TextStyle(fontSize: 12)),
                Switch(
                  value: context.watch<ChatProvider>().useOpenAI,
                  onChanged: (val) =>
                      context.read<ChatProvider>().toggleApi(val),
                ),
                const Text("GPT", style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => context.read<ChatProvider>().clearMessages(),
          ),
          IconButton(
            icon: const Icon(Icons.dark_mode),
            onPressed: () => context.read<ThemeProvider>().toggleTheme(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthProvider>().logout(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (_, provider, __) {
                if (provider.messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Lottie.network(AppConstants.lottieUrl, width: 200),
                        const Text("Send a message to start chatting!"),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: provider.messages.length,
                  itemBuilder: (_, i) =>
                      MessageBubble(message: provider.messages[i]),
                );
              },
            ),
          ),
          Consumer<ChatProvider>(
            builder: (_, provider, __) => provider.isTyping
                ? const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(children: [
                SizedBox(
                  width: 16, height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 8),
                Text("AI is typing..."),
              ]),
            )
                : const SizedBox(),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (val) {
                      if (val.isNotEmpty) {
                        context.read<ChatProvider>().sendMessage(val);
                        controller.clear();
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: "Type a message...",
                      contentPadding: EdgeInsets.all(12),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      context
                          .read<ChatProvider>()
                          .sendMessage(controller.text);
                      controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}