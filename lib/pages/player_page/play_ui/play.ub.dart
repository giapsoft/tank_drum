part of '../player.page.dart';

@Ui_(state: [
  SF_<bool>(name: 'isPlaying'),
  SF_<bool>(name: 'isAutoSound'),
  SF_<bool>(name: 'isSelfMode'),
  SF_<int>(name: 'bpm'),
  SF_<String>(name: 'currentSong'),
  SF_<List<SongNote>>(name: 'songNotes'),
  SF_<String>(name: 'currentSoundSet', init: 'Kalimba'),
  SF_<String>(name: 'instrumentName', init: 'Kalimba'),
  SF_<int>(name: 'tune'),
  SF_<List<InstrumentNote>>(name: 'notes'),
  SF_<List<int>>(name: 'noteSet'),
  SF_<List<List<int>>>(name: 'playableNoteSet'),
  SF_<int>(name: 'playMode')
])
class _PlayUb extends _Play$Ub {
  Instrument get instrument => Instrument.getInstrument(state.instrumentName);
  @override
  Widget build() {
    return OrientationBuilder(
      builder: ((context, orientation) {
        return SafeArea(child: LayoutBuilder(builder: (context, constraints) {
          return SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: orientation.index == 1 ? buildHorizontal() : buildVertical(),
          );
        }));
      }),
    );
  }

  buildHorizontal() {
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: Wrap(
              children: buildMenu(),
            )),
        Expanded(flex: 11, child: children.instrument.ui)
      ],
    );
  }

  buildVertical() {
    return Column(
      children: [
        Expanded(
            flex: 1,
            child: Wrap(
              children: buildMenu(),
            )),
        Expanded(flex: 7, child: children.instrument.ui)
      ],
    );
  }

  List<Widget> buildMenu() {
    return [
      Obx(() => IconButton(
          onPressed: () {
            state.instrumentName =
                children.instrument.ctrl.instrument.nextName();
          },
          icon: Icon(instrument.iconData))),
      Obx(() => TextButton(
          onPressed: () {
            if (state.noteSet.isEmpty) {
              return;
            }
            int idx = state.noteSet
                .indexWhere((element) => element == state.notes.length);
            if (idx < state.noteSet.length - 1) {
              idx++;
            } else {
              idx = 0;
            }
            state.notes = instrument.getNotes(state.noteSet[idx]);
          },
          child: Text(state.notes.length.toString())))
    ];
  }
}
