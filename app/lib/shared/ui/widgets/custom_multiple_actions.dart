// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:app_laser_cat/shared/infra/controllers/options_menu_controller.dart';
import 'package:app_laser_cat/shared/ui/widgets/custom_visibility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:get/get.dart';

class CustomMultipleActions extends StatelessWidget {
  OptionsMenuController controller;
  List<CustomVisibility> children;
  CustomMultipleActions({
    Key? key,
    required this.controller,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.updateList(children);
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.childVisible.value.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = controller.childVisible.value[index];
                    return Container(
                      alignment: Alignment.bottomLeft,
                      child: CustomVisibility(
                          visible: item.visible, child: item.child),
                    );
                  }),
              const SizedBox(width: 8),
              FloatingActionButton(
                onPressed: () {
                  controller.toggleExpanded();
                },
                tooltip: 'Settings',
                child: const Icon(Icons.settings),
              ),
            ]),
      ),
    );
  }
}
