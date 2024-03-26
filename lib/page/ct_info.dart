import 'package:flutter/Material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_homework_collector/widget/dialog.dart';
import 'package:online_homework_collector/widget/homework_card.dart';

import '../data/collect_task.dart';
import '../global_data.dart';
import '../widget/toast.dart';

class CTaskInfoPage extends StatefulWidget {

  const CTaskInfoPage({super.key});

  @override
  State<StatefulWidget> createState() => _CTaskInfoPageState();
}

class _CTaskInfoPageState extends State<CTaskInfoPage> {

  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    fetchData().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        //连续添加三十份作业信息到homeworks
        collectTasks.addAll(List.generate(1000, (index) {
          // 判断index除以 3 的余数，如果余数为 0 则返回作业类型为混合类型，如果余数为 1 则返回作业类型为图片，如果余数为 2 则返回作业类型为通知
          CTaskType type = index % 3 == 0 ? CTaskType.mixedType : index % 3 == 1 ? CTaskType.photoOnly : CTaskType.notificationOnly;
          return CTask(
            title: '标题$index',
            description: '描述$index',
            dueDate: '2021-10-01',
            type: type,
            isCollected: index % 2 == 0,
          );
        }));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Column(
        children: [
          // 标题组件
          const Text(
            '当前收集任务信息',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          collectTasks.isEmpty ? const CircularProgressIndicator() : Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: collectTasks.length,
              itemBuilder: (context, index) {
                var currentCT = collectTasks[index];
                return Builder(builder: (BuildContext context) {
                  return HomeworkCard(homework: currentCT, onTap: () {
                    if (currentCT.isCollected) {
                      fToast.init(context);
                      showToast(fToast, '你已经提交过啦～', ToastType.info, place: ToastPlace.center);
                      return;
                    }
                    // 跳转到作业详情页
                    Navigator.pushNamed(context, '/submit', arguments: currentCT);
                  });
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}