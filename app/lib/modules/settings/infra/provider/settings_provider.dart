import 'package:app_laser_cat/modules/settings/infra/models/settings.dart';
import 'package:get_storage/get_storage.dart';

class SettingsPref {
  static final _settingsPref = () => GetStorage('SettingsPref');
  void saveSettings(Settings settings) {
    ReadWriteValue('velocity', settings.velocity, _settingsPref);
  }

  Settings loadSettings() {
    final velocity = ReadWriteValue('velocity', 25, _settingsPref).val;
    return Settings(velocity: velocity);
  }
}
