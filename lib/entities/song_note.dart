import 'package:g_entities/entities.dart';
import 'package:g_utils/utils.dart';

part '_generated/song_note._.dart';

@Entity_(fields: [
  F_<int>('duration'),
  F_<int>('startPoint'),
  F_<String>('name'),
])
class SongNote extends SongNote$Auto {
  static SongNote? parseCsv(String e) {
    final parts = e.split('\t');
    if (parts.length > 3) {
      if (!parts[0].startsWith('Name')) {
        final vocal = parts[0].startsWith('t:') ? parts[0].split('t:')[1] : '';
        final start = DateTimeUt.parseMillisecond(parts[1]);
        final duration = DateTimeUt.parseMillisecond(parts[2]);
        return SongNote()
          ..set(duration: duration, startPoint: start, name: vocal);
      }
    }
    return null;
  }
}

extension SongNote$RemoteListExt on RemoteListField<SongNote> {}

extension SongNote$RefExt on RefField<SongNote> {}

extension SongNote$ListExt on List<SongNote> {}

extension SongNote$FutureExt on Future<SongNote?> {}

extension SongNote$FutureListExt on Future<List<SongNote>> {}
