import 'package:flutter/foundation.dart';
import '../data/demo_data.dart';
import '../models/social_models.dart';

class FacebookStore extends ChangeNotifier {
  final List<FeedPost> posts = makeDemoPosts();
  final List<SocialNotification> notifications = makeDemoNotifications();
  final Set<int> friends = {1, 2};
  final Set<int> pendingRequests = {};
  final Map<int, List<ChatMessage>> conversations = {};
  int _nextPostId = 100;

  String _displayName = demoUsers[currentUserId].name;
  String _bio = demoUsers[currentUserId].subtitle;

  String get displayName => _displayName;
  String get bio => _bio;

  SocialUser get currentUser => SocialUser(
        id: currentUserId,
        name: _displayName,
        color: demoUsers[currentUserId].color,
        subtitle: _bio,
      );

  SocialUser userById(int id) =>
      id == currentUserId ? currentUser : demoUsers.firstWhere((user) => user.id == id);

  void updateProfile({required String name, required String bio}) {
    if (name.trim().isEmpty) return;
    _displayName = name.trim();
    _bio = bio.trim();
    notifyListeners();
  }

  int get unreadNotifications => notifications.where((item) => !item.read).length;

  void addPost(String content) {
    final trimmed = content.trim();
    if (trimmed.isEmpty) return;
    posts.insert(
      0,
      FeedPost(
        id: _nextPostId++,
        authorId: currentUserId,
        age: 'Just now',
        message: trimmed,
      ),
    );
    notifyListeners();
  }

  void toggleLike(int postId) {
    final post = posts.firstWhere((item) => item.id == postId);
    post.isLiked = !post.isLiked;
    notifyListeners();
  }

  void addComment(int postId, String content) {
    final trimmed = content.trim();
    if (trimmed.isEmpty) return;
    posts.firstWhere((item) => item.id == postId).comments.add(
          FeedComment(author: currentUser.name, text: trimmed),
        );
    notifyListeners();
  }

  void toggleFriend(int userId) {
    if (friends.contains(userId)) {
      friends.remove(userId);
    } else if (pendingRequests.contains(userId)) {
      pendingRequests.remove(userId);
    } else {
      pendingRequests.add(userId);
    }
    notifyListeners();
  }

  void acceptFriend(int userId) {
    pendingRequests.remove(userId);
    friends.add(userId);
    notifyListeners();
  }

  void markNotificationRead(int id) {
    final notice = notifications.firstWhere((item) => item.id == id);
    notice.read = true;
    notifyListeners();
  }

  void markNotificationsRead() {
    for (final notice in notifications) {
      notice.read = true;
    }
    notifyListeners();
  }

  void sendMessage(int userId, String content) {
    final trimmed = content.trim();
    if (trimmed.isEmpty) return;
    conversations.putIfAbsent(userId, () => []).add(
          ChatMessage(message: trimmed, fromMe: true, time: 'Now'),
        );
    notifyListeners();
  }
}
