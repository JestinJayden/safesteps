// ─── screens/chat_screen.dart ─────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../main.dart';
import '../widgets/bottom_nav.dart';

class _Message {
  final String text;
  final bool isMe;
  const _Message(this.text, this.isMe);
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  final List<_Message> _messages = [
    const _Message('Goedemorgen! Hoe gaat het wandelen vandaag?', false),
    const _Message('Goed! Ik ga zo op pad.', true),
    const _Message('Fijn! Zorg dat je de veilige route pakt via het park.', false),
    const _Message('Ja, de app geeft dat ook aan. Groene zone!', true),
    const _Message('Super, ik hou het in de gaten via de app.', false),
  ];

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_Message(text, true));
      _controller.clear();
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
    });
    Future.delayed(const Duration(milliseconds: 900), () {
      setState(() => _messages.add(const _Message('Bericht ontvangen, bedankt!', false)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.navy,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: const Text('Chat'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: CircleAvatar(backgroundColor: AppTheme.green, radius: 16, child: const Text('JD', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF04342C)))),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(14),
              itemCount: _messages.length,
              itemBuilder: (context, i) {
                final msg = _messages[i];
                return Align(
                  alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
                    decoration: BoxDecoration(
                      color: msg.isMe ? AppTheme.navy : Colors.grey.shade100,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(14),
                        topRight: const Radius.circular(14),
                        bottomLeft: Radius.circular(msg.isMe ? 14 : 4),
                        bottomRight: Radius.circular(msg.isMe ? 4 : 14),
                      ),
                    ),
                    child: Text(msg.text, style: TextStyle(fontSize: 13, color: msg.isMe ? Colors.white : Colors.black87, height: 1.4)),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
            decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey.shade200, width: 0.5))),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (_) => _sendMessage(),
                    decoration: InputDecoration(
                      hintText: 'Typ een bericht…',
                      hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(color: AppTheme.navy, shape: BoxShape.circle),
                    child: const Icon(Icons.send, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
    );
  }
}
