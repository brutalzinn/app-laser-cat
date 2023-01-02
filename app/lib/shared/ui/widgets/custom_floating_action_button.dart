// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:app_laser_cat/app_config.dart';
import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  Icon child;
  final Function() onPressed;
  Function()? onLongPressed;

  String? tooltip;
  String? heroTag;
  CustomFloatingActionButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.onLongPressed,
    this.tooltip,
    this.heroTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: onLongPressed,
      child: FloatingActionButton(
          tooltip: tooltip,
          heroTag: heroTag,
          backgroundColor: AppConfig.primaryColor,
          onPressed: onPressed,
          child: child),
    );
  }
}
