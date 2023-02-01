import 'package:g_entities/entities.dart';
import 'package:g_file_storage/storage.dart';
import 'silence_node.dart';

part '_generated/perfect_song._.dart';

@Entity_(fields: [
  F_<String>('name'),
  F_<String>('mp3File'),
  E_<SilenceNode>.list('notes'),
])
class PerfectSong extends PerfectSong$Auto {
  Future<String> get mp3Path =>
      LocalFiles.fullPersistPath('perfectSongs/${mp3File.orElse('')}');

  Future<void> downloadMp3FileIfNotExist() async {
    return NetworkFiles.syncToLocal('perfectSongs/${mp3File.orElse('')}');
  }
}

extension PerfectSong$RemoteListExt on RemoteListField<PerfectSong> {}

extension PerfectSong$RefExt on RefField<PerfectSong> {}

extension PerfectSong$ListExt on List<PerfectSong> {}

extension PerfectSong$FutureExt on Future<PerfectSong?> {}

extension PerfectSong$FutureListExt on Future<List<PerfectSong>> {}
