import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../custom_widgets/custom_widgets.dart';
import '../note_modal/todo_db.dart';
import '../note_modal/todo_modal.dart';

class EditToDO extends StatefulWidget {
  final int id;
  final String title;
  final String? description;
  final TaskCategory category;

  const EditToDO(
      {super.key,
      required this.id,
      required this.title,
      this.description,
      required this.category});

  @override
  State<EditToDO> createState() => _EditToDOState();
}

class _EditToDOState extends State<EditToDO> {
  TodoDbProvider? todoDB;
  TaskCategory selectedCategory = TaskCategory.Today;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.title;
    _descriptionController.text = widget.description!;
    selectedCategory = widget.category;
    todoDB  = Provider.of(context,listen: false);
  }

  void whenEdited() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Todo Edited'),
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
          titleText: 'Edit todo',
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
            const SizedBox(
              height: 20,
            ),
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
                                      },
                                      child: const Text('Try again'))
                                ],
                              ));
                    } else {
                      await todoDB?.updateNote(widget.id, _titleController.text,
                          _descriptionController.text, selectedCategory);
                      _titleController.clear();
                      _descriptionController.clear();
                      whenEdited();
                    }
                  },
                  child: const Text('Edit'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
