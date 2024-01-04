import 'package:flutter/Material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_homework_collector/widget/dialog.dart';
import 'package:online_homework_collector/widget/homework_card.dart';

import '../data/homework.dart';
import '../global_data.dart';
import '../widget/toast.dart';

class HomeworkInfoPage extends StatefulWidget {

  const HomeworkInfoPage({super.key});

  @override
  State<StatefulWidget> createState() => _HomeworkInfoPageState();
}

class _HomeworkInfoPageState extends State<HomeworkInfoPage> {

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
        homeworks.addAll(List.generate(1000, (index) => Homework(
          title: '作业标题$index',
          description: '作业描述$index',
          dueDate: '2021-10-01',
          isCollected: index % 2 == 0,
        )));
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
            '当前作业信息',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          homeworks.isEmpty ? const CircularProgressIndicator() : Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: homeworks.length,
              itemBuilder: (context, index) {
                var currentHw = homeworks[index];
                return Builder(builder: (BuildContext context) {
                  return HomeworkCard(homework: currentHw, onTap: () {
                    if (currentHw.isCollected) {
                      fToast.init(context);
                      showToast(fToast, '你已经交过作业啦～', ToastType.info, place: ToastPlace.center);
                      return;
                    }
                    // 跳转到作业详情页
                    Navigator.pushNamed(context, '/submit', arguments: currentHw);
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