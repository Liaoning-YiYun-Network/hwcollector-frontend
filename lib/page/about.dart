import 'package:flutter/Material.dart';
import '../util/edge_judger.dart';

class AboutPage extends StatelessWidget {

  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('关于'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ),
      body: SafeArea(
        minimum: PlaformEdgeInsets(16),
        child: Center(
          child: Column(
            children: [
              const Text(
                '在线作业收集系统',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '作者：ZQDesigned',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '联系方式：QQ 2990918167',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              Expanded(child: Container()),
              const Text(
                '辽宁省熠云网络科技有限公司',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              Text(
                '版权所有 © 2023 - ${DateTime.now().year}',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}