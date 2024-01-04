import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

PlatformType _checkPlatform() {
  if (Platform.isAndroid) {
    return PlatformType.android;
  } else if (Platform.isIOS) {
    return PlatformType.ios;
  } else if (Platform.isMacOS) {
    return PlatformType.macos;
  } else if (Platform.isLinux) {
    return PlatformType.linux;
  } else if (Platform.isWindows) {
    return PlatformType.windows;
  } else {
    return PlatformType.unknown;
  }
}

bool get isMobile {
  var platform = _checkPlatform();
  return platform == PlatformType.android || platform == PlatformType.ios;
}

bool get isDesktop {
  var platform = _checkPlatform();
  return platform == PlatformType.macos ||
      platform == PlatformType.linux ||
      platform == PlatformType.windows;
}

bool get isWeb {
  var platform = _checkPlatform();
  return platform == PlatformType.unknown;
}

enum PlatformType {
  android,
  ios,
  macos,
  linux,
  windows,
  unknown,
}