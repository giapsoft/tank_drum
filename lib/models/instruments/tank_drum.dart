import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../tank_icon_icons.dart';
import '../../widgets/note_idx_sign.dart';
import '../sound_note.dart';
import 'instrument.dart';
import 'instrument_note.dart';
import 'instrument_size_mode.dart';

class TankDrum extends Instrument {
  static const name = 'Tank Drum';

  @override
  String get instrumentName => name;

  @override
  int get defaultNoteCount => 15;

  @override
  int get deltaCycleIdx => -5;

  int _startCycleIdx = 0;

  @override
  int get startCycleIdx => _startCycleIdx;

  @override
  List<int> get noteSizeSet {
    return [8, 11, 13, 14, 15];
  }

  @override
  List<InstrumentNote> getNotes(int totalNotes) {
    final noteList = <InstrumentNote>[];
    addNote(int deltaIdx, String deltaName, double top, double left,
        double width, double height, double angle) {
      noteList.add(InstrumentNote(
        deltaSoundIdx: deltaIdx,
        deltaName: deltaName,
        top: top,
        left: left,
        width: width,
        height: height,
        angle: angle,
      ));
    }

    switch (totalNotes) {
      case 15:
        addNote(0, '3D', 0.33406, 0.34087, 0.30882, 0.30882, 0);
        addNote(1, '4D', 0.69035, 0.42542, 0.15639, 0.25757, 180);
        addNote(3, '5D', 0.55819, 0.14264, 0.15799, 0.25431, 230);
        addNote(5, '6D', 0.53646, 0.71187, 0.14875, 0.24299, 123);
        addNote(7, '7D', 0.27417, 0.11417, 0.14069, 0.22535, 284);
        addNote(8, '1', 0.24757, 0.73694, 0.13319, 0.22132, 71);
        addNote(10, '2', 0.08743, 0.29458, 0.13083, 0.19812, 335);
        addNote(12, '3', 0.07, 0.56132, 0.12181, 0.20437, 30);
        addNote(13, '4', 0.73653, 0.6686, 0.10479, 0.22398, 145);
        addNote(15, '5', 0.75519, 0.26153, 0.09705, 0.22452, 203);
        addNote(17, '6', 0.42285, 0.85899, 0.09921, 0.17976, 98);
        addNote(19, '7', 0.45541, 0.05, 0.09454, 0.186, 257);
        addNote(20, '1U', 0.08701, 0.76049, 0.08157, 0.1904, 48);
        addNote(22, '2U', 0.11012, 0.13156, 0.09616, 0.19691, 303);
        addNote(24, '3U', 0, 0.44764, 0.09467, 0.14882, 0);
        _startCycleIdx = SoundNote.getNoteIdx('F#3');
        break;
      case 14:
        addNote(0, '4D', 0.69035, 0.42542, 0.15639, 0.25757, 180);
        addNote(2, '5D', 0.55819, 0.14264, 0.15799, 0.25431, 230);
        addNote(4, '6D', 0.53646, 0.71187, 0.14875, 0.24299, 123);
        addNote(6, '7D', 0.27417, 0.11417, 0.14069, 0.22535, 284);
        addNote(7, '1', 0.24757, 0.73694, 0.13319, 0.22132, 71);
        addNote(9, '2', 0.08743, 0.29458, 0.13083, 0.19812, 335);
        addNote(11, '3', 0.07, 0.56132, 0.12181, 0.20437, 30);
        addNote(12, '4', 0.73653, 0.6686, 0.10479, 0.22398, 145);
        addNote(14, '5', 0.75519, 0.26153, 0.09705, 0.22452, 203);
        addNote(16, '6', 0.42285, 0.85899, 0.09921, 0.17976, 98);
        addNote(18, '7', 0.45541, 0.05, 0.09454, 0.186, 257);
        addNote(19, '1U', 0.08701, 0.76049, 0.08157, 0.1904, 48);
        addNote(21, '2U', 0.11012, 0.13156, 0.09616, 0.19691, 303);
        addNote(23, '3U', 0, 0.44764, 0.09467, 0.14882, 0);
        _startCycleIdx = SoundNote.getNoteIdx('F3');
        break;
      case 13:
        addNote(0, '5D', 0.36535, 0.36382, 0.25965, 0.26951, 0);
        addNote(2, '6D', 0.67549, 0.42264, 0.14132, 0.32451, 180);
        addNote(4, '7D', 0, 0.42375, 0.1391, 0.33083, 0);
        addNote(5, '1', 0.67153, 0.62222, 0.13076, 0.2459, 155);
        addNote(7, '2', 0.6855, 0.24266, 0.12868, 0.29017, 203);
        addNote(9, '3', 0.55325, 0.78343, 0.12431, 0.28997, 125);
        addNote(10, '4', 0.56582, 0.08563, 0.12868, 0.28155, 234);
        addNote(12, '5', 0.33132, 0.76715, 0.14361, 0.32208, 90);
        addNote(14, '6', 0.33446, 0.08825, 0.13931, 0.3158, 270);
        addNote(16, '7', 0.12538, 0.77087, 0.12819, 0.30536, 58);
        addNote(17, '1U', 0.17383, 0.08816, 0.13021, 0.26711, 298);
        addNote(19, '2U', 0.00946, 0.62583, 0.1284, 0.22872, 23);
        addNote(21, '3U', 0.01611, 0.21176, 0.11319, 0.23694, 329);
        _startCycleIdx = SoundNote.getNoteIdx('G3');
        break;
      case 11:
        addNote(0, '5D', 0.33889, 0.36951, 0.27611, 0.28653, 0);
        addNote(2, '6D', 0, 0.42365, 0.16021, 0.29837, 0);
        addNote(4, '7D', 0.67785, 0.42309, 0.16132, 0.32215, 180);
        addNote(5, '1', 0.61487, 0.65512, 0.15965, 0.33178, 146);
        addNote(7, '2', 0.60561, 0.15227, 0.16132, 0.3587, 219);
        addNote(9, '3', 0.43809, 0.77298, 0.15792, 0.27113, 111);
        addNote(10, '4', 0.41194, 0.06821, 0.1575, 0.27709, 252);
        addNote(12, '5', 0.22461, 0.7766, 0.15861, 0.25946, 75);
        addNote(14, '6', 0.17803, 0.07603, 0.14791, 0.27805, 288);
        addNote(16, '7', -0.00299, 0.67614, 0.15368, 0.29451, 41);
        addNote(17, '1U', 0.00972, 0.21324, 0.16681, 0.26867, 327);
        _startCycleIdx = SoundNote.getNoteIdx('A3');
        break;
      case 8:
        addNote(0, '1', 0.63847, 0.41, 0.18007, 0.3409, 180);
        addNote(2, '2', 0.32958, 0.11375, 0.18007, 0.3409, 270);
        addNote(4, '3', 0.32958, 0.70104, 0.18007, 0.3409, 90);
        addNote(5, '4', 0.03361, 0.41, 0.18007, 0.3409, 0);
        addNote(7, '5', 0.58669, 0.7255, 0.1675, 0.42713, 135);
        addNote(9, '6', 0.59074, 0.11001, 0.1697, 0.42722, 225.5049);
        addNote(11, '7', 0.0174, 0.71359, 0.17171, 0.39326, 45);
        addNote(12, '1U', 0.02941, 0.12624, 0.15917, 0.38218, 315);
        _startCycleIdx = SoundNote.getNoteIdx('D4');
        break;
    }
    return noteList;
  }

  @override
  int get sizeMode => InstrumentSizeMode.square;

  @override
  BoxDecoration buildDecoration(InstrumentNote note, {Color? color}) {
    return BoxDecoration(
        borderRadius: note.deltaSoundIdx <= 0
            ? const BorderRadius.all(Radius.circular(200))
            : const BorderRadius.only(
                bottomLeft: Radius.circular(200),
                bottomRight: Radius.circular(200),
              ),
        color: color ?? const Color.fromARGB(255, 0, 173, 101));
  }

  @override
  IconData get iconData => TankIcon.instrument_tank_drum;

  @override
  Widget buildInnerNote(Rx<InstrumentNote> note, int soundIdx) {
    return Center(child: NoteIdxSign.fromName(note.value.deltaName));
  }

  //NoteIdxSign(note.value.posIdx - 4)
  //SoundNameText(SoundNote.getNoteName(soundIdx))
}
