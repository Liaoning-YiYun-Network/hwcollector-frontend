import 'package:flutter/material.dart';

import '../data/homework.dart';

class HomeworkCard extends StatelessWidget {
  final Homework homework;
  final Function()? onTap;

  const HomeworkCard({super.key, required this.homework, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(homework.title),
        subtitle: Text(homework.description),
        trailing: homework.isCollected ?
        const SizedBox(
          width: 80, // specify your desired width
          child: Row(
            children: [
              Icon(Icons.check, color: Colors.green),
              Text('已提交'),
            ],
          ),
        ) : Text(homework.dueDate),
        onTap: onTap,
      ),
    );
  }
}