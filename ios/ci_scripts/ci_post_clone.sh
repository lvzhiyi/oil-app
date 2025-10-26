#!/bin/sh

# Fail this script if any subcommand fails.
set -e

# The default execution directory of this script is the ci_scripts directory.
cd $CI_PRIMARY_REPOSITORY_PATH # change working directory to the root of your cloned repo.

# Install Flutter using git.
git clone https://github.com/flutter/flutter.git --depth 1 -b stable $HOME/flutter
export PATH="$PATH:$HOME/flutter/bin"

# 添加 token
echo "eYTzX3Ti4wpQO085" | flutter pub token add https://dart.cloudsmith.io/flutter-qsfx/flutter-package/
echo "hZSSW9kMbY5ti7zI" | flutter pub token add https://dart.cloudsmith.io/workspace-for-wai-loon/sportsdk_package/

# Install Flutter artifacts for iOS (--ios), or macOS (--macos) platforms.
flutter precache --ios

# Install Flutter dependencies.
flutter pub get

# Install CocoaPods using Homebrew.
HOMEBREW_NO_AUTO_UPDATE=1 # disable homebrew's automatic updates.
brew install cocoapods

# Install CocoaPods dependencies.
cd ios && pod install --repo-update # run `pod install` in the `ios` directory.

exit 0
