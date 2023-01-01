import 'package:app_laser_cat/modules/records/infra/controller/record_controller.dart';
import 'package:app_laser_cat/shared/infra/services/connector_service.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

abstract class RecordAbstract {
  void showDialog(RecordController recordController);
  abstract RecordController? recordController;
  Future<void> execute(ConnectorService connectorService);
  abstract String title;
  void onSave();
}
