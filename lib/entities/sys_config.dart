import 'package:g_entities/entities.dart';

part '_generated/sys_config._.dart';

@Entity_(fields: [
  F_<String>('encoded_drums'),
])
class SysConfig extends SysConfig$Auto {
  static late SysConfig instance;
  static loadConfig() async {
    instance = SysConfig();
  }
}
