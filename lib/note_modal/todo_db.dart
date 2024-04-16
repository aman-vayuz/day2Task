import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vayuz_todo/note_modal/todo_modal.dart';
import 'package:flutter/cupertino.dart';

class TodoDbProvider extends ChangeNotifier {
  static late Isar isar;

  Future<void> initialise() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([TaskSchema], directory: dir.path);
  }

  final List<Task> currentNote = [];


  Future<void> addNote(String title, String? description , TaskCategory taskCategory) async {
    final newNote = Task(title: title , description:  description , category : taskCategory );

    await isar.writeTxn(() => isar.tasks.put(newNote));
    fetchNote();
  }

  Future<void> fetchNote() async {
    final fetchedNote = await isar.tasks.where().findAll();
    currentNote.clear();
    currentNote.addAll(fetchedNote);
    print("the current list should be ${currentNote.length}");
    print(fetchedNote.length);
    notifyListeners();
  }

  Future<void> deleteNote(int id) async {
    await isar.writeTxn(() => isar.tasks.delete(id));
    fetchNote();
  }

  Future<void> updateNote(int id, String newTitle, String newDescription , TaskCategory taskCategory) async {
    final existingNote = await isar.tasks.get(id);

    if (existingNote != null) {
      existingNote.title = newTitle;
      existingNote.description = newDescription;
      existingNote.category = taskCategory;
      await isar.writeTxn(() => isar.tasks.put(existingNote));
      await fetchNote();
    }
  }
}



