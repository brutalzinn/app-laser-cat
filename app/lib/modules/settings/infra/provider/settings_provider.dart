import 'package:get_storage/get_storage.dart';

class SettingsPref {
  static get _settingsPref => () => GetStorage('SettingsPref');

  String socketIp =
      ReadWriteValue('socketIp', "localhost", _settingsPref) as String;

  int socketPort = ReadWriteValue('socketPort', 7777, _settingsPref) as int;

  int velocity = ReadWriteValue('velocity', 15, _settingsPref) as int;
  int deliveryDelay = ReadWriteValue('deliveryDelay', 1, _settingsPref) as int;

  int timeout = ReadWriteValue('timeout', 3, _settingsPref) as int;
}
