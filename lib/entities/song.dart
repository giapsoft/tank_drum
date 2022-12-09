import 'package:g_entities/entities.dart';
import 'song_note.dart';

part '_generated/song._.dart';

@Entity_(fields: [
  F_<String>('name'),
  E_<SongNote>.list('songNotes'),
])
class Song extends Song$Auto {}

extension Song$RemoteListExt on RemoteListField<Song> {}

extension Song$RefExt on RefField<Song> {}

extension Song$ListExt on List<Song> {}

extension Song$FutureExt on Future<Song?> {}

extension Song$FutureListExt on Future<List<Song>> {}
