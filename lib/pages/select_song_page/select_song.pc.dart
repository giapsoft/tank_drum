part of 'select_song.page.dart';

class _SelectSongPc extends _SelectSong$Ctrl {
  final perfectSongList = Root().perfectSong;

  @override
  postConstruct() async {
    state.idList = await perfectSongList.currentIdList();
  }

  next() async {
    state.idList = await perfectSongList.nextIdList();
  }

  prev() async {
    state.idList = await perfectSongList.prevIdList();
  }

  addSong() {}
}
