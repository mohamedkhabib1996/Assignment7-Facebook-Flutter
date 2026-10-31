import 'package:flutter/material.dart';
import 'core/facebook_theme.dart';
import 'screens/social_shell.dart';
import 'state/facebook_store.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FacebookTaskApp());
}

class FacebookTaskApp extends StatefulWidget {
  const FacebookTaskApp({super.key});

  @override
  State<FacebookTaskApp> createState() => _FacebookTaskAppState();
}

class _FacebookTaskAppState extends State<FacebookTaskApp> {
  late final FacebookStore _store = FacebookStore();

  @override
  void dispose() {
    _store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Facebook Task',
        debugShowCheckedModeBanner: false,
        theme: facebookTheme(),
        home: SocialShell(store: _store),
      );
}
