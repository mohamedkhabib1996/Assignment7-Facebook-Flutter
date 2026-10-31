import 'package:flutter/material.dart';
import '../core/facebook_theme.dart';
import '../models/social_models.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, required this.user, this.radius = 22, this.showOnline = false});
  final SocialUser user;
  final double radius;
  final bool showOnline;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: radius * 2,
      height: radius * 2,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: radius,
            backgroundColor: user.color,
            child: Text(
              user.initials,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: radius * .59,
                color: Colors.white,
              ),
            ),
          ),
          if (showOnline)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: radius * .43,
                height: radius * .43,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: FbPalette.green,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class RoundIconButton extends StatelessWidget {
  const RoundIconButton({super.key, required this.icon, required this.onTap, this.size = 40});
  final IconData icon;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) => Material(
        color: FbPalette.background,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(width: size, height: size, child: Icon(icon, size: 23)),
        ),
      );
}

class SectionHeading extends StatelessWidget {
  const SectionHeading({super.key, required this.text, this.action, this.onAction});
  final String text;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
        child: Row(children: [
          Expanded(
            child: Text(text,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 21)),
          ),
          if (action != null)
            TextButton(onPressed: onAction, child: Text(action!)),
        ]),
      );
}

class WhiteSurface extends StatelessWidget {
  const WhiteSurface({super.key, required this.child, this.padding = EdgeInsets.zero});
  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) => Container(
        color: Colors.white,
        padding: padding,
        child: child,
      );
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.icon, required this.title, required this.subtitle});
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, color: FbPalette.secondary, size: 55),
            const SizedBox(height: 14),
            Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(color: FbPalette.secondary)),
          ]),
        ),
      );
}

/// Locally bundled illustration assets for demo posts, stories and video previews.
/// These were created for this assignment and are not exported from Figma.
class SceneArtwork extends StatelessWidget {
  const SceneArtwork({super.key, required this.scene, this.compact = false});

  final String scene;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    const images = <String, String>{
      'nature': 'assets/images/nature.png',
      'coffee': 'assets/images/coffee.png',
      'workspace': 'assets/images/workspace.png',
    };
    const captions = <String, String>{
      'nature': 'OUTSIDE IS THE BEST SIDE',
      'coffee': 'SLOW MORNINGS',
      'workspace': 'CREATE SOMETHING NEW',
    };
    final imagePath = images[scene] ?? images['workspace']!;
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(imagePath, fit: BoxFit.cover),
        if (!compact)
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.fromLTRB(18, 32, 18, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xB5001020)],
              ),
            ),
            child: Text(
              captions[scene] ?? 'CREATE SOMETHING NEW',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.6,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}
