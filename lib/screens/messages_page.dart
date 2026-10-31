import 'package:flutter/material.dart';
import '../core/facebook_theme.dart';
import '../data/demo_data.dart';
import '../models/social_models.dart';
import '../state/facebook_store.dart';
import '../widgets/shared_widgets.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key, required this.store});
  final FacebookStore store;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Chats')),
        body: AnimatedBuilder(
          animation: store,
          builder: (context, _) => ListView(children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              color: Colors.white,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search conversations',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(26), borderSide: BorderSide.none),
                ),
              ),
            ),
            for (final user in demoUsers.skip(1))
              ListTile(
                tileColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                leading: UserAvatar(user: user, radius: 26, showOnline: true),
                title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                  store.conversations[user.id]?.isNotEmpty == true
                      ? store.conversations[user.id]!.last.message
                      : 'Tap to start a conversation',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(Icons.chevron_right, color: FbPalette.secondary),
                onTap: () => Navigator.push(context, MaterialPageRoute<void>(
                  builder: (_) => ChatPage(store: store, userId: user.id),
                )),
              ),
          ]),
        ),
      );
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.store, required this.userId});
  final FacebookStore store;
  final int userId;
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    widget.store.sendMessage(widget.userId, _controller.text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.store.userById(widget.userId);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(children: [
          UserAvatar(user: user, radius: 18, showOnline: true),
          const SizedBox(width: 9),
          Text(user.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ]),
      ),
      body: Column(children: [
        Expanded(
          child: AnimatedBuilder(
            animation: widget.store,
            builder: (context, _) {
              final items = widget.store.conversations[widget.userId] ?? <ChatMessage>[];
              if (items.isEmpty) {
                return EmptyState(
                  icon: Icons.forum_outlined,
                  title: 'Say hello to ${user.name}',
                  subtitle: 'Your conversation starts here.',
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                reverse: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final message = items[items.length - 1 - index];
                  return Align(
                    alignment: message.fromMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * .75),
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
                      decoration: BoxDecoration(
                        color: message.fromMe ? FbPalette.blue : Colors.white,
                        borderRadius: BorderRadius.circular(19),
                      ),
                      child: Text(message.message,
                          style: TextStyle(color: message.fromMe ? Colors.white : FbPalette.ink)),
                    ),
                  );
                },
              );
            },
          ),
        ),
        Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(
              13, 10, 13, 10 + MediaQuery.paddingOf(context).bottom),
          child: Row(children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(hintText: 'Message...'),
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _send(),
              ),
            ),
            IconButton(
              onPressed: _send,
              tooltip: 'Send message',
              icon: const Icon(Icons.send_rounded, color: FbPalette.blue),
            ),
          ]),
        ),
      ]),
    );
  }
}
