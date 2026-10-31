import 'package:flutter/material.dart';
import '../core/facebook_theme.dart';
import '../state/facebook_store.dart';
import '../widgets/shared_widgets.dart';
import 'friends_page.dart';
import 'messages_page.dart';
import 'profile_page.dart';
import 'search_page.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key, required this.store});
  final FacebookStore store;

  @override
  Widget build(BuildContext context) {
    final shortcuts = <_MenuShortcut>[
      _MenuShortcut('Friends', Icons.people_alt_rounded,
          () => FriendsPage(store: store)),
      _MenuShortcut('Memories', Icons.history,
          null),
      _MenuShortcut('Saved', Icons.bookmark_rounded, null),
      _MenuShortcut('Groups', Icons.groups_rounded, null),
      _MenuShortcut('Video', Icons.ondemand_video_rounded, null),
      _MenuShortcut('Messages', Icons.message_rounded,
          () => MessagesPage(store: store)),
      _MenuShortcut('Search', Icons.search_rounded,
          () => SearchPage(store: store)),
      _MenuShortcut('Pages', Icons.flag_rounded, null),
    ];

    return ListView(
      key: const PageStorageKey<String>('menu'),
      padding: const EdgeInsets.fromLTRB(15, 9, 15, 20),
      children: [
        const Text('Menu', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800)),
        const SizedBox(height: 14),
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            leading: UserAvatar(user: store.currentUser, radius: 24),
            title: Text(store.currentUser.name,
                style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: const Text('See your profile'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context, MaterialPageRoute<void>(
              builder: (_) => ProfilePage(store: store),
            )),
          ),
        ),
        const SizedBox(height: 18),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 76,
            mainAxisSpacing: 9,
            crossAxisSpacing: 9,
          ),
          itemCount: shortcuts.length,
          itemBuilder: (context, index) {
            final item = shortcuts[index];
            return Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  if (item.destination != null) {
                    Navigator.push(context, MaterialPageRoute<void>(
                      builder: (_) => item.destination!(),
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${item.label} is a preview shortcut')),
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(item.icon, color: FbPalette.blue, size: 27),
                      const SizedBox(height: 3),
                      Text(item.label, style: const TextStyle(fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 19),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.help_outline, color: FbPalette.secondary),
          title: const Text('Help & support'),
          trailing: const Icon(Icons.expand_more),
          onTap: () => showAboutDialog(
            context: context,
            applicationName: 'Facebook Task Flutter',
            applicationVersion: '1.0.0',
            children: [const Text('A learning project. Not affiliated with Meta.')],
          ),
        ),
        ListTile(
          leading: const Icon(Icons.settings_outlined, color: FbPalette.secondary),
          title: const Text('Settings & privacy'),
          trailing: const Icon(Icons.expand_more),
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Settings are not connected to a backend')),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton.tonalIcon(
          onPressed: () => showDialog<void>(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Offline demo'),
              content: const Text('This project uses local demo data. There is no real Facebook login or account.'),
              actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
            ),
          ),
          icon: const Icon(Icons.logout),
          label: const Text('Log out (demo)'),
        ),
      ],
    );
  }
}

class _MenuShortcut {
  const _MenuShortcut(this.label, this.icon, this.destination);
  final String label;
  final IconData icon;
  final Widget Function()? destination;
}
