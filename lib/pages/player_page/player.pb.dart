part of 'player.page.dart';

@Page_(state: [
  SF_<String>(name: 'title', init: 'Easy-Drum'),
  SF_<int>(name: 'bpm'),
  SF_<bool>(name: 'isPlaying'),
  SF_<String>(name: 'body', init: 'play'),
  SF_<String>(name: 'gesture')
])
class PlayerBuilder extends Player$Builder {
  @override
  Widget build() {
    return SafeArea(
      child: Scaffold(
        appBar: ctrl.isViewingPlayer()
            ? null
            : AppBar(
                title: Obx(() => Text(state.title)),
                actions: [
                  IconButton(
                    onPressed: ctrl.hitViewSongList,
                    icon: const Icon(Icons.queue_music),
                  ),
                  IconButton(
                    onPressed: ctrl.hitViewConfig,
                    icon: const Icon(Icons.build),
                  )
                ],
              ),
        body: ctrl.body,
      ),
    );
  }
}
