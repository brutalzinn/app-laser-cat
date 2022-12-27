import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'shared/infra/routes/routes.dart';
import 'shared/ui/widgets/custom_floating_action_button.dart';
import 'shared/ui/widgets/custom_visibility.dart';

class Utils {
  ///Remap like Arduino MAP method to equality with plan cartesian and servo motor angule from 0 to 180.
  static int remapper(double value, double fromStart, double fromEnd,
          double toStart, double toEnd) =>
      ((value - fromStart) * (toEnd - toStart) ~/ (fromEnd - fromStart) +
              toStart)
          .round();

  

  // List<CustomVisibility> get customNavigationOptions {
  //   return children ?? defaultNavigationOptions;
  // }
}
