import 'package:g_entities/entities.dart';
import 'song.dart';
import 'sys_config.dart';
import 'app_user.dart';

part '_generated/root._.dart';

@Entity_(fields: [
  E_<AppUser>.remoteList('app_user'),
  E_<SysConfig>.remoteList('sys_config'),
  E_<Song>.remoteList('song'),
])
class Root extends Root$Auto {
  static final instance = Root();
}

extension Root$RefExt on RefField<Root> {}

extension Root$ListExt on List<Root> {}

extension Root$FutureExt on Future<Root?> {}

extension Root$FutureListExt on Future<List<Root>> {}

extension Root$RemoteListExt on RemoteListField<Root> {}
