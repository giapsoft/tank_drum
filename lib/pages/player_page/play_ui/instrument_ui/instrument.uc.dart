part of '../../player.page.dart';

class _InstrumentUc extends _Instrument$Ctrl {
  Instrument? lastInstrument;
  Instrument get instrument =>
      Instrument.getInstrument(parent.state.instrumentName);
  _Play$State get playState => parent.state;
  double top = 0;
  double left = 0;
  final noteUbs = <_InstrumentNoteUb>[];
  List<_InstrumentNoteUb> get currentUbs => playState.instrumentNotes.isEmpty
      ? []
      : noteUbs.sublist(0, playState.instrumentNotes.length);
  final soundIdxToNoteUb = <int, _InstrumentNoteUb>{};

  @override
  postConstruct() {
    for (int i = 0; i < 48; i++) {
      noteUbs.add(_InstrumentNoteUb(this, onTouchPlay: () {
        SoundSet.play(noteUbs[i].currentSoundIdx);
      }));
    }
    playState.instrumentNotes$.listen((notes) {
      for (int i = 0; i < noteUbs.length; i++) {
        if (i < notes.length) {
          noteUbs[i].ctrl.updateNote(notes[i]);
        } else {
          noteUbs[i].ctrl.updateNote();
        }
      }
      lastInstrument = instrument;
    });
  }

  _InstrumentNoteUb getNoteBySoundIdx(int soundIdx) {
    return soundIdxToNoteUb[soundIdx]!;
  }

  _noteAction(List<int> soundIdxList, Function(_InstrumentNoteUb) noteAction) {
    for (var idx in soundIdxList) {
      noteAction(getNoteBySoundIdx(idx));
    }
  }

  trigger(List<int> soundIxList) {
    _noteAction(soundIxList, (note) => note.ctrl.triggerTut());
  }

  active(List<int> soundIdxList) {
    _noteAction(soundIdxList, (note) => note.ctrl.active());
  }

  inactive(List<int> soundIdxList) {
    _noteAction(soundIdxList, (note) => note.ctrl.inactive());
  }

  wait(List<int> soundIdxList) {
    _noteAction(soundIdxList, (note) => note.ctrl.wait());
  }

  unwait(List<int> soundIdxList) {
    _noteAction(soundIdxList, (note) => note.ctrl.unwait());
  }

  inactiveAll() {
    for (var note in noteUbs) {
      note.ctrl.inactive();
    }
  }

  increaseTune() {
    if (currentUbs.indexWhere(
            (note) => !SoundNote.canIncreaseTune(note.currentSoundIdx)) >
        -1) {
      return;
    }
    playState.tune++;
  }

  decreaseTune() {
    if (currentUbs.indexWhere(
            (note) => SoundNote.canDecreaseTune(note.currentSoundIdx)) >
        -1) {
      return;
    }
    playState.tune--;
  }

  resetTune() {
    playState.tune = instrument.startCycleIdx;
    for (var note in currentUbs) {
      note.state.tune = 0;
    }
  }

  void updateSize(BoxConstraints constraints) {
    state.width = constraints.maxWidth;
    state.height = constraints.maxHeight;
  }

  double get halfOverWidth =>
      instrument.isSquare ? max(0, state.width - state.height) / 2 : 0;
  double get halfOverHeight =>
      instrument.isSquare ? max(0, state.height - state.width) / 2 : 0;

  double get adaptWidth =>
      instrument.isSquare ? min(state.width, state.height) : state.width;
  double get adaptHeight =>
      instrument.isSquare ? min(state.width, state.height) : state.height;

  double getTop(double topRate) {
    return halfOverHeight + topRate * adaptHeight;
  }

  double getLeft(double leftRate) {
    return halfOverWidth + leftRate * adaptWidth;
  }

  double getWidth(double widthRate) {
    return widthRate * adaptWidth;
  }

  double getHeight(double heightRate) {
    return heightRate * adaptHeight;
  }
}
