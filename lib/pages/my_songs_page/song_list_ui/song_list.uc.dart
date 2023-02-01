part of '../my_songs.page.dart';

class _SongListUc extends _SongList$Ctrl {
  @override
  onWillBuild() async {
    state.songList = await parent.ctrl.perfectSongList.loadPage();
    state.currentPage = parent.ctrl.perfectSongList.pagination.currentPage;
  }

  prev() async {
    state.songList = await parent.ctrl.perfectSongList.prev();
    state.currentPage = parent.ctrl.perfectSongList.pagination.currentPage;
  }

  next() async {
    state.songList = await parent.ctrl.perfectSongList.next();
    state.currentPage = parent.ctrl.perfectSongList.pagination.currentPage;
  }

  void editSong(PerfectSong song) {
    parent.children.songDetails.state.song = song;
    parent.state.tabIdx = 1;
  }
}
