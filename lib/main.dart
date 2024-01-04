import 'dart:developer';

import 'package:online_homework_collector/page/about.dart';
import 'package:online_homework_collector/page/hw_info.dart';
import 'package:online_homework_collector/page/login.dart';
import 'package:online_homework_collector/page/submit.dart';
import 'package:online_homework_collector/util/network_io.dart';
import 'package:online_homework_collector/widget/toast.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'global_data.dart';


GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '来交作业啦！',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '在线作业收集系统'),
      builder: FToastBuilder(),
      navigatorKey: navigatorKey,
      routes: {
        '/about': (context) => const AboutPage(),
        '/submit': (context) => const SubmitPage(),
      }
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  late FToast fToast;
  late Size _size;
  bool get _isWideScreen => _size.aspectRatio > 1.15;
  bool _isLogin = false;

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  void initState() {
    super.initState();
    // 请求一下百度主页，测试网络是否正常
    DioFactory()
        .setRequestUrl('https://www.baidu.com')
        .setCallback(
            (response, _) {
              if (response.statusCode != 200) showToast(fToast, "网络连接失败，请检查网络设置", ToastType.error);
              log(response.data);
            },
            (error, _) {
              showToast(fToast, "网络连接失败，请检查网络设置", ToastType.error);
            }
        ).request();
    fToast = FToast();
    fToast.init(navigatorKey.currentContext!);
    WidgetsBinding.instance.addObserver(this);
    isLogin.addListener(() {
      setState(() {
        _isLogin = isLogin.value;
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _size = MediaQuery.of(context).size;
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    setState(() {
      _size = MediaQuery.of(context).size;
    });
  }

  Widget drawer(BuildContext context, bool isWideScreen) {
    // 获取系统SafeArea的padding
    final EdgeInsets padding = MediaQuery.of(context).padding;
    return Drawer(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: isWideScreen ? Radius.zero : const Radius.circular(20),
            bottomRight: isWideScreen ? Radius.zero : const Radius.circular(20),
          )
      ),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: isWideScreen ? padding.bottom : 0,
        ),
        child: Column(
          children: [
            Expanded(
              flex: 16,
              child: ListView(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '在线作业收集系统',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                        const Text(
                          'Author: ZQDesigned',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        if (_isLogin)
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                '用户名：$userName',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: const Text('关于'),
                    onTap: () {
                      if (!_isWideScreen) {
                        Navigator.pop(context);
                      }
                      Navigator.pushNamed(context, '/about');
                    },
                  ),
                  if (_isLogin)
                    ListTile(
                      title: const Text('退出登录'),
                      onTap: () {
                        setState(() {
                          isLogin.value = false;
                        });
                        if (!_isWideScreen) {
                          Navigator.pop(context);
                        }
                        homeworks.clear();
                        showToast(FToast().init(context), "退出登录成功", ToastType.success);
                      },
                    ),
                ],
              ),
            ),
            Expanded(
                flex: 1,
                child: Container()
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    children: [
                      Text(
                        'Copyright © 2023 - ${DateTime.now().year}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      const Text(
                        'ZQDesigned',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      const Text(
                        'All Rights Reserved.',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageStorage(
        bucket: bucket,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(widget.title),
          ),
          drawer: _isWideScreen ? null : drawer(context, _isWideScreen),
          body: Row(
            children: [
              if (_isWideScreen)
                Expanded(
                  flex: 5,
                  child: drawer(context, _isWideScreen),
                ),
              Expanded(
                flex: 16,
                child: _isLogin ? const HomeworkInfoPage() : LoginPage(size: _size, fToast: fToast),
              ),
            ],
          ),
        ),
    );
  }
}
