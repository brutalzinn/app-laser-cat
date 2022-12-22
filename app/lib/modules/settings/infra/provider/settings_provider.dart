import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingsPref extends GetxService {
  static get _settingsPref => () => GetStorage('SettingsPref');
  final socketIp = ReadWriteValue('socketIp', "localhost", _settingsPref);
  final socketPort = ReadWriteValue('socketPort', 7777, _settingsPref);
  final velocity = ReadWriteValue('velocity', 15, _settingsPref);
  final deliveryDelay = ReadWriteValue('deliveryDelay', 1, _settingsPref);
  final timeout = ReadWriteValue('timeout', 3, _settingsPref);
}
