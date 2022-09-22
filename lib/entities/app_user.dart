import 'package:g_auths/auths.dart';
import 'package:g_entities/entities.dart';
import 'root.dart';

part '_generated/app_user._.dart';

@Entity_(fields: [
  F_<String>('fullName'),
  F_<String>('shortName'),
  F_<String>('email')
])
class AppUser extends AppUser$Auto {
  static AppUser? current;
  static Future<void> fetchCurrentUser() async {
    current = await Root.instance.appUser.findById(AuthService.currentUid!);
  }
}

extension AppUser$RefExt on RefField<AppUser> {}

extension AppUser$ListExt on List<AppUser> {}

extension AppUser$FutureExt on Future<AppUser?> {}

extension AppUser$FutureListExt on Future<List<AppUser>> {}

extension AppUser$RemoteListExt on RemoteListField<AppUser> {}
