import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import 'package:vayuz_todo/custom_widgets/custom_widgets.dart';
import 'package:vayuz_todo/note_modal/todo_modal.dart';
import 'package:vayuz_todo/screens/add_new_todo.dart';
import 'package:vayuz_todo/screens/details_screen.dart';
import 'package:vayuz_todo/screens/edit_task.dart';

import '../note_modal/todo_db.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  TodoDbProvider? todoDbProvider;

  @override
  void initState() {
    super.initState();
    todoDbProvider = Provider.of(context, listen: false);
    initTodoDB();
  }

  TaskCategory selectedCategory = TaskCategory.Today;

  Future<void> initTodoDB() async {
    await todoDbProvider?.initialise();
    todoDbProvider?.fetchNote();
  }

  @override
  Widget build(BuildContext context) {
    todoDbProvider = context.watch<TodoDbProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(titleText: 'TODO'),
      ),
      body: SafeArea(
        child: _buildTaskList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const AddToDo()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskList() {
    final tasks = todoDbProvider?.currentNote
        .where((task) => task.category == selectedCategory)
        .toList();

    if (tasks!.isEmpty) {
      return const Center(
        child: Text('No tasks. Add a new task!'),
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 10,),
            DropdownButton(
                value: selectedCategory,
                items: TaskCategory.values.map((category) {
                  return DropdownMenuItem<TaskCategory>(
                    value: category,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    selectedCategory = value;
                  });
                }),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DetailsScreen(
                      title: tasks[index].title,
                      description: tasks[index].description,
                      completionDay: tasks[index].category,
                    ),
                  ));
                },
                child: Card(
                  color: Colors.yellow[200],
                  margin: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text(task.title),
                          subtitle: Text(
                            task.description ?? 'No description provided',
                            style: TextStyle(
                              color: task.description!.isEmpty
                                  ? Colors.red
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EditToDO(
                                        id: task.id,
                                        title: task.title,
                                        category: task.category,
                                        description: task.description,
                                      )));
                            },
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: const Text(
                                            'Are you sure you want to delete??'),
                                        actions: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Cancel')),
                                              ElevatedButton(
                                                  onPressed: () async {
                                                    todoDbProvider
                                                        ?.deleteNote(task.id);
                                                    Navigator.pop(context);
                                                    await todoDbProvider
                                                        ?.fetchNote();
                                                  },
                                                  child: const Text('Delete'))
                                            ],
                                          )
                                        ],
                                      ));
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

String completeDate(TaskCategory category) {
  switch (category) {
    case TaskCategory.Yesterday:
      return 'Yesterday';
    case TaskCategory.Today:
      return 'Today';
    case TaskCategory.Tomorrow:
      return 'Tomorrow';
    default:
      return '';
  }
}
