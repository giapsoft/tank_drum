part of '../player.page.dart';

@Ui_(state: [
  SF_<bool>(name: 'isPlaying'),
  SF_<bool>(name: 'isAutoSound'),
  SF_<bool>(name: 'isSelfMode'),
  SF_<int>(name: 'bpm'),
  SF_<String>(name: 'currentSong', init: 'Castle In The Sky'),
])
class _PlayUb extends _Play$Ub {
  @override
  Widget build() {
    return LayoutBuilder(builder: (context, constraint) {
      return SizedBox(
        width: Get.width,
        height: Get.height,
        child: GestureDetector(
          onPanStart: ctrl.startDrag,
          onPanUpdate: ctrl.onDrag,
          child: Stack(
            children: [
              Container(
                width: Get.width,
                height: Get.height,
                decoration: const BoxDecoration(
                  color: Colors.orangeAccent,
                ),
              ),
              Positioned(top: 50, width: 150, child: buildSelectSong()),
              ...ctrl.drumNoteBuilders.map((e) => e.buildTutPath()),
              ...ctrl.drumNoteBuilders
                  .map((e) => e.ctrl.tuts)
                  .expand((e3) => e3)
                  .map((e) => e.ui),
              ...ctrl.drumNoteBuilders.map((e) => Positioned(
                    top: e.ctrl.drumNote.pos.top,
                    left: e.ctrl.drumNote.pos.left,
                    width: e.ctrl.drumNote.pos.size,
                    height: e.ctrl.drumNote.pos.size,
                    child: e.ui,
                  )),
              Positioned(
                top: 20,
                child: Row(
                  children: [
                    Obx(() => IconButton(
                          icon: state.isAutoSound
                              ? const Icon(Icons.volume_up)
                              : const Icon(Icons.volume_off),
                          onPressed: ctrl.touchAutoSound,
                        )),
                    Obx(() => IconButton(
                          icon: state.isPlaying
                              ? const Icon(Icons.pause_circle_outline)
                              : const Icon(Icons.play_circle_outline),
                          onPressed: ctrl.touchPlay,
                        )),
                    Obx(() => IconButton(
                          icon: state.isSelfMode
                              ? const Icon(Icons.waving_hand)
                              : const Icon(Icons.front_hand),
                          onPressed: ctrl.touchSelfMode,
                        )),
                    Bpm(state.bpm$)
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget buildSelectSong() {
    return Obx(() => DropdownButton<String>(
        value: state.currentSong,
        items: ctrl.songs.keys
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: ctrl.changeSong));
  }
}
