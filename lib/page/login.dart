import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../global_data.dart';
import '../widget/dialog.dart';
import '../widget/toast.dart';

class LoginPage extends StatefulWidget {

  final Size size;
  final FToast fToast;

  const LoginPage({super.key, required this.size, required this.fToast});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 4 * widget.size.width / 21, right: 4 * widget.size.width / 21),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '欢迎使用在线作业收集系统',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 32),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '姓名',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _idController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '学号',
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        var name = _nameController.text;
                        var id = _idController.text;
                        if (name.isEmpty || id.isEmpty) {
                          showToast(widget.fToast, "姓名或学号不能为空", ToastType.warning);
                        } else {
                          // 判断姓名是否为2-3个汉字
                          RegExp nameRegExp = RegExp(r'^[\u4e00-\u9fa5]{2,3}$');
                          if (!nameRegExp.hasMatch(name)) {
                            showToast(widget.fToast, "姓名应为两到三个汉字！", ToastType.warning);
                            return;
                          }
                          // 判断学号是否为10位数字
                          RegExp idRegExp = RegExp(r'^\d{10}$');
                          if (!idRegExp.hasMatch(id)) {
                            showToast(widget.fToast, "学号格式不正确！", ToastType.warning);
                            return;
                          }
                          // 创建一个新的 FocusNode 实例
                          FocusNode newFocus = FocusNode();
                          // 使编辑框失去焦点
                          FocusScope.of(context).requestFocus(newFocus);
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              fetchData().then((value) {
                                Navigator.pop(context);
                                showToast(widget.fToast, "登录成功", ToastType.success, place: ToastPlace.center);
                                userName = name;
                                isLogin.value = true;
                              });
                              return const IndicatorDialog(
                                text: '正在登录中...',
                              );
                            },
                          );
                        }
                      },
                      child: const Text('登录'),
                    ),
                  ],
                )
            ),
            Expanded(flex: 2, child: Container()),
          ],
        ),
      ),
    );
  }
}