import 'package:flutter/material.dart';
import '../core/facebook_theme.dart';
import '../data/demo_data.dart';
import '../state/facebook_store.dart';
import '../widgets/post_card.dart';
import '../widgets/shared_widgets.dart';
import 'feed_page.dart';
import 'messages_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.store, this.userId = currentUserId});
  final FacebookStore store;
  final int userId;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          final user = store.userById(userId);
          final mine = userId == currentUserId;
          final userPosts = store.posts.where((post) => post.authorId == userId).toList();
          return Scaffold(
            appBar: AppBar(title: Text(user.name)),
            body: ListView(children: [
              Container(
                color: Colors.white,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SizedBox(
                    height: 220,
                    child: Stack(clipBehavior: Clip.none, children: [
                      Container(
                        height: 163,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF2D64BE), Color(0xFF9CC8F0)],
                          ),
                        ),
                        child: const Icon(Icons.landscape_outlined, color: Colors.white54, size: 105),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 17,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                          child: UserAvatar(user: user, radius: 65),
                        ),
                      ),
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 2, 18, 16),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(user.name,
                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 7),
                      Text('${mine ? store.friends.length : 250 + userId * 37} friends',
                          style: const TextStyle(color: FbPalette.secondary)),
                      const SizedBox(height: 14),
                      Row(children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: mine
                                ? () => Navigator.push(context, MaterialPageRoute<void>(
                                      builder: (_) => ComposePostPage(store: store),
                                    ))
                                : () => store.toggleFriend(userId),
                            icon: Icon(mine ? Icons.add : Icons.person_add_alt_1, size: 18),
                            label: Text(mine
                                ? 'Add to story'
                                : store.friends.contains(userId) ? 'Friends'
                                : store.pendingRequests.contains(userId) ? 'Requested' : 'Add friend'),
                          ),
                        ),
                        const SizedBox(width: 9),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: mine
                                ? () => Navigator.push(context, MaterialPageRoute<void>(
                                      builder: (_) => EditProfilePage(store: store),
                                    ))
                                : () => Navigator.push(context,
                              MaterialPageRoute<void>(
                                builder: (_) => ChatPage(store: store, userId: userId),
                              )),
                            style: FilledButton.styleFrom(
                              backgroundColor: FbPalette.background,
                              foregroundColor: FbPalette.ink,
                            ),
                            icon: Icon(mine ? Icons.edit_outlined : Icons.chat_bubble_outline, size: 18),
                            label: Text(mine ? 'Edit profile' : 'Message'),
                          ),
                        ),
                      ]),
                      const SizedBox(height: 16),
                      Row(children: [
                        const Icon(Icons.info_outline, size: 19, color: FbPalette.secondary),
                        const SizedBox(width: 9),
                        Text(user.subtitle.isEmpty ? 'Welcome to my profile' : user.subtitle),
                      ]),
                    ]),
                  ),
                ]),
              ),
              const SizedBox(height: 9),
              WhiteSurface(child: SectionHeading(text: 'Posts', action: '${userPosts.length} posts')),
              const SizedBox(height: 8),
              if (userPosts.isEmpty)
                const WhiteSurface(
                  padding: EdgeInsets.symmetric(vertical: 35),
                  child: EmptyState(
                    icon: Icons.post_add,
                    title: 'No posts yet',
                    subtitle: 'New posts will show up here.',
                  ),
                ),
              for (final post in userPosts) PostCard(post: post, store: store),
            ]),
          );
        },
      );
}


class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.store});
  final FacebookStore store;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _name =
      TextEditingController(text: widget.store.displayName);
  late final TextEditingController _bio =
      TextEditingController(text: widget.store.bio);

  @override
  void dispose() {
    _name.dispose();
    _bio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Edit profile')),
        body: ListView(padding: const EdgeInsets.all(18), children: [
          UserAvatar(user: widget.store.currentUser, radius: 46),
          const SizedBox(height: 25),
          const Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 7),
          TextField(controller: _name, maxLength: 60),
          const SizedBox(height: 12),
          const Text('Bio', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 7),
          TextField(controller: _bio, maxLength: 120),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () {
              if (_name.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter your name')),
                );
                return;
              }
              widget.store.updateProfile(name: _name.text, bio: _bio.text);
              Navigator.pop(context);
            },
            child: const Text('Save changes'),
          ),
        ]),
      );
}
