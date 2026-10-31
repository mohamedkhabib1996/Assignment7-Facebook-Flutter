import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/facebook_theme.dart';
import '../models/social_models.dart';
import '../state/facebook_store.dart';
import 'shared_widgets.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
    required this.store,
    this.onOpenProfile,
  });
  final FeedPost post;
  final FacebookStore store;
  final VoidCallback? onOpenProfile;

  void _openComments(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => CommentsSheet(post: post, store: store),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = store.userById(post.authorId);
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      color: Colors.white,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 13, 9, 11),
          child: Row(children: [
            GestureDetector(
              onTap: onOpenProfile,
              child: UserAvatar(user: user, radius: 21),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(user.name,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                const SizedBox(height: 3),
                Row(children: [
                  Text(post.age,
                      style: const TextStyle(color: FbPalette.secondary, fontSize: 12)),
                  const SizedBox(width: 4),
                  const Icon(Icons.public, color: FbPalette.secondary, size: 13),
                ]),
              ]),
            ),
            IconButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('More post options coming soon')),
              ),
              icon: const Icon(Icons.more_horiz, color: FbPalette.secondary),
            ),
          ]),
        ),
        if (post.message.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 13),
            child: Text(post.message, style: const TextStyle(fontSize: 15.5, height: 1.36)),
          ),
        if (post.scene != null)
          AspectRatio(
            aspectRatio: 1.46,
            child: SceneArtwork(scene: post.scene!),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(children: [
            const CircleAvatar(
              radius: 10,
              backgroundColor: FbPalette.blue,
              child: Icon(Icons.thumb_up, color: Colors.white, size: 11),
            ),
            const SizedBox(width: 6),
            Text('${post.likeCount}',
                style: const TextStyle(color: FbPalette.secondary, fontSize: 13)),
            const Spacer(),
            Text('${post.comments.length} comments',
                style: const TextStyle(color: FbPalette.secondary, fontSize: 13)),
          ]),
        ),
        const Divider(height: 1, indent: 15, endIndent: 15),
        SizedBox(
          height: 48,
          child: Row(children: [
            Expanded(
              child: _PostAction(
                icon: post.isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                label: 'Like',
                color: post.isLiked ? FbPalette.blue : FbPalette.secondary,
                onTap: () => store.toggleLike(post.id),
              ),
            ),
            Expanded(
              child: _PostAction(
                icon: Icons.mode_comment_outlined,
                label: 'Comment',
                onTap: () => _openComments(context),
              ),
            ),
            Expanded(
              child: _PostAction(
                icon: Icons.share_outlined,
                label: 'Share',
                onTap: () async {
                  await Clipboard.setData(ClipboardData(text: post.message));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Post text copied')),
                    );
                  }
                },
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

class _PostAction extends StatelessWidget {
  const _PostAction({required this.icon, required this.label, required this.onTap, this.color});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 21, color: color ?? FbPalette.secondary),
          const SizedBox(width: 6),
          Flexible(
            child: Text(label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: color ?? FbPalette.secondary,
                )),
          ),
        ]),
      );
}

class CommentsSheet extends StatefulWidget {
  const CommentsSheet({super.key, required this.post, required this.store});
  final FeedPost post;
  final FacebookStore store;
  @override
  State<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<CommentsSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    widget.store.addComment(widget.post.id, _controller.text);
    _controller.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: widget.store,
        builder: (context, _) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height * .65,
            child: Column(children: [
              Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: FbPalette.border,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Text('Comments (${widget.post.comments.length})',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Divider(height: 22),
              Expanded(
                child: widget.post.comments.isEmpty
                    ? const EmptyState(
                        icon: Icons.chat_bubble_outline,
                        title: 'No comments yet',
                        subtitle: 'Start the conversation.',
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: widget.post.comments.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final comment = widget.post.comments[index];
                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: FbPalette.background,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(comment.author,
                                    style: const TextStyle(fontWeight: FontWeight.w700)),
                                const SizedBox(height: 3),
                                Text(comment.text),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(children: [
                  UserAvatar(user: widget.store.currentUser, radius: 19),
                  const SizedBox(width: 9),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      decoration: const InputDecoration(
                        hintText: 'Write a comment...',
                        isDense: true,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _send,
                    tooltip: 'Send comment',
                    icon: const Icon(Icons.send_rounded, color: FbPalette.blue),
                  ),
                ]),
              ),
            ]),
          ),
        ),
      );
}
