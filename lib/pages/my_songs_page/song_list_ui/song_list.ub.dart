part of '../my_songs.page.dart';

@Ui_(state: [
  SF_<List<PerfectSong>>(name: 'songList'),
  SF_<int>(name: 'currentPage'),
])
class _SongListUb extends _SongList$Ub {
  @override
  Widget build() {
    return Obx(() => ListView(
          children: [
            Text(state.songList.length.toString()),
            ...state.songList.map((e) => ListTile(
                  title: Text(e.name.orElse('unnamed')),
                  trailing: IconButton(
                      onPressed: () => ctrl.editSong(e),
                      icon: Icon(Icons.ads_click)),
                )),
            Row(
              children: [
                IconButton(onPressed: ctrl.prev, icon: Icon(Icons.arrow_left)),
                Obx(() => Text(state.currentPage.toString())),
                IconButton(onPressed: ctrl.next, icon: Icon(Icons.arrow_right))
              ],
            )
          ],
        ));
  }
}
