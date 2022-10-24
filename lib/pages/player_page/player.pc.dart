part of 'player.page.dart';

class _PlayerPc extends _Player$Ctrl {
  @override
  postConstruct() {
    state.gesture$.listen((p0) {
      print(p0);
    });
  }

  List<Song> songs = [];

  Map<String, Song> songMap = {};
  addSong(Song song) {
    songMap[song.id] = song;
  }

  clearSong() {
    songMap.clear();
  }

  bool hasSong(Song song) {
    return songMap[song.id] != null;
  }

  get childrenUi => {
        'config': children.config.ui,
        'songList': children.songList.ui,
        'play': children.play.ui,
      };
  Widget? get body => childrenUi[state.body];
  bool isViewingPlayer() {
    return state.body == 'play';
  }

  hitViewSongList() {
    state.body = 'songList';
  }

  hitViewConfig() {
    state.body = 'config';
  }

  hitViewSideMenu() {}
}
