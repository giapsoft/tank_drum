part of '../player.page.dart';

class _PlayUc extends _Play$Ctrl {
  late SongPlayer player;

  Instrument get instrument => Instrument.getInstrument(state.instrumentName);

  int get barSize => 4;
  double get smallBarSize => 1 / barSize;
  double get largeBarSize => (barSize - 1) / barSize;
  SoundSet get soundSet => SoundSet.getSet(state.soundSetName);

  @override
  close() {
    PoolPlayer.realeaseAllSounds();
  }

  final songs = {
    '': <SongSentence>[],
    'Castle In The Sky': SongLib.castleInTheSky,
    'Endless Love': SongLib.endlessLove,
    'Happy Birth Day': SongLib.happyBirthDay,
    'Proud Of You': SongLib.proudOfYou,
  };

  @override
  postConstruct() {
    state.sentences$.listen((_) {
      final soundIdxList = state.sentences
          .map((e) =>
              e.notes.map((e) => e.soundIdxList).expand((element) => element))
          .expand((element) => element)
          .toSet()
          .toList()
        ..sort();
      final soundIdxSet = soundIdxList.toSet();
      state.isPlaying = false;
      if (state.sentences.isEmpty) {
        state.playMode = PlayMode.free;
        state.instrumentNotes =
            instrument.getNotes(instrument.defaultNoteCount);
      } else {
        state.playMode = PlayMode.training;
        state.playableInstruments = Instrument.playableInstruments(soundIdxSet);
        if (state.playableInstruments.contains(state.instrumentName)) {
          state.instrumentName = state.playableInstruments.first;
        }
        state.playableNoteSet = instrument.playableNoteSet(soundIdxSet);

        final notes = state.playableNoteSet.firstWhere(
            (element) => element.length == state.instrumentNotes.length,
            orElse: () => state.playableNoteSet.first);
        state.instrumentNotes = instrument.getNotes(notes.length);
      }
    });

    state.instrumentName$.listen((p0) {
      state.possibleNoteCount = instrument.possibleNoteCount;
      state.sentences$.refresh();
    });

    player = SongPlayer(
      isSilence: true,
      onFinish: () async {
        state.isPlaying = false;
        await Future.delayed(const Duration(seconds: 2));
        children.instrument.ctrl.inactiveAll();
      },
    );
  }

  onDrag(DragUpdateDetails details) {
    drag(details.globalPosition);
  }

  startDrag(DragStartDetails details) {
    drag(details.globalPosition);
  }

  drag(Offset offset) async {
    for (var note in children.instrument.ctrl.currentUbs) {
      note.ctrl.swipe(offset);
    }
  }
}
