import 'package:flutter/material.dart';
import '../models/social_models.dart';

const currentUserId = 0;

const demoUsers = <SocialUser>[
  SocialUser(id: 0, name: 'Alex Morgan', color: Color(0xFF3771C8), subtitle: 'Flutter developer'),
  SocialUser(id: 1, name: 'Sarah Ahmed', color: Color(0xFFAF74B6), subtitle: 'Lives in Cairo'),
  SocialUser(id: 2, name: 'Omar Hassan', color: Color(0xFF359C91), subtitle: '12 mutual friends'),
  SocialUser(id: 3, name: 'Nour Adel', color: Color(0xFFE3A040), subtitle: '8 mutual friends'),
  SocialUser(id: 4, name: 'Mina Samir', color: Color(0xFFCB735F), subtitle: '17 mutual friends'),
  SocialUser(id: 5, name: 'Laila Mostafa', color: Color(0xFF8270C8), subtitle: '3 mutual friends'),
  SocialUser(id: 6, name: 'Youssef Ali', color: Color(0xFF4F9EBD), subtitle: '9 mutual friends'),
];

List<FeedPost> makeDemoPosts() => [
      FeedPost(
        id: 1,
        authorId: 1,
        age: '2 hr',
        message: 'Sometimes you just need to get outside, slow down, and enjoy the view. What a beautiful day! ☀️',
        scene: 'nature',
        baseLikes: 248,
        comments: [
          const FeedComment(author: 'Omar Hassan', text: 'This looks amazing!'),
          const FeedComment(author: 'Nour Adel', text: 'Love this view!'),
        ],
      ),
      FeedPost(
        id: 2,
        authorId: 2,
        age: '5 hr',
        message: 'Just wrapped up a new Flutter project. Small steps every day make a big difference. 💙',
        scene: 'workspace',
        baseLikes: 156,
        comments: [
          const FeedComment(author: 'Sarah Ahmed', text: 'Congratulations!'),
        ],
      ),
      FeedPost(
        id: 3,
        authorId: 3,
        age: 'Yesterday',
        message: 'Coffee, good company, and the perfect Saturday. How is your weekend going?',
        scene: 'coffee',
        baseLikes: 89,
      ),
      FeedPost(
        id: 4,
        authorId: 4,
        age: '2 days',
        message: 'A reminder to keep creating things you love. Every idea starts somewhere.',
        baseLikes: 68,
      ),
    ];

List<SocialNotification> makeDemoNotifications() => [
      SocialNotification(id: 1, userId: 1, message: 'liked your photo.', age: '12 min'),
      SocialNotification(id: 2, userId: 2, message: 'commented on your post.', age: '1 hr'),
      SocialNotification(id: 3, userId: 3, message: 'sent you a friend request.', age: '3 hr'),
      SocialNotification(id: 4, userId: 4, message: 'mentioned you in a comment.', age: 'Yesterday', read: true),
      SocialNotification(id: 5, userId: 5, message: 'shared a new story.', age: 'Yesterday', read: true),
    ];
