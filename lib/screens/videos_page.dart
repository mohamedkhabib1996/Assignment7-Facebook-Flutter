import 'package:flutter/material.dart';
import '../core/facebook_theme.dart';
import '../data/demo_data.dart';
import '../widgets/shared_widgets.dart';

class VideosPage extends StatefulWidget {
  const VideosPage({super.key});
  @override
  State<VideosPage> createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  final Set<int> _liked = {};
  final Set<int> _playing = {};

  @override
  Widget build(BuildContext context) => ListView(
        key: const PageStorageKey<String>('videos'),
        children: [
          const WhiteSurface(child: SectionHeading(text: 'Video', action: 'For you')),
          const SizedBox(height: 8),
          for (int index = 0; index < 4; index++) ...[
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(14, 11, 14, 12),
              child: Row(children: [
                UserAvatar(user: demoUsers[index + 1], radius: 20),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(demoUsers[index + 1].name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const Text('Suggested videos · Public',
                        style: TextStyle(color: FbPalette.secondary, fontSize: 12)),
                  ]),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz)),
              ]),
            ),
            GestureDetector(
              onTap: () => setState(() => _playing.contains(index)
                  ? _playing.remove(index)
                  : _playing.add(index)),
              child: SizedBox(
                height: 285,
                child: Stack(fit: StackFit.expand, children: [
                  SceneArtwork(scene: index % 3 == 0
                      ? 'nature'
                      : index % 3 == 1 ? 'workspace' : 'coffee'),
                  Center(
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.black45,
                      child: Icon(
                        _playing.contains(index) ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                  const Positioned(
                    right: 12,
                    bottom: 10,
                    child: Text('Preview', style: TextStyle(color: Colors.white70)),
                  ),
                ]),
              ),
            ),
            Container(
              color: Colors.white,
              child: Row(children: [
                TextButton.icon(
                  onPressed: () => setState(() => _liked.contains(index)
                      ? _liked.remove(index)
                      : _liked.add(index)),
                  icon: Icon(_liked.contains(index) ? Icons.thumb_up : Icons.thumb_up_outlined),
                  label: Text(_liked.contains(index) ? 'Liked' : 'Like'),
                ),
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.all(13),
                  child: Text('Demo preview · no video stream',
                      style: TextStyle(color: FbPalette.secondary, fontSize: 12)),
                ),
              ]),
            ),
            const SizedBox(height: 9),
          ],
        ],
      );
}
