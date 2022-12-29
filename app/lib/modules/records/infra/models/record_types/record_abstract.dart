import 'package:app_laser_cat/modules/records/infra/controller/record_controller.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

abstract class RecordAbstract {
  void showDialog(RecordController recordController);
  void onSave();
}
