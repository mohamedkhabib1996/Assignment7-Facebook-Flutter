#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
if ! command -v flutter >/dev/null 2>&1; then
  echo "Flutter SDK not found. Install Flutter, then run this script again." >&2
  exit 1
fi
flutter create --project-name facebook_task_flutter --platforms=android,web .
flutter pub get
flutter analyze
flutter test
printf '\nTo run, use: flutter run\n'
