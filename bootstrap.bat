@echo off
cd /d "%~dp0"
where flutter >nul 2>&1
if errorlevel 1 (
  echo Flutter SDK not found. Install Flutter, then run this script again.
  exit /b 1
)
flutter create --project-name facebook_task_flutter --platforms=android,web . || exit /b 1
flutter pub get || exit /b 1
flutter analyze || exit /b 1
flutter test || exit /b 1
echo To run, use: flutter run
