# Submission instructions — Route Assignment 7

## Mandatory files

- `lib/`: Flutter screens, widgets, models and application state
- `assets/`: illustrated demo image files
- `pubspec.yaml`: Flutter package definition and asset declarations
- A screen recording showing the app running **and being tested**

## Record your own real test

1. Install the Flutter SDK and Android Studio or open an Android emulator.
2. Run `flutter create --project-name facebook_task_flutter --platforms=android,web .` in the project root (if platform runners are missing).
3. Run `flutter pub get`, `flutter analyze`, `flutter test`, then `flutter run`.
4. Start the emulator's built-in **Record screen** feature.
5. Show Home, Friends, Video, Notifications, Menu.
6. Create a new post, like it, add a comment, send a friend request, search, open chat and send a message.
7. Stop recording and save the MP4 as `facebook_task_test_recording.mp4`.
8. Attach the MP4 to the submission if Route permits direct video upload, or upload it to a permitted shared video host and provide its link.

A real recording could not be generated here because there is no Flutter/Android runtime in the packaging environment. Do not represent a slideshow or fabricated video as evidence of testing.

## GitHub repository

1. Create a GitHub repository (for example `route-assignment-7-facebook-flutter`).
2. Run these commands from the Flutter project root after you install Git:

   ```sh
   git init
   git add .
   git commit -m "Route assignment 7: Facebook Flutter UI"
   git branch -M main
   git remote add origin https://github.com/YOUR_USERNAME/route-assignment-7-facebook-flutter.git
   git push -u origin main
   ```

3. Replace `YOUR_USERNAME` with your actual GitHub username. Link your GitHub account in the Route website and choose the repository.
4. Follow the course's upload instructions for `lib/`, `assets/`, `pubspec.yaml`, and the recording.

## Current limitations

- The supplied Figma document was not accessible to the Figma integration. This is a functional Facebook-inspired UI, not a verified pixel-perfect replica.
- No backend or Facebook API integration; demo data is in memory.
- Flutter SDK was not available in the packaging environment. Automated tests are included but were not executed here.
