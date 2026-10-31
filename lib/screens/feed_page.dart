import 'package:flutter/material.dart';
import '../core/facebook_theme.dart';
import '../data/demo_data.dart';
import '../state/facebook_store.dart';
import '../widgets/post_card.dart';
import '../widgets/shared_widgets.dart';
import 'profile_page.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key, required this.store});
  final FacebookStore store;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: store,
        builder: (context, _) => ListView(
          key: const PageStorageKey<String>('feed'),
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          children: [
            WhiteSurface(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
              child: Column(children: [
                Row(children: [
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(builder: (_) => ProfilePage(store: store)),
                    ),
                    child: UserAvatar(user: store.currentUser),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(40),
                      onTap: () => _compose(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
                        decoration: BoxDecoration(
                          border: Border.all(color: FbPalette.border),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: const Text("What's on your mind?", style: TextStyle(fontSize: 15)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 7),
                  IconButton(
                    tooltip: 'New photo post',
                    onPressed: () => _compose(context),
                    icon: const Icon(Icons.photo_library_outlined, color: FbPalette.green),
                  ),
                ]),
                const Divider(height: 24),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  _QuickCompose(
                    icon: Icons.videocam_rounded,
                    color: const Color(0xFFE94B65),
                    label: 'Live video',
                    onTap: () => _compose(context),
                  ),
                  _QuickCompose(
                    icon: Icons.photo_library,
                    color: FbPalette.green,
                    label: 'Photo',
                    onTap: () => _compose(context),
                  ),
                  _QuickCompose(
                    icon: Icons.emoji_emotions_rounded,
                    color: const Color(0xFFF0B527),
                    label: 'Feeling',
                    onTap: () => _compose(context),
                  ),
                ]),
              ]),
            ),
            const SizedBox(height: 8),
            _Stories(store: store),
            const SizedBox(height: 9),
            for (final post in store.posts)
              PostCard(
                key: ValueKey(post.id),
                post: post,
                store: store,
                onOpenProfile: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(builder: (_) => ProfilePage(store: store, userId: post.authorId)),
                ),
              ),
          ],
        ),
      );

  void _compose(BuildContext context) => Navigator.push<void>(
        context,
        MaterialPageRoute(builder: (_) => ComposePostPage(store: store)),
      );
}

class _QuickCompose extends StatelessWidget {
  const _QuickCompose({required this.icon, required this.color, required this.label, required this.onTap});
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          child: Row(children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 5),
            Text(label,
                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
          ]),
        ),
      );
}

class _Stories extends StatelessWidget {
  const _Stories({required this.store});
  final FacebookStore store;

  @override
  Widget build(BuildContext context) => WhiteSurface(
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: SizedBox(
          height: 187,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 13),
            itemCount: demoUsers.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final user = demoUsers[index];
              final isMine = index == 0;
              return GestureDetector(
                onTap: () {
                  if (isMine) {
                    Navigator.push(context, MaterialPageRoute<void>(
                      builder: (_) => ComposePostPage(store: store),
                    ));
                  } else {
                    Navigator.push(context, MaterialPageRoute<void>(
                      builder: (_) => StoryPage(store: store, userId: user.id),
                    ));
                  }
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: Container(
                    width: 111,
                    color: user.color.withOpacity(.2),
                    child: Stack(fit: StackFit.expand, children: [
                      if (isMine) ...[
                        const Positioned.fill(
                          child: SceneArtwork(scene: 'workspace', compact: true),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(height: 56, color: Colors.white),
                        ),
                        const Positioned(
                          bottom: 36,
                          left: 37,
                          child: CircleAvatar(
                            radius: 19,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: FbPalette.blue,
                              child: Icon(Icons.add, color: Colors.white, size: 22),
                            ),
                          ),
                        ),
                        const Positioned(
                          bottom: 9,
                          left: 5,
                          right: 5,
                          child: Text('Create story', textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                        ),
                      ] else ...[
                        Positioned.fill(child: SceneArtwork(
                          scene: index % 3 == 0 ? 'coffee' : index % 2 == 0 ? 'workspace' : 'nature',
                          compact: true,
                        )),
                        Positioned(
                          top: 9,
                          left: 9,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: FbPalette.blue,
                            ),
                            child: UserAvatar(user: user, radius: 17),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(8, 25, 8, 9),
                            decoration: BoxDecoration(gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black.withOpacity(.67)],
                            )),
                            child: Text(user.name,
                                maxLines: 2,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ],
                    ]),
                  ),
                ),
              );
            },
          ),
        ),
      );
}

class StoryPage extends StatelessWidget {
  const StoryPage({super.key, required this.store, required this.userId});
  final FacebookStore store;
  final int userId;

  @override
  Widget build(BuildContext context) {
    final user = store.userById(userId);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(fit: StackFit.expand, children: [
          SceneArtwork(scene: userId % 2 == 0 ? 'workspace' : 'nature'),
          Column(children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(12, 18, 12, 14),
              child: LinearProgressIndicator(value: 1, color: Colors.white, backgroundColor: Colors.white30),
            ),
            Row(children: [
              const SizedBox(width: 13),
              UserAvatar(user: user, radius: 19),
              const SizedBox(width: 10),
              Expanded(child: Text('${user.name}  ·  3h',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
              IconButton(onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white)),
            ]),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Reply to ${user.name}...',
                  hintStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.black26,
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onSubmitted: (text) {
                  final messenger = ScaffoldMessenger.of(context);
                  store.sendMessage(userId, text);
                  Navigator.pop(context);
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Reply sent')),
                  );
                },
              ),
            ),
          ]),
        ]),
      ),
    );
  }
}

class ComposePostPage extends StatefulWidget {
  const ComposePostPage({super.key, required this.store});
  final FacebookStore store;
  @override
  State<ComposePostPage> createState() => _ComposePostPageState();
}

class _ComposePostPageState extends State<ComposePostPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _publish() {
    if (_controller.text.trim().isEmpty) return;
    final messenger = ScaffoldMessenger.of(context);
    widget.store.addPost(_controller.text);
    Navigator.pop(context);
    messenger.showSnackBar(
      const SnackBar(content: Text('Your post was published')),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Create post'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: _controller,
                builder: (_, value, __) => FilledButton(
                  onPressed: value.text.trim().isEmpty ? null : _publish,
                  child: const Text('POST'),
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(17),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              UserAvatar(user: widget.store.currentUser),
              const SizedBox(width: 11),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(widget.store.currentUser.name,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const Row(children: [
                  Icon(Icons.public, size: 15, color: FbPalette.secondary),
                  SizedBox(width: 4),
                  Text('Public', style: TextStyle(color: FbPalette.secondary)),
                ]),
              ]),
            ]),
            const SizedBox(height: 22),
            TextField(
              controller: _controller,
              autofocus: true,
              maxLines: null,
              minLines: 5,
              style: const TextStyle(fontSize: 20),
              decoration: const InputDecoration(
                filled: false,
                border: InputBorder.none,
                hintText: "What's on your mind?",
              ),
            ),
            const Spacer(),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.photo_library, color: FbPalette.green),
              title: Text('Add to your post'),
              subtitle: Text('Text posts are supported in this offline demo'),
            ),
          ]),
        ),
      );
}
