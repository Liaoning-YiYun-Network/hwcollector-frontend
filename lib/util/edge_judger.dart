import 'package:flutter/material.dart';
import 'package:online_homework_collector/util/platform.dart';

/// 根据平台返回不同的EdgeInsets
EdgeInsets PlaformEdgeInsets(double padding) {
  if (isMobile) {
    return EdgeInsets.only(left: padding, right: padding, top: padding);
  } else {
    return EdgeInsets.all(padding);
  }
}