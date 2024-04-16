import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../custom_widgets/custom_widgets.dart';
import '../note_modal/todo_db.dart';
import '../note_modal/todo_modal.dart';

class AddToDo extends StatefulWidget {
  const AddToDo({super.key});

  @override
  State<AddToDo> createState() => _AddToDoState();
}

class _AddToDoState extends State<AddToDo> {
  TodoDbProvider? todoDB;
  TaskCategory selectedCategory = TaskCategory.Today;
  final _titleController = TextEditingController();
  @override
  void initState() {
    super.initState();
    todoDB  = Provider.of(context,listen: false);
  }


  final _descriptionController = TextEditingController();
  void whenAdded() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('ToDo Added'),
      duration: Duration(seconds: 3),
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    todoDB = context.watch<TodoDbProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(
          titleText: 'Add new ToDo',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton(
                    value: selectedCategory,
                    items: TaskCategory.values
                        .map((category) => DropdownMenuItem(
                        value: category, child: Text(category.name)))
                        .toList(),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        selectedCategory = value;
                      });
                    }),
                ElevatedButton(
                  onPressed: () async {
                    if (_titleController
                        .text.isEmpty /* && _titleController.text == ''*/) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text(
                                'Title can not be empty , please enter...'),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    setState(() {

                                    });
                                  },
                                  child: const Text('Try again'))
                            ],
                          ));
                    } else {
                      await todoDB?.addNote(_titleController.text,
                          _descriptionController.text, selectedCategory);
                      _titleController.clear();
                      _descriptionController.clear();
                      whenAdded();
                    }
                  },
                  child: const Text('Add Task'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
