import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(FToast fToast, String msg, ToastType type, {ToastPlace place = ToastPlace.top}) {
  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: type == ToastType.success
          ? Colors.greenAccent
          : type == ToastType.error
          ? Colors.redAccent
          : type == ToastType.warning
          ? Colors.orangeAccent
          : type == ToastType.info
          ? Colors.blueAccent
          : Colors.grey,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (type == ToastType.success)
          const Icon(Icons.check)
        else if (type == ToastType.error)
          const Icon(Icons.clear)
        else if (type == ToastType.warning)
            const Icon(Icons.warning)
          else if (type == ToastType.info)
              const Icon(Icons.info),
        if (type != ToastType.common)
          const SizedBox(width: 12.0),
        Text(msg),
      ],
    ),
  );

  if (place == ToastPlace.top) {
    fToast.showToast(
        child: toast,
        toastDuration: const Duration(seconds: 2),
        positionedToastBuilder: (context, child) {
          EdgeInsets safeAreaInsets = MediaQuery.of(context).padding;
          return Positioned(
            top: safeAreaInsets.top + 2.0,
            left: 4.0,
            right: 4.0,
            child: child,
          );
        }
    );
  } else if (place == ToastPlace.center) {
    fToast.showToast(
        child: toast,
        toastDuration: const Duration(seconds: 2),
        gravity: ToastGravity.CENTER
    );
  } else if (place == ToastPlace.bottom) {
    fToast.showToast(
        child: toast,
        toastDuration: const Duration(seconds: 2),
        gravity: ToastGravity.BOTTOM
    );
  }
}

enum ToastType {
  success,
  error,
  warning,
  info,
  common
}

enum ToastPlace {
  top,
  center,
  bottom
}