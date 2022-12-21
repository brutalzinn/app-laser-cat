import 'package:get_storage/get_storage.dart';

class SettingsPref {
  static get _settingsPref => () => GetStorage('SettingsPref');
  String socketIp = ReadWriteValue('socketIp', "localhost", _settingsPref).val;
  int socketPort = ReadWriteValue('socketPort', 7777, _settingsPref).val;
  int velocity = ReadWriteValue('velocity', 15, _settingsPref).val;
  int deliveryDelay = ReadWriteValue('deliveryDelay', 1, _settingsPref).val;
  int timeout = ReadWriteValue('timeout', 3, _settingsPref).val;
}
