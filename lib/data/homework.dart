class Homework {
  final String title;
  final String description;
  final String dueDate;
  bool isCollected = false;

  Homework({required this.title, required this.description, required this.dueDate, this.isCollected = false});
}