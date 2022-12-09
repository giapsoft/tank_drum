part of 'my_songs.page.dart';

@Page_(skins: [
  MenuSkin
], state: [
  SF_<int>(name: 'tabIdx'),
])
class MySongsBuilder extends MySongs$Builder {
  @override
  String get title => 'My Songs';

  @override
  List<Widget> get actions {
    return [
      IconButton(onPressed: ctrl.viewList, icon: const Icon(Icons.list)),
      IconButton(onPressed: ctrl.addSong, icon: const Icon(Icons.add)),
    ];
  }

  @override
  Widget build() {
    return Obx(() =>
        state.tabIdx == 0 ? children.songList.ui : children.songDetails.ui);
  }
}
