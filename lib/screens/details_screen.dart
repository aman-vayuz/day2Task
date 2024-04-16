import 'package:flutter/material.dart';
import 'package:vayuz_todo/note_modal/todo_modal.dart';

class DetailsScreen extends StatelessWidget {
  final String title;
  final String? description;
  final TaskCategory completionDay;

  const DetailsScreen(
      {super.key,
      required this.title,
      this.description,
      required this.completionDay});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              child: Text(
                'Completion Day: ${whichDay(completionDay)}',
                style: const TextStyle(fontSize: 16 ),textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Title: $title',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Description: ${description ?? 'No description provided'}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

String whichDay(TaskCategory category) {
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
