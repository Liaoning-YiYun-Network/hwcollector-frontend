class CTask {
  final String title;
  final String description;
  final String dueDate;
  final CTaskType type;
  bool isCollected = false;

  CTask({required this.title, required this.description, required this.dueDate, this.type = CTaskType.photoOnly, this.isCollected = false});
}

enum CTaskType {
  // 仅上传图片
  photoOnly,
  // 允许混合上传
  mixedType,
  // 仅通知
  notificationOnly,
}