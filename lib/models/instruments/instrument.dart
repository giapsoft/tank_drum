import '../sound_note.dart';
import '../sound_set.dart';
import 'free_grid.dart';
import 'instrument_note.dart';
import 'kalimba.dart';
import 'tank_drum.dart';

abstract class Instrument {
  static const kalimba = 'Kalimba';
  static const tankDrum = 'Tank Drum';
  static const freeGrid = 'Free Grid';

  bool get isKalimba => name == kalimba;
  bool get isTankDrum => name == tankDrum;
  bool get isFreeGrid => name == freeGrid;

  Instrument() {
    _prepareNotes(defaultNoteCount);
  }

  static final allInstruments = {
    kalimba: Kalimba(),
    tankDrum: TankDrum(),
    freeGrid: FreeGrid()
  };
  static Instrument getInstrument(String name) => allInstruments[name]!;

  int get defaultNoteCount;

  reset() {
    if (noteList.length != defaultNoteCount) {
      setPositionNotes(defaultNoteCount);
      resizePosition();
    }
    resetTune();
  }

  String get name;
  InstrumentNote wrapper = InstrumentNote(posIdx: -1);
  setWrapper(InstrumentNote note) {
    wrapper = note;
    for (var element in noteList) {
      element.insets = wrapper.insets;
    }
    resizePosition();
  }

  final List<InstrumentNote> noteList = [];

  int customTune = 0;
  SoundSet get defaultSoundSet;

  List<int> get possibleNoteCount;
  int get defaultTune => 0;
  int get baseSoundIdx => startCycleIdx + defaultTune + customTune;
  int get startCycleIdx => SoundNote.getStartIdxOfCycle(deltaCycleIdx);
  tuneTo(int targetIdx) {
    customTune = targetIdx - defaultTune - startCycleIdx;
  }

  increaseTune() {
    if (noteList
            .indexWhere((note) => !SoundNote.canIncreaseTune(note.notePitch)) >
        -1) {
      return;
    }
    customTune = SoundNote.increaseTune(customTune);
  }

  decreaseTune() {
    if (noteList
            .indexWhere((note) => SoundNote.canDecreaseTune(note.notePitch)) >
        -1) {
      return;
    }
    customTune = SoundNote.decreaseTune(customTune);
  }

  resetTune() {
    customTune = 0;
    for (var note in noteList) {
      note.resetPitch();
    }
  }

  sortIdx() {
    final rootIdx = (noteList.length / 2).floor();
    noteList[rootIdx].deltaSoundIdx = 0;
    int lastPositive = 0;
    int lastNegative = 0;
    bool isNegative = true;
    int posIdx = 1;
    noteList[rootIdx].posIdx = 0;
    int idx;
    for (int i = 1; i < noteList.length; i++) {
      if (isNegative) {
        lastNegative--;
        idx = rootIdx + lastNegative;
      } else {
        lastPositive++;
        idx = rootIdx + lastPositive;
      }
      noteList[idx].posIdx = posIdx;
      // prepare for next loop
      isNegative = !isNegative;
      posIdx++;
    }
    fillDentaIdx();
  }

  int get deltaCycleIdx => 0;

  fillDentaIdx() {
    final noteByPosIdx = [...noteList];
    noteByPosIdx.sort((n1, n2) => n1.posIdx - n2.posIdx);
    int count = 0;
    int startIdx = deltaCycleIdx + 1;
    for (final delta
        in SoundNote.genDeltaListByLength(deltaCycleIdx, noteByPosIdx.length)) {
      noteByPosIdx[count].deltaSoundIdx = delta;
      noteByPosIdx[count++].pitchIdx = startIdx++;
    }
  }

  setPositionNotes(int totalNotes) {
    if (noteList.length == totalNotes) {
      if (wrapper.width > 1) {
        resizePosition();
      }
      sortIdx();
      return;
    }
    noteList.clear();
    for (final p in possibleNoteCount) {
      if (p >= totalNotes) {
        for (int i = 0; i < p; i++) {
          noteList.add(InstrumentNote(instrument: this, posIdx: i));
        }
        if (wrapper.width > 1) {
          resizePosition();
        }
        sortIdx();
        break;
      }
    }
  }

  resizePosition() {
    doResizePosition();
  }

  doResizePosition();
  _prepareNotes(int totalNotes) {
    setPositionNotes(totalNotes);
    resetTune();
  }

  bool prepareSounds(Set<int> soundIdxSet) {
    if (!_containsSounds(soundIdxSet)) {
      resetTune();
      if (!_containsSounds(soundIdxSet)) {
        final properNotes = SoundNote.findProperSoundSet(
            deltaCycleIdx, soundIdxSet, noteList.length);
        if (properNotes.length != noteList.length) {
          if (!possibleNoteCount.contains(properNotes.length)) {
            return false;
          }
          _prepareNotes(properNotes.length);
        }
        tuneTo(properNotes[0]);
        final listByDelta = [...noteList]
          ..sort((n1, n2) => n1.deltaSoundIdx - n2.deltaSoundIdx);
        for (int i = 0; i < listByDelta.length; i++) {
          listByDelta[i].tuneTo(properNotes[i]);
        }
      }
    }
    return true;
  }

  bool _containsSounds(Set<int> soundIdxSet) {
    final currentSoundIdxList = noteList.map((e) => e.currentSoundIdx).toList();
    return soundIdxSet.isEmpty ||
        soundIdxSet.firstWhere(
                (soundIdx) => !currentSoundIdxList.contains(soundIdx),
                orElse: () => -1) <
            0;
  }

  bool isAbleToPlay(Set<int> soundIdxSet) {
    return possibleNoteCount.last >=
        SoundNote.findProperSoundSet(deltaCycleIdx, soundIdxSet, 0).length;
  }

  static Instrument findInstrumentCanPlay(Set<int> soundIdxSet) {
    return allInstruments.values.firstWhere((i) => i.isAbleToPlay(soundIdxSet));
  }

  int nextNoteCount() {
    if (noteList.length < possibleNoteCount.last) {
      return possibleNoteCount[possibleNoteCount.indexOf(noteList.length) + 1];
    } else {
      return possibleNoteCount.first;
    }
  }

  int prevNoteCount() {
    if (noteList.length > possibleNoteCount.first) {
      return possibleNoteCount[possibleNoteCount.indexOf(noteList.length) - 1];
    } else {
      return possibleNoteCount.last;
    }
  }
}
