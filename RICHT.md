# Notes on running with Homebrew on a Mac

When you open the Dart files from Android Studio, the Dart SDK is not set. These
are in /usr/local/Caskroom/flutter/latest/flutter/bin/cache/dart-sdk and you
need to add them manually. It oculd be flutter doctor might fix this, by going
into each dart project and running `flutter create .`
