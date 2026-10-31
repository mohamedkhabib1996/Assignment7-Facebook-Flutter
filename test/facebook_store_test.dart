import 'package:flutter_test/flutter_test.dart';
import 'package:facebook_task_flutter/state/facebook_store.dart';

void main() {
  group('FacebookStore', () {
    late FacebookStore store;

    setUp(() => store = FacebookStore());
    tearDown(() => store.dispose());

    test('publishing prepends a new post', () {
      final originalLength = store.posts.length;
      store.addPost('  Hello friends!  ');
      expect(store.posts.length, originalLength + 1);
      expect(store.posts.first.message, 'Hello friends!');
      expect(store.posts.first.authorId, 0);
    });

    test('blank posts are ignored', () {
      final length = store.posts.length;
      store.addPost('   ');
      expect(store.posts.length, length);
    });

    test('likes can be toggled on and off', () {
      final post = store.posts.first;
      final initialLikes = post.likeCount;
      store.toggleLike(post.id);
      expect(post.likeCount, initialLikes + 1);
      store.toggleLike(post.id);
      expect(post.likeCount, initialLikes);
    });

    test('comments are trimmed and appended', () {
      final post = store.posts.first;
      final initialComments = post.comments.length;
      store.addComment(post.id, '  Nice picture!  ');
      expect(post.comments.length, initialComments + 1);
      expect(post.comments.last.text, 'Nice picture!');
    });

    test('friend requests can be sent and cancelled', () {
      expect(store.pendingRequests.contains(6), isFalse);
      store.toggleFriend(6);
      expect(store.pendingRequests.contains(6), isTrue);
      store.toggleFriend(6);
      expect(store.pendingRequests.contains(6), isFalse);
    });

    test('unread notifications can be cleared', () {
      expect(store.unreadNotifications, greaterThan(0));
      store.markNotificationsRead();
      expect(store.unreadNotifications, 0);
    });

    test('editing the current profile updates displayed fields', () {
      store.updateProfile(name: 'New Name', bio: 'New bio');
      expect(store.currentUser.name, 'New Name');
      expect(store.userById(0).subtitle, 'New bio');
    });

    test('only the selected notification is marked read', () {
      final before = store.unreadNotifications;
      store.markNotificationRead(1);
      expect(store.unreadNotifications, before - 1);
    });

    test('messages are kept per conversation', () {
      store.sendMessage(1, '  Hi!  ');
      expect(store.conversations[1]?.last.message, 'Hi!');
      expect(store.conversations[2], isNull);
    });
  });
}
