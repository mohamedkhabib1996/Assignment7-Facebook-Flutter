# Facebook Task — Flutter (Route Assignment 7)

A functional **Facebook-inspired mobile UI** written in Flutter using only standard Flutter widgets and local demo data. The app is designed to open in VS Code or Android Studio and run on Android, iOS (on macOS), or the web after the standard Flutter platform scaffolds are generated.

## What is included

- Home feed with post cards, sample stories, and quick actions.
- Create a text post; immediately see it at the top of the feed.
- Like/unlike posts; read and add comments; copy post text to clipboard.
- Friends screen with suggestions and send/cancel friend requests.
- Notifications with per-item read status and mark-all-as-read.
- Video feed with interactive preview cards (no real video streams).
- Profile screens, including editable local demo name and bio.
- Search people and existing posts.
- Messenger-style conversation list and working local send-message composer.
- Menu and responsive layout on phones / larger viewports.
- State-management and widget tests (`test/`).

## Figma reference and visual accuracy

Original reference provided in `ASS7.docx`:

- Figma design: https://www.figma.com/design/wEsmNNZETYJPjL6UbdFEBh/Facebook-Task?node-id=299-109
- Figma prototype: https://www.figma.com/proto/wEsmNNZETYJPjL6UbdFEBh/Facebook-Task?node-id=299-109

**Important:** The connected Figma service reported insufficient *edit access* to this file, and its node layers, assets, typography and measurements could not be fetched. This project is therefore a **functional Facebook-inspired reconstruction, not a verified pixel-perfect implementation** of the Figma source. Illustrative scene artwork is bundled locally in `assets/images/` and is not represented as original Figma assets.

## Prerequisites

- Flutter SDK (recent stable version, recommended Flutter 3.27+)
- Dart comes with Flutter
- Android SDK / Android Studio for Android, or Chrome for Flutter Web

No Firebase account, API keys, network, or paid packages required. Images are bundled locally under `assets/images/`.

## Run

**1.** Open the `facebook_task_flutter` folder in VS Code / Android Studio.

**2.** From its terminal, generate the platform-specific runner files (the environment in which this assignment was packaged did not have the Flutter SDK):

```bash
flutter create --project-name facebook_task_flutter --platforms=android,web .
```

On a Mac with Xcode installed, you can also include iOS:

```bash
flutter create --project-name facebook_task_flutter --platforms=android,ios,web .
```

**3.** Install dependencies, run checks, and launch:

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

For web: `flutter run -d chrome`.

The entry point is `lib/main.dart`.

## Project structure

```
lib/
  main.dart                    # Flutter entry point / app theme
  core/facebook_theme.dart    # Colors and Material theme
  models/social_models.dart   # Users, posts, comments, notifications
  data/demo_data.dart         # Local seed data
  state/facebook_store.dart   # ChangeNotifier + interactions
  screens/
    social_shell.dart         # Tab navigation and app header
    feed_page.dart            # Feed, stories, post composer
    friends_page.dart
    videos_page.dart
    notifications_page.dart
    profile_page.dart         # Profile + edit profile
    search_page.dart
    messages_page.dart        # Conversation list + chat
    menu_page.dart
  widgets/
    shared_widgets.dart       # Avatars, local artwork, UI primitives
    post_card.dart            # Post and comment sheet

assets/
  images/                     # 3 locally generated illustration assets
test/
  facebook_store_test.dart
  widget_test.dart
web/
  index.html
  manifest.json
```

## Functional scope / limitations

- Demo content and changes are **in memory only**; restarting the app resets posts, likes, friend requests, messages, and profile edits.
- There is no real authentication, Facebook API, backend, cloud sync, photo upload, or video playback.
- Menu features labelled preview are nonfunctional placeholders; they clearly display a message instead of silently doing nothing.
- To reach verified Figma fidelity, grant the connected Figma account access to the design or supply its screenshots and exported assets.

## Verification status

The source includes automated Flutter tests, but **Flutter/Dart SDK was not installed in the packaging environment**, so `flutter analyze`, `flutter test` and device compilation could not be executed here. Run those commands in a configured Flutter environment before submission.

> Educational clone. Not affiliated with or endorsed by Meta/Facebook.

## Route submission checklist (Assignment 7)

The assignment page specifies **four deliverables**:

1. `lib/` — present in the source ZIP and complete.
2. `assets/` — present with three local illustrations.
3. `pubspec.yaml` — present and registers `assets/images/`.
4. **Screen recording of the app being tested** — **not included**. This requires running the project in an emulator/device and recording a real demonstration. See `RECORDING_AND_GITHUB.md`.

The submission page also requires a **GitHub code repository**. Upload this project to a repository under your GitHub account, then connect your GitHub account in the Route submission interface. This archive is a source package, not evidence of a live GitHub submission.
