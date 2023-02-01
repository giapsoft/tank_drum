part of 'perfect_song_player.page.dart';

class _PerfectSongPlayerPc extends _PerfectSongPlayer$Ctrl {
  PerfectSong? song;

  @override
  postConstruct() async {
    song = await Root().perfectSong.findById(params.songId);
    await song?.downloadMp3FileIfNotExist();
  }
}
