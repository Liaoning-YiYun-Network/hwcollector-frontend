import 'package:file_picker/file_picker.dart';
import 'package:flutter/Material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_homework_collector/main.dart';
import 'package:online_homework_collector/widget/file_card.dart';

import '../data/homework.dart';
import '../util/network_io.dart';
import '../widget/dialog.dart';
import '../widget/toast.dart';

class SubmitPage extends StatefulWidget {

  const SubmitPage({super.key});

  @override
  State<StatefulWidget> createState() => _SubmitPageState();
}

class _SubmitPageState extends State<SubmitPage> {

  late FToast fToast;
  // 存储所有已经选择过的文件的List
  List<PlatformFile> files = [];

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    var arg = ModalRoute.of(context)?.settings.arguments;
    if (arg == null) {
      // 延迟三秒后navigate到系统主页
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          Navigator.pushNamed(context, '/');
        }
      });
      return const Scaffold(
        body: Center(
          child: Text('参数错误，3秒后自动返回系统主页...'),
        ),
      );
    }
    var homework = arg as Homework;
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text('提交作业'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // 判断files是否为空，如果不为空则弹出一个确认窗口，提示用户是否确认放弃提交作业
              if (files.isNotEmpty) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('确认放弃提交作业？'),
                      content: const Text('你的文件选择记录将不会被保存'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('取消'),
                        ),
                        TextButton(
                          onPressed: () {
                            // dismiss dialog
                            Navigator.pop(context);
                            FilePicker.platform.clearTemporaryFiles();
                            Future.delayed(const Duration(milliseconds: 100), () {
                              Navigator.of(navigatorKey.currentContext!).pop();
                              dispose();
                            });
                          },
                          child: const Text('确认'),
                        ),
                      ],
                    );
                  },
                );
              } else {
                Navigator.pop(context);
              }
            },
          )
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              homework.title,
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 16),
            // 作业描述
            Text(
              homework.description,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            // 作业截止日期
            Text(
              '截止时间：${homework.dueDate}',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            // 显示已经选择的文件
            Expanded(
              child: ListView.builder(
                itemCount: files.length,
                itemBuilder: (context, index) {
                  return FileInfoCard(file: files[index],
                      onTap: () {
                        // 弹出一个确认窗口，提示用户是否确认删除文件
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('确认删除文件？'),
                              content: const Text('删除后将无法恢复'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('取消'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // dismiss dialog
                                    Navigator.pop(context);
                                    setState(() {
                                      files.removeAt(index);
                                    });
                                  },
                                  child: const Text('确认'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 创建一个文件选择器
                  ElevatedButton(
                    onPressed: () async {
                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                          type: FileType.image,
                          allowMultiple: true
                      );
                      if(result != null) {
                        List<PlatformFile> selectedFiles = result.files;
                        setState(() {
                          // 先检查是否已经选择过该文件，如果已经选择过则不再添加
                          for (var file in selectedFiles) {
                            if (!files.contains(file)) {
                              files.add(file);
                            } else {
                              showToast(fToast, '${file.name}文件已经选择过啦～', ToastType.info);
                            }
                          }
                        });
                      } else {
                        // User canceled the picker
                      }
                    },
                    child: const Text('选择文件'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      // 判断用户是否已经选择了文件，如果没有则弹出一个toast提示用户
                      if (files.isEmpty) {
                        showToast(fToast, '你还没有选择文件哦～', ToastType.error, place: ToastPlace.center);
                        return;
                      }
                      showDialog(
                        context: context,
                        builder: (context) {
                          // 弹出一个确认窗口，提示用户是否确认提交作业
                          return AlertDialog(
                            title: const Text('确认提交作业？'),
                            content: const Text('提交后将无法修改'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('取消'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // dismiss dialog
                                  Navigator.pop(context);
                                  // show loading dialog
                                  showDialog(context: context, builder: (context) {
                                    request(
                                      'https://www.baidu.com',
                                    ).then((value) {
                                      Navigator.pop(context);
                                      if (value.statusCode == 200) {
                                        showToast(fToast, '提交成功', ToastType.success);
                                        Future.delayed(const Duration(milliseconds: 250), () {
                                          Navigator.of(navigatorKey.currentContext!).pop();
                                          dispose();
                                        });
                                      } else {
                                        showToast(fToast, '提交失败', ToastType.error);
                                      }
                                    });
                                    return const IndicatorDialog(text: '正在提交作业...');
                                  });
                                },
                                child: const Text('确认'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text('提交'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}