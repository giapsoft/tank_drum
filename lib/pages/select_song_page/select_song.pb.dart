part of 'select_song.page.dart';

@Page_(skins: [MenuSkin], state: [SF_<List<String>>(name: 'idList')])
class SelectSongBuilder extends SelectSong$Builder {
  @override
  String get title => 'Select Song';

  @override
  List<Widget> get actions => [
        IconButton(onPressed: ctrl.addSong, icon: const Icon(Icons.add)),
      ];
  @override
  Widget build() {
    return Obx(() => ListView(
          children: state.idList.map((e) => _SongTileUb(ctrl, e).ui).toList(),
        ));
  }
}
