part of '../select_song.page.dart';

@Ui_(isSingle: true)
class _SongTileUb extends _SongTile$Ub {
  _SongTileUb(this.songPc, this.songId);
  String songId;
  _SelectSongPc songPc;
  @override
  Widget build() {
    return ctrl.song == null
        ? const SizedBox()
        : ListTile(
            title: Text(ctrl.song!.name.orElse('unnamed')),
            trailing: TextButton(onPressed: ctrl.play, child: Text('play')),
          );
  }
}
