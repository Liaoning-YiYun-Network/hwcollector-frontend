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
    return Card(
      child: ListTile(
        leading: const Icon(Icons.file_copy),
        title: Text(file.name),
        subtitle: Text(file.path??""), // 有可能为null
        trailing: Text('${file.size}B'),
        onTap: onTap,
        onLongPress: onLongPress,
      ),
    );
  }

}