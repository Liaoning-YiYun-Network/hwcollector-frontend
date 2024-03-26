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
  final TextEditingController _pwdController = TextEditingController();
  bool _isObscure = true;

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
                      '欢迎使用在线文件收集系统',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 32),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '用户名',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _pwdController,
                      obscureText: _isObscure, // 是否隐藏正在编辑的文本
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: '密码',
                        suffixIcon: IconButton( // 新增按钮
                          icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure; // 切换密码的可见性
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        var name = _nameController.text;
                        var id = _pwdController.text;
                        if (name.isEmpty || id.isEmpty) {
                          showToast(widget.fToast, "用户名或密码不能为空", ToastType.warning);
                        } else {
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