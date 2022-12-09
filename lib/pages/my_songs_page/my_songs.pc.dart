part of 'my_songs.page.dart';

class _MySongsPc extends _MySongs$Ctrl {
  final perfectSongList = Root().perfectSong;
  addSong() async {
    final song = await perfectSongList.add();
    children.songDetails.state.song = song;
    state.tabIdx = 1;
  }

  viewList() {
    state.tabIdx = 0;
  }

  deleteAllSong() async {
    await Root().perfectSong.deleteAll();
  }
}
