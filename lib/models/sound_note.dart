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

  static List<int> genDeltaSoundsCoverRange(
    int cycleIdx, {
    int firstIdx = 0,
    required int lastIdx,
  }) {
    List<int> tracingList = [firstIdx];
    int length = 1;
    while (tracingList.last < lastIdx) {
      tracingList = genDeltaListByLength(cycleIdx, length++, first: firstIdx);
    }
    return tracingList;
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

  static List<List<int>> findProperSoundSet(int deltaIdx,
      {required Set<int> soundIdxSet,
      required List<int> possibleSizes,
      isSingle = false}) {
    final list = soundIdxSet.toList();
    list.sort();
    List<int> notes = [];
    List<List<int>> result = [];

    for (int i = 0; i < 12; i++) {
      notes = genDeltaSoundsCoverRange(deltaIdx,
          firstIdx: list.first - i, lastIdx: list.last);
      if (NumberUt.containsAll(notes, child: list)) {
        break;
      }
    }
    if (notes.isNotEmpty) {
      if (possibleSizes.contains(notes.length)) {
        result.add(notes);
      }

      while (possibleSizes.last > notes.length) {
        int nextSize =
            possibleSizes.firstWhere((element) => element > notes.length);
        notes = genDeltaListByLength(deltaIdx, nextSize, first: notes.first);
        if ((isSingle && result.isEmpty) || !isSingle) {
          result.add(notes);
        }
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
