import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tankdrum_learning/models/instruments/instrument_size_mode.dart';
import 'package:tankdrum_learning/tank_icon_icons.dart';
import 'package:tankdrum_learning/widgets/sound_name_text.dart';

import '../../widgets/note_idx_sign.dart';
import '../sound_note.dart';
import 'instrument.dart';
import 'instrument_note.dart';

class Kalimba extends Instrument {
  @override
  int get sizeMode => InstrumentSizeMode.adaptive;
  @override
  IconData get iconData => TankIcon.instrument_kalimba;

  @override
  BoxDecoration buildDecoration(InstrumentNote note, {Color? color}) {
    return BoxDecoration(
        border: Border.all(),
        color: color ?? const Color.fromARGB(255, 2, 162, 190),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(200),
          bottomRight: Radius.circular(200),
        ));
  }

  @override
  List<InstrumentNote> getNotes(int totalNotes) {
    const maxHeight = 0.4;
    const minHeight = 0.2;
    final noteList = <InstrumentNote>[];
    double widthRate = 1.0;
    double widthHolder = min(1 / 10, 1 / totalNotes);
    double paddingLeft = (1 - widthHolder * totalNotes) / 2;
    double width = widthRate * widthHolder;
    double padding = (widthHolder - width) / 2;
    int halfNotes = (totalNotes / 2 + 1).floor();
    final a = (maxHeight - minHeight) / pow(halfNotes, 2);
    for (int i = 1; i <= totalNotes; i++) {
      double height = a * pow(i, 2) + minHeight;
      if (i > halfNotes) {
        final symetricI = halfNotes - (i - halfNotes) - 1;
        final symetricHeight = noteList[symetricI].height;
        if (symetricI > 0) {
          height = (noteList[symetricI - 1].height + symetricHeight) / 2;
        } else {
          height = noteList[symetricI].height;
        }
      }
      final note = InstrumentNote();
      note.top = 0.55;
      note.left = paddingLeft + padding + (i - 1) * (width + 2 * padding);
      note.width = width;
      note.height = height;
      note.posIdx = i;
      noteList.add(note);
    }
    _sortIdx(noteList);
    return noteList;
  }

  _sortIdx(List<InstrumentNote> noteList) {
    final rootIdx = (noteList.length / 2).floor();
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
    noteList.sort((n1, n2) => n1.posIdx - n2.posIdx);
    int count = 0;
    for (final delta
        in SoundNote.genDeltaListByLength(deltaCycleIdx, noteList.length)) {
      noteList[count++].deltaSoundIdx = delta;
    }
  }

  @override
  List<int> get noteSizeSet {
    return [7, 11, 17, 21];
  }

  static const name = 'Kalimba';

  @override
  String get instrumentName => name;

  @override
  int get defaultNoteCount => 17;

  @override
  List<List<int>> playableNoteSet(Set<int> soundIdxSet) {
    final properIdxSet = SoundNote.findProperSoundSet(
      deltaCycleIdx,
      possibleSizes: [7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21],
      soundIdxSet: soundIdxSet,
      isSingle: true,
    );
    return properIdxSet;
  }

  @override
  Widget buildInnerNote(Rx<InstrumentNote> note, int soundIdx) {
    return Obx(() => note.value.deltaSoundIdx < 0
        ? const SizedBox()
        : FittedBox(
            alignment: Alignment.bottomCenter,
            fit: BoxFit.contain,
            child: Column(children: [
              SoundNameText(
                SoundNote.getNoteName(soundIdx),
                isVertical: true,
                showIdx: false,
              ),
              Container(
                decoration: BoxDecoration(
                    color: const Color.fromARGB(171, 209, 255, 249),
                    borderRadius: BorderRadius.circular(99)),
                child: NoteIdxSign(note.value.posIdx + 1),
              )
            ]),
          ));
  }
}
