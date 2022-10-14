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
extension SysConfig$RemoteListExt on RemoteListField<SysConfig> {
}
extension SysConfig$RefExt on RefField<SysConfig> {
}
extension SysConfig$ListExt on List<SysConfig> {
}
extension SysConfig$FutureExt on Future<SysConfig?> {
}
extension SysConfig$FutureListExt on Future<List<SysConfig>> {
}