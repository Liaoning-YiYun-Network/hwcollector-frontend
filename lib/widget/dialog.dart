import 'dart:async';

import 'package:flutter/material.dart';

Future<void> fetchData() async {
  // 模拟网络请求，延迟2秒
  await Future.delayed(const Duration(seconds: 2));
}

class IndicatorDialog extends StatelessWidget {
  final String text;
  final bool isShowText;

  const IndicatorDialog({
    super.key,
    required this.text,
    this.isShowText = true,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Container(
        color: Colors.transparent,
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isShowText)
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                if (isShowText) const SizedBox(width: 16),
                const CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}