// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';

class CustomVisibility extends StatelessWidget {
  Widget child;
  bool visible = false;

  CustomVisibility({
    Key? key,
    required this.child,
    this.visible = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Visibility(visible: visible, child: child),
    );
  }
}
