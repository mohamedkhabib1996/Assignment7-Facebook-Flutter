import 'package:flutter/material.dart';

class SocialUser {
  const SocialUser({
    required this.id,
    required this.name,
    required this.color,
    this.subtitle = '',
  });

  final int id;
  final String name;
  final Color color;
  final String subtitle;

  String get initials => name
      .split(' ')
      .where((part) => part.isNotEmpty)
      .take(2)
      .map((part) => part[0].toUpperCase())
      .join();
}

class FeedComment {
  const FeedComment({required this.author, required this.text});
  final String author;
  final String text;
}

class FeedPost {
  FeedPost({
    required this.id,
    required this.authorId,
    required this.age,
    required this.message,
    this.scene,
    this.baseLikes = 0,
    List<FeedComment>? comments,
  }) : comments = comments ?? <FeedComment>[];

  final int id;
  final int authorId;
  final String age;
  final String message;
  final String? scene;
  int baseLikes;
  bool isLiked = false;
  final List<FeedComment> comments;

  int get likeCount => baseLikes + (isLiked ? 1 : 0);
}

class SocialNotification {
  SocialNotification({
    required this.id,
    required this.userId,
    required this.message,
    required this.age,
    this.read = false,
  });
  final int id;
  final int userId;
  final String message;
  final String age;
  bool read;
}

class ChatMessage {
  ChatMessage({required this.message, required this.fromMe, required this.time});
  final String message;
  final bool fromMe;
  final String time;
}
