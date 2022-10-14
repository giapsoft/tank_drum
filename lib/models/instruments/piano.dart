import 'package:flutter/material.dart';
import 'package:tankdrum_learning/models/instruments/instrument.dart';
import 'package:tankdrum_learning/models/instruments/instrument_note.dart';
import 'package:tankdrum_learning/models/sound_note.dart';
import 'package:tankdrum_learning/tank_icon_icons.dart';

import 'instrument_size_mode.dart';

class Piano extends Instrument {
  @override
  int get sizeMode => InstrumentSizeMode.adaptive;
  @override
  int get defaultNoteCount => 24;
  @override
  bool get isAllowTuning => false;
  @override
  IconData get iconData => TankIcon.instrument_piano;

  @override
  int get startCycleIdx => SoundNote.getNoteIdx('C3');

  @override
  BoxDecoration buildDecoration(InstrumentNote note, {Color? color}) {
    final isNatural = note.posIdx % 12 < 7;
    final rawColor = isNatural ? Colors.white : Colors.black;
    return BoxDecoration(
        border: Border.all(),
        borderRadius: isNatural
            ? null
            : const BorderRadius.only(
                bottomLeft: Radius.circular(200),
                bottomRight: Radius.circular(200),
              ),
        color: color ?? rawColor);
  }

  final naturals = [0, 2, 4, 5, 7, 9, 11];
  @override
  List<InstrumentNote> getNotes(int totalNotes) {
    final noteList = <InstrumentNote>[];
    const naturalWidth = 1 / 7;
    const expandWidth = naturalWidth * 0.8;
    final totalRow = totalNotes / 12;
    final rowHeight = 1 / totalRow;
    final naturalHeight = totalRow == 1 ? 1.0 : 0.95 * rowHeight;
    final totalNaturalHeight = naturalHeight * totalRow;
    final totalGap = 1 - totalNaturalHeight;
    final gap = totalRow == 1 ? 0 : totalGap / (totalRow - 1);
    final expandHeight = 0.6 * naturalHeight;
    int tracingCol = 0;
    final naturalNotes = [];
    final expandNotes = [];

    int naturalCount = 0;
    int expandCound = 11;
    for (int i = 0; i < totalNotes; i++) {
      final note = InstrumentNote();
      int row = i ~/ 12;
      int col = i % 12;
      bool isNatural = naturals.contains(col);
      if (isNatural) {
        note.left = naturalWidth * tracingCol++;
        note.width = naturalWidth;
        note.height = naturalHeight;
        naturalNotes.add(note);
        note.posIdx = 12 * row + naturalCount++;
      } else {
        note.height = expandHeight;
        note.width = expandWidth;
        note.left = naturalWidth * tracingCol - expandWidth / 2;
        expandNotes.add(note);
        note.posIdx = 12 * row + expandCound--;
      }
      if (col == 11) {
        expandCound = 11;
        naturalCount = 0;
      }
      if (tracingCol > 6) {
        tracingCol = 0;
      }
      note.top = row * (naturalHeight + gap);
      noteList.add(note);
    }

    for (int i = 0; i < noteList.length; i++) {
      noteList[i].deltaSoundIdx = i;
    }
    noteList.sort((n1, n2) => n1.posIdx - n2.posIdx);
    return noteList;
  }

  @override
  String get name => 'Piano';

  @override
  List<int> get possibleNoteCount => [12, 24, 36, 48];

  @override
  List<List<int>> playableNoteSet(Set<int> soundIdxSet) {
    final list = soundIdxSet.toList()..sort();
    int getRange(int soundIDx) {
      if (soundIDx > 36) {
        return 3;
      } else if (soundIDx > 24) {
        return 2;
      } else if (soundIDx > 12) {
        return 1;
      }
      return 0;
    }

    List<int> getListInRange(int rangeIdx) {
      return List.generate(12, (index) => 12 * rangeIdx + index);
    }

    final from = getRange(list.first);
    final to = getRange(list.last);
    final tracingList = <int>[];
    for (int i = from; i <= to; i++) {
      tracingList.addAll(getListInRange(i));
    }
    return [tracingList];
  }
}
