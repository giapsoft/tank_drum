part of '../player.page.dart';

@Ui_(state: [
  SF_<bool>(name: 'isPlaying'),
  SF_<bool>(name: 'isAutoSound'),
  SF_<bool>(name: 'isSelfMode'),
  SF_<int>(name: 'bpm'),
  SF_<String>(name: 'currentSong'),
  SF_<String>(name: 'currentSoundSet', init: 'Kalimba'),
  SF_<int>(name: 'tune'),
  SF_<String>(name: 'instrumentName', init: 'Kalimba'),
  SF_<int>(name: 'noteCount'),
])
class _PlayUb extends _Play$Ub {
  @override
  Widget build() {
    return OrientationBuilder(
      builder: ((context, orientation) {
        return SafeArea(
          child: LayoutBuilder(builder: (_, layoutConstraints) {
            ctrl.setWrapper(layoutConstraints, MediaQuery.of(context).padding);
            return SizedBox(
              width: Get.width,
              height: Get.height,
              child: GestureDetector(
                onPanStart: ctrl.startDrag,
                onPanUpdate: ctrl.onDrag,
                child: Obx(
                  () => Stack(
                    children: [
                      Container(
                        width: Get.width,
                        height: Get.height,
                        decoration: const BoxDecoration(
                          color: Colors.orangeAccent,
                        ),
                      ),
                      ...buildNotes(),
                      ctrl.barWrap([
                        buildSelectSong(),
                        buildSelectSoundSet(),
                        buildSelectInstrument(),
                        ...buildSelectNoteStyle(),
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
                      ]),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }

  List<Widget> buildNotes() {
    final result = <Widget>[];
    final list = ctrl.noteBuilders;
    for (int i = 0; i < state.noteCount; i++) {
      result.add(list[i].ui);
    }
    return result;
  }

  List<Widget> buildSelectNoteStyle() {
    return [
      IconButton(
          onPressed: ctrl.prevNoteCount, icon: const Icon(Icons.arrow_back)),
      Text(ctrl.instrument.noteList.length.toString()),
      IconButton(
          onPressed: ctrl.nextNoteCount, icon: const Icon(Icons.navigate_next)),
    ];
  }

  Widget buildSelectInstrument() {
    return Obx(() => DropdownButton<String>(
        value: state.instrumentName,
        items: Instrument.allInstruments.keys
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (instrumentName) {
          if (instrumentName != null) {
            state.instrumentName = instrumentName;
          }
        }));
  }

  Widget buildSelectSoundSet() {
    return FittedBox(
      fit: BoxFit.contain,
      child: Obx(() => DropdownButton<String>(
          key: const Key('soundSet'),
          value: state.currentSoundSet,
          items: SoundSet.allSet.keys
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (soundSet) {
            if (soundSet != null) {
              state.currentSoundSet = soundSet;
              SoundSet.current = SoundSet.allSet[soundSet]!;
            }
          })),
    );
  }

  Widget buildSelectSong() {
    return FittedBox(
      fit: BoxFit.contain,
      child: Obx(() => DropdownButton<String>(
          value: state.currentSong,
          items: ctrl.songs.keys
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (songName) {
            if (songName != null) {
              state.currentSong = songName;
            }
          })),
    );
  }
}
