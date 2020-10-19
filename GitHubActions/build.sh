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
  set -o pipefail && xcodebuild build -project InputBarAccessoryView.xcodeproj -scheme InputBarAccessoryView -destination "platform=iOS Simulator,name=iPhone 11 Pro" CODE_SIGNING_REQUIRED=NO | xcpretty -c
  success="1"
fi

if [ "$MODE" = "example" -o "$MODE" = "all" ]; then
  echo "Building InputBarAccessoryView Example app."
  set -o pipefail && xcodebuild build analyze -workspace InputBarAccessoryView.xcworkspace -scheme Example -destination "platform=iOS Simulator,name=iPhone 11 Pro" CODE_SIGNING_REQUIRED=NO | xcpretty -c
  success="1"
fi

if [ "$success" = "1" ]; then
trap - EXIT
exit 0
fi

echo "Unrecognised mode '$MODE'."
