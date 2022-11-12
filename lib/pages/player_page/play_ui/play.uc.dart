part of '../player.page.dart';

class _PlayUc extends _Play$Ctrl {
  late SongPlayer player;
  Instrument? _instrument;
  Instrument get instrument =>
      _instrument ??= Instrument.getInstrument(state.instrumentName);

  int get barSize => 4;
  double get smallBarSize => 1 / barSize;
  double get largeBarSize => (barSize - 1) / barSize;
  SoundSet get soundSet => SoundSet.getSet(state.soundSetName);

  @override
  close() async {
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
      children.instrument.ctrl.resetTune();
      final soundIdxList = state.sentences
          .map((e) =>
              e.notes.map((e) => e.soundIdxList).expand((element) => element))
          .expand((element) => element)
          .toSet()
          .toList()
        ..sort();
      final soundIdxSet = soundIdxList.toSet();
      state.isPlaying = false;
      player.reset(songSentences: state.sentences);
      if (state.sentences.isEmpty) {
        state.playMode = PlayMode.free;
        setInstrumentNotes(instrument.getNotes(instrument.defaultNoteCount));
      } else {
        state.playMode = PlayMode.training;
        state.playableInstruments = Instrument.playableInstruments(soundIdxSet);
        if (!state.playableInstruments.contains(state.instrumentName)) {
          setInstrumentName(state.playableInstruments.first,
              refreshSentences: false);
        }
        state.playableNoteSet = instrument.playableNoteSet(soundIdxSet);
        final notes = state.playableNoteSet.firstWhere(
            (element) => element.length == state.instrumentNotes.length,
            orElse: () => state.playableNoteSet.first);
        setInstrumentNotes(instrument.getNotes(notes.length));
      }
    });

    player = SongPlayer(
      isSilence: true,
      onTouchedWaiter: (idx) {
        children.instrument.ctrl.getNoteBySoundIdx(idx).ctrl.inactive();
      },
      onNextNote: () {
        children.instrument.ctrl.deques([
          player.prevNote?.soundIdxList,
          player.currentNote?.soundIdxList,
        ]);
        children.instrument.ctrl.inactive(player.prevNote?.soundIdxList);
        children.instrument.ctrl.active(player.currentNote?.soundIdxList);
        children.instrument.ctrl.queue(player.nextNote?.soundIdxList);
      },
      onFinish: () async {
        state.isPlaying = false;
        await Future.delayed(const Duration(seconds: 2));
        children.instrument.ctrl.resetNoteStatus();
      },
    );
  }

  updateHelper() {
    if (state.sentences.isEmpty) return;
    final notes = state.playableNoteSet.firstWhere(
        (element) => element.length == state.instrumentNotes.length,
        orElse: () => state.playableNoteSet.first);
    children.instrument.ctrl.tuneTo(notes);
    children.instrument.ctrl.active(player.currentNote?.soundIdxList);
    children.instrument.ctrl.queue(player.nextNote?.soundIdxList);
  }

  setInstrumentName(String name, {refreshSentences = true}) {
    _instrument = Instrument.getInstrument(name);
    state.instrumentName = name;
    state.noteSizeSet = instrument.noteSizeSet;
    if (refreshSentences) {
      state.sentences$.refresh();
    }
  }

  setInstrumentNotes(List<InstrumentNote> notes) {
    state.instrumentNotes = notes;
    children.instrument.ctrl.setInstrumentNotes(notes);
    updateHelper();
  }

  touchIdx(int soundIdx) {
    player.touchIdx(soundIdx);
  }

  bool hasNoteSetSize(int length) {
    return state.playMode.isFree ||
        state.playableNoteSet.any((e) => e.length == length);
  }

  bool hasInstrument(String name) {
    return state.playMode.isFree || state.playableInstruments.contains(name);
  }
}
