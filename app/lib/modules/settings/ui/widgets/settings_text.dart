// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class SettingsText extends StatelessWidget {
  const SettingsText({
    Key? key,
    required this.label,
    required this.controller,
  }) : super(key: key);
  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label),
        TextField(
          controller: controller,
        ),
      ],
    );
  }
}
