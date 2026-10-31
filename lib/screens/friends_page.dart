import 'package:flutter/material.dart';
import '../core/facebook_theme.dart';
import '../data/demo_data.dart';
import '../state/facebook_store.dart';
import '../widgets/shared_widgets.dart';
import 'profile_page.dart';

class FriendsPage extends StatelessWidget {
  const FriendsPage({super.key, required this.store});
  final FacebookStore store;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: store,
        builder: (context, _) => ListView(
          key: const PageStorageKey<String>('friends'),
          children: [
            WhiteSurface(
              child: SectionHeading(
                text: 'Friends',
                action: '${store.friends.length} friends',
              ),
            ),
            const SizedBox(height: 8),
            WhiteSurface(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SectionHeading(text: 'People you may know'),
                for (final user in demoUsers.skip(1))
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute<void>(
                          builder: (_) => ProfilePage(store: store, userId: user.id),
                        )),
                        child: UserAvatar(user: user, radius: 36),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(user.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 4),
                          Text(user.subtitle,
                              style: const TextStyle(color: FbPalette.secondary, fontSize: 13)),
                          const SizedBox(height: 10),
                          Row(children: [
                            Expanded(
                              child: FilledButton(
                                onPressed: () => store.toggleFriend(user.id),
                                style: FilledButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  backgroundColor: store.friends.contains(user.id)
                                      ? FbPalette.background
                                      : store.pendingRequests.contains(user.id)
                                          ? FbPalette.background
                                          : FbPalette.blue,
                                  foregroundColor: store.friends.contains(user.id) ||
                                          store.pendingRequests.contains(user.id)
                                      ? FbPalette.ink
                                      : Colors.white,
                                ),
                                child: Text(store.friends.contains(user.id)
                                    ? 'Friends'
                                    : store.pendingRequests.contains(user.id)
                                        ? 'Cancel request'
                                        : 'Add friend',
                                    style: const TextStyle(fontSize: 13)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (!store.friends.contains(user.id) &&
                                !store.pendingRequests.contains(user.id))
                              Expanded(
                                child: FilledButton(
                                  onPressed: () => Navigator.push(context, MaterialPageRoute<void>(
                                    builder: (_) => ProfilePage(store: store, userId: user.id),
                                  )),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: FbPalette.background,
                                    foregroundColor: FbPalette.ink,
                                  ),
                                  child: const Text('View profile', style: TextStyle(fontSize: 12)),
                                ),
                              ),
                          ]),
                        ]),
                      ),
                    ]),
                  ),
              ]),
            ),
          ],
        ),
      );
}
