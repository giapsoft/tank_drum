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
    'kishimete': SongLib.kishimete,
    'chanhLongThuongCo': SongLib.chanhLongThuongCo,
    'tuyHongNhan': SongLib.tuyHongNhan,
    'taCoHenVoiThang5': SongLib.taCoHenVoiThang5,
    'namNgoaiGioNay': SongLib.namNgoaiGioNay,
  };

  bool get isFixedSong {
    return [
      'kishimete',
      'chanhLongThuongCo',
      'tuyHongNhan',
      'taCoHenVoiThang5',
      'namNgoaiGioNay'
    ].contains(state.songName);
  }

  setSong(String name) {
    state.songName = name;
    setSentences(songs[name]!);
  }

  @override
  postConstruct() {
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
        children.instrument.ctrl.active(player.currentNote?.soundIdxList);
        children.instrument.ctrl.queue(player.nextNote?.soundIdxList);
      },
      onFinish: () async {
        state.isPlaying = false;
        await Future.delayed(const Duration(seconds: 2));
        children.instrument.ctrl.resetNoteStatus();
        state.sentences = [];
      },
    );

    setInstrumentName(state.instrumentName, refreshSentences: false);
    setSong('taCoHenVoiThang5');
    state.isGameMode = true;
  }

  setSentences(List<SongSentence> sentences) {
    state.sentences = sentences;
    children.instrument.ctrl.resetTune();
    if (isFixedSong || state.sentences.isEmpty) {
      state.playMode = PlayMode.free;
      setInstrumentNotes(instrument.getNotes(instrument.defaultNoteCount));
      return;
    }
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

  updateHelper() {
    if (state.sentences.isEmpty || state.playableNoteSet.isEmpty) return;
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
      setSentences(state.sentences);
    }
  }

  setInstrumentNotes(List<InstrumentNote> notes) {
    state.instrumentNotes = notes;
    children.instrument.ctrl.setInstrumentNotes(notes);
    updateHelper();
  }

  touchNote(_InstrumentNoteUb noteUb) {
    final soundIdx = noteUb.currentSoundIdx;
    if (state.isSingleMode) {
      if (!player.playAllWaiterIfMatchLast(soundIdx)) {
        SoundSet.play(soundIdx);
      }
    } else {
      SoundSet.play(soundIdx);
      player.touchIdx(soundIdx);
    }
  }

  bool hasNoteSetSize(int length) {
    return state.playMode.isFree ||
        state.playableNoteSet.any((e) => e.length == length);
  }

  bool hasInstrument(String name) {
    return state.playMode.isFree || state.playableInstruments.contains(name);
  }
}
