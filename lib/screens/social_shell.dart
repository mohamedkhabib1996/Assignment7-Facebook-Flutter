import 'package:flutter/material.dart';
import '../core/facebook_theme.dart';
import '../state/facebook_store.dart';
import '../widgets/shared_widgets.dart';
import 'feed_page.dart';
import 'friends_page.dart';
import 'messages_page.dart';
import 'menu_page.dart';
import 'notifications_page.dart';
import 'search_page.dart';
import 'videos_page.dart';

class SocialShell extends StatefulWidget {
  const SocialShell({super.key, required this.store});
  final FacebookStore store;

  @override
  State<SocialShell> createState() => _SocialShellState();
}

class _SocialShellState extends State<SocialShell> {
  int _currentIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      FeedPage(store: widget.store),
      FriendsPage(store: widget.store),
      const VideosPage(),
      NotificationsPage(store: widget.store),
      MenuPage(store: widget.store),
    ];
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          bottom: false,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 650),
              child: Column(children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(15, 7, 12, 5),
                  child: Row(children: [
                    const Expanded(
                      child: Text('facebook',
                          style: TextStyle(
                            color: FbPalette.blue,
                            fontSize: 29,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1.7,
                          )),
                    ),
                    RoundIconButton(
                      icon: Icons.add,
                      onTap: () => Navigator.push(context, MaterialPageRoute<void>(
                        builder: (_) => ComposePostPage(store: widget.store),
                      )),
                    ),
                    const SizedBox(width: 8),
                    RoundIconButton(
                      icon: Icons.search,
                      onTap: () => Navigator.push(context, MaterialPageRoute<void>(
                        builder: (_) => SearchPage(store: widget.store),
                      )),
                    ),
                    const SizedBox(width: 8),
                    RoundIconButton(
                      icon: Icons.chat_bubble_rounded,
                      onTap: () => Navigator.push(context, MaterialPageRoute<void>(
                        builder: (_) => MessagesPage(store: widget.store),
                      )),
                    ),
                  ]),
                ),
                AnimatedBuilder(
                  animation: widget.store,
                  builder: (context, _) => Container(
                    height: 53,
                    color: Colors.white,
                    child: Row(children: [
                      _NavTab(
                        icon: Icons.home_outlined,
                        selectedIcon: Icons.home,
                        selected: _currentIndex == 0,
                        tooltip: 'Home',
                        onTap: () => setState(() => _currentIndex = 0),
                      ),
                      _NavTab(
                        icon: Icons.people_outline,
                        selectedIcon: Icons.people,
                        selected: _currentIndex == 1,
                        tooltip: 'Friends',
                        onTap: () => setState(() => _currentIndex = 1),
                      ),
                      _NavTab(
                        icon: Icons.ondemand_video_outlined,
                        selectedIcon: Icons.ondemand_video,
                        selected: _currentIndex == 2,
                        tooltip: 'Video',
                        onTap: () => setState(() => _currentIndex = 2),
                      ),
                      _NavTab(
                        icon: Icons.notifications_none,
                        selectedIcon: Icons.notifications,
                        selected: _currentIndex == 3,
                        tooltip: 'Notifications',
                        badge: widget.store.unreadNotifications,
                        onTap: () => setState(() => _currentIndex = 3),
                      ),
                      _NavTab(
                        icon: Icons.menu,
                        selectedIcon: Icons.menu,
                        selected: _currentIndex == 4,
                        tooltip: 'Menu',
                        onTap: () => setState(() => _currentIndex = 4),
                      ),
                    ]),
                  ),
                ),
                Expanded(
                  child: IndexedStack(index: _currentIndex, children: _pages),
                ),
              ]),
            ),
          ),
        ),
      );
}

class _NavTab extends StatelessWidget {
  const _NavTab({
    required this.icon,
    required this.selectedIcon,
    required this.selected,
    required this.tooltip,
    required this.onTap,
    this.badge = 0,
  });
  final IconData icon;
  final IconData selectedIcon;
  final bool selected;
  final String tooltip;
  final int badge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Tooltip(
          message: tooltip,
          child: InkWell(
            onTap: onTap,
            child: Column(children: [
              Expanded(
                child: Center(
                  child: Stack(clipBehavior: Clip.none, children: [
                    Icon(selected ? selectedIcon : icon,
                        color: selected ? FbPalette.blue : FbPalette.secondary,
                        size: 27),
                    if (badge > 0)
                      Positioned(
                        right: -12,
                        top: -8,
                        child: Container(
                          constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: const BoxDecoration(
                            color: Color(0xFFE63748),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Text('$badge',
                              style: const TextStyle(color: Colors.white, fontSize: 11)),
                        ),
                      ),
                  ]),
                ),
              ),
              Container(
                height: 3,
                color: selected ? FbPalette.blue : Colors.transparent,
              ),
            ]),
          ),
        ),
      );
}
