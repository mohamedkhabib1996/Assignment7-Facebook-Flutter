import 'package:flutter/material.dart';
import '../core/facebook_theme.dart';
import '../data/demo_data.dart';
import '../state/facebook_store.dart';
import '../widgets/post_card.dart';
import '../widgets/shared_widgets.dart';
import 'profile_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.store});
  final FacebookStore store;
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();
  String query = '';

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() => query = _controller.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final matchingUsers = query.isEmpty
        ? demoUsers.skip(1).toList()
        : demoUsers.where((user) => user.name.toLowerCase().contains(query)).toList();
    final matchingPosts = query.isEmpty
        ? <int>[]
        : widget.store.posts
            .where((post) => post.message.toLowerCase().contains(query))
            .map((post) => post.id)
            .toList();
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 15),
          child: TextField(
            autofocus: true,
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Search Facebook',
              prefixIcon: Icon(Icons.search),
              isDense: true,
            ),
          ),
        ),
      ),
      body: AnimatedBuilder(
        animation: widget.store,
        builder: (context, _) => ListView(children: [
          WhiteSurface(child: SectionHeading(
            text: query.isEmpty ? 'Suggested people' : 'People',
          )),
          WhiteSurface(child: Column(children: [
            for (final user in matchingUsers)
              ListTile(
                leading: UserAvatar(user: user),
                title: Text(user.name),
                subtitle: Text(user.subtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(context, MaterialPageRoute<void>(
                  builder: (_) => ProfilePage(store: widget.store, userId: user.id),
                )),
              ),
            if (matchingUsers.isEmpty)
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text('No matching people',
                    style: TextStyle(color: FbPalette.secondary)),
              ),
          ])),
          if (query.isNotEmpty) ...[
            const SizedBox(height: 8),
            const WhiteSurface(child: SectionHeading(text: 'Posts')),
            for (final id in matchingPosts)
              PostCard(
                post: widget.store.posts.firstWhere((post) => post.id == id),
                store: widget.store,
              ),
            if (matchingPosts.isEmpty)
              const WhiteSurface(
                padding: EdgeInsets.all(20),
                child: Text('No matching posts', style: TextStyle(color: FbPalette.secondary)),
              ),
          ],
        ]),
      ),
    );
  }
}
