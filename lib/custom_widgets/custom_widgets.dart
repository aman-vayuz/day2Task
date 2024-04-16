import 'package:flutter/material.dart';

class AppBarTitle extends StatelessWidget {
  final String titleText;

  const AppBarTitle({super.key, required this.titleText});

  @override
  Widget build(BuildContext context) {
    return Text(
      titleText,
      style: const TextStyle(
          color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
    );
  }
}
