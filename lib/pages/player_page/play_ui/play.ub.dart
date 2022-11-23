part of '../player.page.dart';

@Ui_(state: [
  SF_<PlayMode>(name: 'playMode'),
  SF_<String>(name: 'soundSetName', init: 'Kalimba'),
  SF_<List<int>>(name: 'noteSizeSet'),
  SF_<String>(name: 'instrumentName', init: 'Tank Drum'),
  SF_<List<SongSentence>>(name: 'sentences'),
  SF_<List<String>>(name: 'playableInstruments'),
  SF_<List<List<int>>>(name: 'playableNoteSet'),
  SF_<bool>(name: 'isPlaying'),
  SF_<int>(name: 'bpm', init: 170),
  SF_<bool>(name: 'isRepeat'),
  SF_<List<InstrumentNote>>(name: 'instrumentNotes'),
  SF_<int>(name: 'tune'),
  SF_<bool>(name: 'isSingleMode'),
  SF_<bool>(name: 'isGameMode'),
  SF_<String>(name: 'songName'),
])
class _PlayUb extends _Play$Ub {
  double barWidth = 0.0;
  double width = 0.0;
  double height = 0.0;
  bool get isPortrait => height > width;
  @override
  Widget build() {
    return Obx(
        () => state.isGameMode ? children.game.ui : buildTrainingPlayer());
  }

  Widget buildTrainingPlayer() {
    return LayoutBuilder(builder: (context, constraints) {
      width = constraints.maxWidth;
      height = constraints.maxHeight;
      barWidth = min(width, height) / 8;

      return SizedBox(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        child: Stack(
          children: [
            Positioned(
                top: 0,
                width: isPortrait ? width : barWidth,
                left: 0,
                height: isPortrait ? barWidth : height,
                child: Wrap(children: buildMenu())),
            Positioned(
                top: isPortrait ? barWidth : 0,
                left: isPortrait ? 0 : barWidth,
                width: isPortrait ? width : width - barWidth,
                height: isPortrait ? height - barWidth : height,
                child: children.instrument.ui),
          ],
        ),
      );
    });
  }

  double get dialogWidth => width * 0.8;
  double get dialogHeight => height * 0.8;

  buildDialog(Widget Function() wg) {
    return Get.dialog(
        OrientationBuilder(
            builder: ((context, orientation) => Center(
                  child: Material(
                    child: SizedBox(
                      width: dialogWidth,
                      height: dialogHeight,
                      child: wg(),
                    ),
                  ),
                ))),
        useSafeArea: true);
  }

  Widget buildButton(Widget wg, {padding = 4.0}) {
    return SizedBox(
      width: barWidth,
      height: barWidth,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: FittedBox(
          child: wg,
        ),
      ),
    );
  }

  List<Widget> buildMenu() {
    return [
      buildInstrumentButton(),
      buildSoundSetButton(),
      buildPlayModeButton(),
      buildGameModeButton(),
      buildSimpleModeButton(),
    ];
  }

  buildSimpleModeButton() {
    return buildButton(Obx(() => IconButton(
        onPressed: () {
          state.isSingleMode = !state.isSingleMode;
        },
        icon: state.isSingleMode
            ? const Icon(Icons.single_bed)
            : const Icon(Icons.multiline_chart))));
  }

  buildGameModeButton() {
    return Obx(() => state.sentences.isEmpty
        ? const SizedBox()
        : buildButton(IconButton(
            onPressed: () {
              state.isGameMode = true;
            },
            icon: const Icon(Icons.play_circle))));
  }

  buildPlayModeButton() {
    return buildButton(Obx(() => IconButton(
        onPressed: () {
          buildDialog(() => ListView(
                children: ctrl.songs.keys.map((name) {
                  return ListTile(
                    title: Text(name),
                    onTap: () {
                      ctrl.setSong(name);
                      Get.back();
                    },
                  );
                }).toList(),
              ));
        },
        icon: Icon(state.playMode.iconData))));
  }

  Widget buildSoundSetButton() {
    return buildButton(
        Obx(() => IconButton(
              iconSize: 100,
              onPressed: () {
                buildDialog(() => ListView(
                      children: SoundSet.allSet.values.map((e) {
                        return ListTile(
                          leading:
                              Icon(color: Colors.black, size: 32, e.iconData),
                          title: Text(e.name),
                          onTap: () {
                            state.soundSetName = e.name;
                            SoundSet.current = SoundSet.getSet(e.name);
                            SoundSet.loadCurrentSet();
                            Get.back();
                          },
                        );
                      }).toList(),
                    ));
              },
              icon: Icon(ctrl.soundSet.iconData),
            )),
        padding: 0.0);
  }

  Widget buildInstrumentButton() {
    Widget buildInstrument(String name, IconData icon) {
      final disabled = !ctrl.hasInstrument(name);
      return Obx(() => TextButton(
            style: ButtonStyle(
                foregroundColor: MaterialStateColor.resolveWith(
                    (states) => name == state.instrumentName
                        ? Colors.pink
                        : disabled
                            ? Colors.grey
                            : Colors.black)),
            onPressed: disabled
                ? null
                : () {
                    ctrl.setInstrumentName(name);
                    if (state.sentences.isNotEmpty &&
                        state.playableNoteSet.length <= 1) {
                      Get.back();
                    }
                  },
            child: Row(
              children: [
                Icon(icon),
                const SizedBox(
                  width: 8.0,
                ),
                Text(name)
              ],
            ),
          ));
    }

    buildInstrumentDialog() {
      return SizedBox(
        width: dialogWidth / 2,
        height: dialogHeight,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildInstrument(Kalimba.name, TankIcon.instrument_kalimba),
              buildInstrument(Piano.name, TankIcon.instrument_piano),
              buildInstrument(TankDrum.name, TankIcon.instrument_tank_drum)
            ]),
      );
    }

    buildNoteCountDialog() {
      return Obx(
        () => SizedBox(
            width: isPortrait ? dialogWidth / 2 : dialogWidth / 3,
            height: dialogHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: ctrl.instrument.noteSizeSet.map((e) {
                      final disabled = !ctrl.hasNoteSetSize(e);
                      return FittedBox(
                          child: TextButton(
                        style: ButtonStyle(foregroundColor:
                            MaterialStateColor.resolveWith((states) {
                          return e == state.instrumentNotes.length
                              ? Colors.pink
                              : disabled
                                  ? Colors.grey
                                  : Colors.black;
                        })),
                        onPressed: disabled
                            ? null
                            : () {
                                ctrl.setInstrumentNotes(
                                    ctrl.instrument.getNotes(e));
                                Get.back();
                              },
                        child: Row(children: [
                          const Icon(Icons.music_note),
                          Text(e.toString())
                        ]),
                      ));
                    }).toList()),
              ],
            )),
      );
    }

    return buildButton(
        Obx(() => IconButton(
            iconSize: 100,
            onPressed: () {
              buildDialog(() => Row(
                    children: [
                      buildInstrumentDialog(),
                      buildNoteCountDialog(),
                    ],
                  ));
            },
            icon:
                Icon(Instrument.getInstrument(state.instrumentName).iconData))),
        padding: 4.0);
  }
}
