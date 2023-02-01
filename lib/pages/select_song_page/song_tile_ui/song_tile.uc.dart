part of '../select_song.page.dart';

class _SongTileUc extends _SongTile$Ctrl {
  PerfectSong? song;

  @override
  postConstruct() async {
    song = await builder.songPc.perfectSongList.findById(builder.songId);
  }

  void play() {
    PerfectSongPlayerPage.goOff(songId: song!.id);
  }
}
