import 'package:isar/isar.dart';

part 'todo_modal.g.dart';

@Collection()
class Task {
  Id id = Isar.autoIncrement;
  late String title;
  late String? description;

  @enumerated
  late TaskCategory category;

  Task({
    required this.title,
    this.description,
    required this.category
  });
}

enum TaskCategory {
  Yesterday,
  Today,
  Tomorrow,
}
