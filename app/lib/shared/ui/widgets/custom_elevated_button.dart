// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:app_laser_cat/app_config.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  VoidCallback? onPressed;
  String label;

  CustomElevatedButton({
    Key? key,
    required this.onPressed,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(AppConfig.primaryColor)),
        child: Text(
          label,
          style: TextStyle(color: AppConfig.secondaryColor),
        ));
  }
}
