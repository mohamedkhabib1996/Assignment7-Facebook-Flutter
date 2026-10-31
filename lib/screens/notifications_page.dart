import 'package:flutter/material.dart';
import '../core/facebook_theme.dart';
import '../state/facebook_store.dart';
import '../widgets/shared_widgets.dart';
import 'profile_page.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key, required this.store});
  final FacebookStore store;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: store,
        builder: (context, _) => ListView(
          key: const PageStorageKey<String>('notifications'),
          children: [
            WhiteSurface(
              child: Column(children: [
                SectionHeading(
                  text: 'Notifications',
                  action: 'Mark all as read',
                  onAction: store.markNotificationsRead,
                ),
                for (final item in store.notifications)
                  InkWell(
                    onTap: () {
                      store.markNotificationRead(item.id);
                      Navigator.push(context, MaterialPageRoute<void>(
                        builder: (_) => ProfilePage(store: store, userId: item.userId),
                      ));
                    },
                    child: Container(
                      color: item.read ? Colors.white : const Color(0xFFE9F1FF),
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                      child: Row(children: [
                        UserAvatar(user: store.userById(item.userId), radius: 30),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text.rich(TextSpan(children: [
                              TextSpan(
                                text: '${store.userById(item.userId).name} ',
                                style: const TextStyle(fontWeight: FontWeight.w700),
                              ),
                              TextSpan(text: item.message),
                            ]), style: const TextStyle(fontSize: 14.5)),
                            const SizedBox(height: 5),
                            Text(item.age,
                                style: const TextStyle(color: FbPalette.blue, fontSize: 12)),
                          ]),
                        ),
                        if (!item.read)
                          const CircleAvatar(radius: 5, backgroundColor: FbPalette.blue),
                      ]),
                    ),
                  ),
              ]),
            ),
          ],
        ),
      );
}
