import 'package:flutter/material.dart';

import 'data/collect_task.dart';

String get apiDomain => 'http://localhost:8080';

// 登录状态标识
ValueNotifier<bool> isLogin = ValueNotifier(false);

List<CTask> collectTasks = [];

// 用户token
String token = '';

// 用户名
String userName = '';