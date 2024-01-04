import 'package:flutter/material.dart';

import 'data/homework.dart';

String get apiDomain => 'http://localhost:8080';

// 登录状态标识
ValueNotifier<bool> isLogin = ValueNotifier(false);

List<Homework> homeworks = [];

// 用户token
String token = '';

// 用户名
String userName = '';