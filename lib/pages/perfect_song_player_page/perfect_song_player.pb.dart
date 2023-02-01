part of 'perfect_song_player.page.dart';

@Page_(
  skins: [MenuSkin],
  pathParams: ['songId'],
  state: [SF_<String>(name: 'songName')],
)
class PerfectSongPlayerBuilder extends PerfectSongPlayer$Builder {
  @override
  Widget build() {
    return ctrl.song == null
        ? const Text('Cannot find this song!')
        : children.game.ui;
  }
}
