import 'package:g_utils/utils.dart';

class SoundNote {
  static const _names = [
    'C',
    'C#',
    'D',
    'D#',
    'E',
    'F',
    'F#',
    'G',
    'G#',
    'A',
    'A#',
    'B',
  ];
  static const baseCycleIdx = [36, 38, 40, 41, 43, 45, 47];
  static getStartIdxOfCycle(int cycleMove) {
    final time = cycleMove ~/ 7;
    final step = cycleMove % 7;
    return baseCycleIdx[step] +
        12 * (time + (cycleMove >= 0 ? 0 : 1)) * (cycleMove >= 0 ? 1 : -1);
  }

  static const maxNoteIdx = 12 * 8 - 1; //to B8
  static const minNoteIdx = 0; // from C1
  static const _intervals = [1, 2, 3, 4, 5, 6, 7, 8];
  static const rootDeltaCycle = [2, 2, 1, 2, 2, 2, 1];
  static List<int> getDeltaCycle(int cycleIdx) {
    final result = <int>[];
    final startIdx = cycleIdx % rootDeltaCycle.length;
    result.addAll(rootDeltaCycle.sublist(startIdx));
    result.addAll(rootDeltaCycle.sublist(0, startIdx));
    return result;
  }

  static List<int> getCycle(int cycleIdx, int tune) {
    final deltaCycle = getDeltaCycle(cycleIdx);
    final startIdx = getStartIdxOfCycle(cycleIdx);
    final result = <int>[startIdx + tune];
    for (int i = 1; i < deltaCycle.length; i++) {
      result.add(result[i - 1] + deltaCycle[i - 1]);
    }
    return result;
  }

  static List<int> getNoteSign(int cycleIdx, int tune, int noteIdx) {
    final cycle = getCycle(cycleIdx, tune);
    int count = 0;
    while (noteIdx < cycle.first) {
      noteIdx -= 12 * count--;
    }
    if (count == 0) {
      while (noteIdx > cycle.last) {
        noteIdx -= 12 * count++;
      }
      if (count != 0) {
        count--;
      }
    }

    for (int i = 0; i < cycle.length; i++) {
      if (i == 0) {
        if (noteIdx >= cycle.first && noteIdx < cycle[1]) {
          return [count, i + 1];
        }
      } else if (noteIdx < cycle[i] && noteIdx >= cycle[i - 1]) {
        return [count, i];
      }
    }
    return [0, 0];
  }

  static List<int> genNotesContainsList(
      List<int> deltaCycle, List<int> sortedIdxList, int expectTotal) {
    final result = [sortedIdxList.first];
    Iterator<int> cycleLooper = deltaCycle.iterator;
    int getNextDelta() {
      if (!cycleLooper.moveNext()) {
        cycleLooper = deltaCycle.iterator;
        cycleLooper.moveNext();
      }
      return cycleLooper.current;
    }

    int count = 1;
    int soundIdxCount = 1;
    while (
        soundIdxCount < sortedIdxList.length || result.length < expectTotal) {
      final delta = getNextDelta();
      result.add(result[count - 1] + delta);
      if (soundIdxCount < sortedIdxList.length) {
        final idx = sortedIdxList[soundIdxCount];
        if (result.contains(idx)) {
          soundIdxCount++;
        } else if (result[count] > idx) {
          result[count] = idx;
          soundIdxCount++;
        }
      }

      count++;
    }
    return result;
  }

  static List<int> genDeltaListByLength(int cycleIdx, int length,
      {int? first}) {
    final deltaCycle = getDeltaCycle(cycleIdx);
    final result = [first ?? 0];
    for (int i = 1; i < length; i++) {
      int add = deltaCycle[(i - 1) % deltaCycle.length];
      result.add(result[i - 1] + add);
    }
    return result;
  }

  static List<int> findProperSoundSet(
      int deltaCycleMove, Set<int> soundIdxSet, int expectCount) {
    final deltaCycle = getDeltaCycle(deltaCycleMove);
    final list = soundIdxSet.toList();
    list.sort();
    int minDiffSize = soundIdxSet.length;
    List<int> notes = [];
    List<int> result = [];

    for (int i = 0; i < 12; i++) {
      final listToScan = i == 0 ? [...list] : [list.first - i, ...list];
      int diffSize = 0;
      notes = genNotesContainsList(deltaCycle, listToScan, expectCount);
      final originalList = genDeltaListByLength(deltaCycleMove, notes.length,
          first: listToScan.first);
      diffSize = NumberUt.countNotInList(originalList, notes);
      if (diffSize == 0) {
        return notes;
      }
      if (diffSize < minDiffSize) {
        minDiffSize = diffSize;
        result = [...notes];
      }
    }
    return result;
  }

  static Map<String, int>? _noteNameToIdx;

  static final List<String> _noteNameList = [];
  static Map<String, int> _getAllNames() {
    final result = <String, int>{};
    for (final interval in _intervals) {
      for (final name in _names) {
        _noteNameList.add('$name$interval');
      }
    }
    for (int i = 0; i < _noteNameList.length; i++) {
      result[_noteNameList[i]] = i;
    }
    return result;
  }

  static int getNoteIdx(String noteName) {
    _noteNameToIdx ??= _getAllNames();
    return noteName.isEmpty ? -1 : _noteNameToIdx![noteName]!;
  }

  static String getNoteName(int idx) {
    _noteNameToIdx ??= _getAllNames();
    return idx < 0 ? '' : _noteNameList[idx];
  }

  static int increaseTune(int tune) {
    if (canIncreaseTune(tune)) {
      return tune + 1;
    }
    return tune;
  }

  static int decreaseTune(int tune) {
    if (tune > minNoteIdx) {
      return tune - 1;
    }
    return tune;
  }

  static bool canIncreaseTune(int tune) {
    return tune < maxNoteIdx;
  }

  static bool canDecreaseTune(int tune) {
    return tune > 0;
  }
}
