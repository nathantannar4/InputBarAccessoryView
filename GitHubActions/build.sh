#!/bin/bash

set -e
function trap_handler {
  echo -e "\n\nOh no! You walked directly into the slavering fangs of a lurking grue!"
  echo "**** You have died ****"
  exit 255
}
trap trap_handler INT TERM EXIT

MODE="$1"

if [ "$MODE" = "framework" -o "$MODE" = "all" ]; then
  echo "Building InputBarAccessoryView Framework."
  set -o pipefail && xcodebuild build -scheme InputBarAccessoryView -sdk iphonesimulator -destination "platform=iOS Simulator,name=iPhone 14" | xcpretty -c
  success="1"
fi

if [ "$MODE" = "example" -o "$MODE" = "all" ]; then
  echo "Building InputBarAccessoryView Example app."
  set -o pipefail && xcodebuild build -project Example/Example.xcodeproj -scheme Example -sdk iphonesimulator -destination "platform=iOS Simulator,name=iPhone 14 Pro" | xcpretty -c
  success="1"
fi

if [ "$success" = "1" ]; then
trap - EXIT
exit 0
fi

echo "Unrecognised mode '$MODE'."
