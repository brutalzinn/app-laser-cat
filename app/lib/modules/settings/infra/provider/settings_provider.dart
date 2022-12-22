import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingsPref extends GetxService {
  static String storageName = 'settingsPref';
  ReadWriteValue<int> socketPort =
      7777.val('socketPort', getBox: () => GetStorage(storageName));
  ReadWriteValue<String> socketIp =
      "localhost".val('socketIp', getBox: () => GetStorage(storageName));
  ReadWriteValue<int> velocity =
      15.val('velocity', getBox: () => GetStorage(storageName));
  ReadWriteValue<int> deliveryDelay =
      1.val('deliveryDelay', getBox: () => GetStorage(storageName));
  ReadWriteValue<int> timeout =
      3.val('timeout', getBox: () => GetStorage(storageName));
  ReadWriteValue<bool> autoReconnect =
      false.val('autoReconnect', getBox: () => GetStorage(storageName));
}
