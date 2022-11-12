part of '../../player.page.dart';

class _InstrumentUc extends _Instrument$Ctrl {
  Instrument get instrument => parent.ctrl.instrument;
  _Play$State get playState => parent.state;
  double top = 0;
  double left = 0;
  final noteUbs = <_InstrumentNoteUb>[];
  List<_InstrumentNoteUb> get currentUbs => playState.instrumentNotes.isEmpty
      ? []
      : noteUbs.sublist(0, playState.instrumentNotes.length);

  @override
  postConstruct() {
    for (int i = 0; i < 48; i++) {
      noteUbs.add(_InstrumentNoteUb(
        this,
        onTouchPlay: (noteUb) {
          SoundSet.play(noteUb.currentSoundIdx);
          parent.ctrl.touchIdx(noteUb.currentSoundIdx);
        },
        onHold: (noteUb) {
          SoundSet.play(noteUb.currentSoundIdx, forceAsync: true);
        },
      ));
    }
    parent.ctrl.setInstrumentName(TankDrum.name);
  }

  setInstrumentNotes(List<InstrumentNote> notes) {
    for (int i = 0; i < noteUbs.length; i++) {
      if (i < notes.length) {
        noteUbs[i].ctrl.updateNote(notes[i]);
      } else {
        noteUbs[i].ctrl.updateNote();
      }
    }
    resetNoteStatus();
  }

  _InstrumentNoteUb getNoteBySoundIdx(int soundIdx) {
    return noteUbs
        .where((element) =>
            element.state.note.deltaSoundIdx >= 0 &&
            element.currentSoundIdx == soundIdx)
        .first;
  }

  _noteAction(List<int> soundIdxList, Function(_InstrumentNoteUb) noteAction) {
    for (var idx in soundIdxList) {
      noteAction(getNoteBySoundIdx(idx));
    }
  }

  trigger(List<int> soundIxList) {
    _noteAction(soundIxList, (note) => note.ctrl.triggerTut());
  }

  active(List<int>? soundIdxList) {
    if (soundIdxList == null) return;
    _noteAction(soundIdxList, (note) => note.ctrl.active());
  }

  inactive(List<int>? soundIdxList) {
    if (soundIdxList == null) return;
    _noteAction(soundIdxList, (note) => note.ctrl.inactive());
  }

  queue(List<int>? soundIdxList) {
    if (soundIdxList == null) return;
    _noteAction(soundIdxList, (note) => note.ctrl.queue());
  }

  deque(List<int>? soundIdxList) {
    if (soundIdxList == null) return;
    _noteAction(soundIdxList, (note) => note.ctrl.deque());
  }

  deques(List<List<int>?> soundIdxListGroup) {
    for (var element in soundIdxListGroup) {
      deque(element);
    }
  }

  resetNoteStatus() {
    for (var note in noteUbs) {
      note.ctrl.inactive();
      note.ctrl.deque();
    }
  }

  tuneTo(List<int> sortedIdxList) {
    if (sortedIdxList.isEmpty) {
      playState.tune = 0;
    } else {
      playState.tune = sortedIdxList.first - instrument.startCycleIdx;
    }
    final displayingNotes = noteUbs
        .where((element) => element.width > 0)
        .toList()
      ..sort((n1, n2) =>
          n1.state.note.deltaSoundIdx - n2.state.note.deltaSoundIdx);
    for (int i = 0; i < sortedIdxList.length; i++) {
      displayingNotes[i].tuneTo(sortedIdxList[i]);
    }
  }

  resetTune() {
    playState.tune = 0;
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
