// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';

typedef JoystickDragDetails = void Function(StickDragDetails foo);

class JoystickWidget extends StatelessWidget {
  final JoystickDragDetails callBack;
  final Function onDragEnd;
  final Widget child;

  const JoystickWidget({
    Key? key,
    required this.callBack,
    required this.child,
    required this.onDragEnd,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return JoystickArea(
        listener: (details) {
          callBack(details);
        },
        onStickDragEnd: onDragEnd,
        mode: JoystickMode.horizontalAndVertical,
        initialJoystickAlignment: Alignment.bottomCenter,
        child: child);
  }
}
