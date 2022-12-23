import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingsPref extends GetxService {
  static String storageName = 'settingsPref';
  ReadWriteValue<int> socketPort =
      7777.val('socketPort', getBox: () => GetStorage(storageName));
  ReadWriteValue<String> socketIp =
      "localhost".val('socketIp', getBox: () => GetStorage(storageName));
  ReadWriteValue<double> velocity =
      15.0.val('velocity', getBox: () => GetStorage(storageName));
  ReadWriteValue<int> deliveryDelay =
      1.val('deliveryDelay', getBox: () => GetStorage(storageName));
  ReadWriteValue<int> timeout =
      3.val('timeout', getBox: () => GetStorage(storageName));

  ReadWriteValue<int> autoReconnectInterval =
      5.val('autoReconnectInterval', getBox: () => GetStorage(storageName));

  ReadWriteValue<int> autoReconnectAttempts =
      5.val('autoReconnectAttempts', getBox: () => GetStorage(storageName));

  ReadWriteValue<bool> autoReconnect =
      true.val('autoReconnect', getBox: () => GetStorage(storageName));

  Future<SettingsPref> init() async {
    await GetStorage.init(storageName);
    return this;
  }
}
