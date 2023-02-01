part of '../my_songs.page.dart';

@Ui_(state: [
  SF_<PerfectSong>(name: 'song'),
  SF_<String>(name: 'mp3FileName'),
  SF_<int>(name: 'totalNotes'),
])
class _SongDetailsUb extends _SongDetails$Ub {
  Widget buildSongManage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ctrl.name.ui(),
        buildPickMp3(),
        buildPickCsv(),
        buildBottomButton(),
      ],
    );
  }

  buildBottomButton() {
    return Row(
      children: [
        IconButton(
            onPressed: ctrl.deleteCurrentSong, icon: const Icon(Icons.delete)),
        IconButton(
            onPressed: ctrl.saveCurrentSong, icon: const Icon(Icons.save)),
      ],
    );
  }

  buildPickMp3() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(() => Text(state.mp3FileName)),
        TextButton(onPressed: ctrl.pickMp3, child: const Text('mp3'))
      ],
    );
  }

  buildPickCsv() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(() => Text('totalNotes: ${state.totalNotes}')),
        TextButton(onPressed: ctrl.pickCsv, child: const Text('csv'))
      ],
    );
  }

  @override
  Widget build() {
    return Obx(
        () => !state.song.isPersisted ? Text('empty') : buildSongManage());
  }
}
