import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FileInfoCard extends StatelessWidget {
  final PlatformFile file;
  final Function()? onTap;
  final Function()? onLongPress;

  const FileInfoCard({
    super.key,
    required this.file,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    // 计算文件大小，并根据文件大小选择合适的计量单位显示
    String size;
    if (file.size > 1024 * 1024) {
      size = '${(file.size / (1024 * 1024)).toStringAsFixed(2)} MB';
    } else if (file.size > 1024) {
      size = '${(file.size / 1024).toStringAsFixed(2)} KB';
    } else {
      size = '${file.size} B';
    }
    return Card(
      child: ListTile(
        leading: const Icon(Icons.file_copy),
        title: Text(file.name),
        subtitle: Text(size),
        onTap: onTap,
        onLongPress: onLongPress,
      ),
    );
  }

}