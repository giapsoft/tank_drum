import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import '../sound_set.dart';

import 'instrument.dart';

class TankDrum extends Instrument {
  @override
  SoundSet get defaultSoundSet => SoundSet.tankDrum;

  @override
  String get name => Instrument.tankDrum;

  @override
  int get defaultNoteCount => 15;

  @override
  int get deltaCycleIdx => -5;

  @override
  int get defaultTune => 2;

  @override
  List<int> get possibleNoteCount {
    return [8, 9, 10, 11, 13, 15];
  }

  @override
  sortIdx() {
    fillDentaIdx();
  }

  @override
  doResizePosition() {
    final isPortrait = wrapper.height > wrapper.width;
    final parentSize = math.min(wrapper.height, wrapper.width);
    final addVertical =
        wrapper.top + (isPortrait ? (wrapper.height - wrapper.width) / 2 : 0);
    final addHorizontal =
        wrapper.left + (isPortrait ? 0 : (wrapper.width - wrapper.height) / 2);

    updatePos(int i, double top, double left, double width, double height,
        double angle) {
      noteList[i].posIdx = i;
      noteList[i].top = addVertical + top * parentSize;
      noteList[i].left = addHorizontal + left * parentSize;
      noteList[i].width = width * parentSize;
      noteList[i].height = height * parentSize;
      noteList[i].angle = angle;
    }

    for (var note in noteList) {
      if (note.posIdx > 0 || noteList.length % 2 == 0) {
        note.borderRadius = const BorderRadius.only(
            bottomLeft: Radius.circular(200),
            bottomRight: Radius.circular(200));
      } else {
        note.borderRadius = BorderRadius.circular(200);
      }
      note.padding = const EdgeInsets.all(3);
    }

    switch (noteList.length) {
      case 15:
        updatePos(0, 0.33406, 0.34087, 0.30882, 0.30882, 0);
        updatePos(1, 0.69035, 0.42542, 0.15639, 0.25757, 180);
        updatePos(2, 0.55819, 0.14264, 0.15799, 0.25431, 230);
        updatePos(3, 0.53646, 0.71187, 0.14875, 0.24299, 123);
        updatePos(4, 0.27417, 0.11417, 0.14069, 0.22535, 284);
        updatePos(5, 0.24757, 0.73694, 0.13319, 0.22132, 71);
        updatePos(6, 0.08743, 0.29458, 0.13083, 0.19812, 335);
        updatePos(7, 0.07, 0.56132, 0.12181, 0.20437, 30);
        updatePos(8, 0.73653, 0.6686, 0.10479, 0.22398, 145);
        updatePos(9, 0.75519, 0.26153, 0.09705, 0.22452, 203);
        updatePos(10, 0.42285, 0.85899, 0.09921, 0.17976, 98);
        updatePos(11, 0.45541, 0.05, 0.09454, 0.186, 257);
        updatePos(12, 0.08701, 0.76049, 0.08157, 0.1904, 48);
        updatePos(13, 0.11012, 0.13156, 0.09616, 0.19691, 303);
        updatePos(14, 0, 0.44764, 0.09467, 0.14882, 0);

        break;
      case 13:
        updatePos(0, 0.36535, 0.36382, 0.25965, 0.26951, 0);
        updatePos(1, 0.0359, 0.41313, 0.1391, 0.29493, 0);
        updatePos(2, 0.67549, 0.43215, 0.14132, 0.28833, 180);
        updatePos(3, 0.34226, 0.75118, 0.14361, 0.29014, 90);
        updatePos(4, 0.35535, 0.10194, 0.13931, 0.2884, 270);
        updatePos(5, 0.67153, 0.62222, 0.13076, 0.2459, 155);
        updatePos(6, 0.68729, 0.25146, 0.12868, 0.24514, 203);
        updatePos(7, 0.56167, 0.75854, 0.12431, 0.21507, 125);
        updatePos(8, 0.57965, 0.11278, 0.12868, 0.21444, 234);
        updatePos(9, 0.19674, 0.73132, 0.12819, 0.21208, 58);
        updatePos(10, 0.22104, 0.11653, 0.13021, 0.20285, 298);
        updatePos(11, 0.06951, 0.61361, 0.1284, 0.16618, 23);
        updatePos(12, 0.08639, 0.23125, 0.11319, 0.16125, 329);
        break;
      case 10:
        updatePos(0, 0.0456, 0.40362, 0.13757, 0.32413, 0);
        updatePos(1, 0.77786, 0.45062, 0.09754, 0.18271, 180);
        updatePos(2, 0.61834, 0.60625, 0.12549, 0.26343, 140.109);
        updatePos(3, 0.62785, 0.25737, 0.12982, 0.26661, 213.9848);
        updatePos(4, 0.5102, 0.78243, 0.10157, 0.2085, 104.2586);
        updatePos(5, 0.54609, 0.10306, 0.09707, 0.18953, 249.1352);
        updatePos(6, 0.26534, 0.70512, 0.13339, 0.30019, 71.14143);
        updatePos(7, 0.28185, 0.12574, 0.1322, 0.30929, 287.4756);
        updatePos(8, 0.11043, 0.64345, 0.09496, 0.2144, 35.5136);
        updatePos(9, 0.11773, 0.21328, 0.10646, 0.22133, 329.4113);
        break;
      case 11:
        updatePos(0, 0.33889, 0.36951, 0.27611, 0.28653, 0);
        updatePos(1, 0.05507, 0.43813, 0.16021, 0.23146, 0);
        updatePos(2, 0.67785, 0.40917, 0.16132, 0.25646, 180);
        updatePos(3, 0.62229, 0.63083, 0.15965, 0.24493, 146);
        updatePos(4, 0.61875, 0.18938, 0.16132, 0.24076, 219);
        updatePos(5, 0.45326, 0.7509, 0.15792, 0.22382, 111);
        updatePos(6, 0.42792, 0.09021, 0.1575, 0.23083, 252);
        updatePos(7, 0.26326, 0.74694, 0.15861, 0.19806, 75);
        updatePos(8, 0.24181, 0.11049, 0.15979, 0.18924, 288);
        updatePos(9, 0.10722, 0.63493, 0.15368, 0.16889, 41);
        updatePos(10, 0.10215, 0.24062, 0.16681, 0.16813, 327);
        break;
      case 9:
        updatePos(0, 0.3025, 0.31972, 0.36049, 0.37424, 0);
        updatePos(1, 0.72382, 0.41347, 0.19458, 0.25556, 180);
        updatePos(2, 0.57993, 0.69569, 0.19597, 0.24431, 128);
        updatePos(3, 0.58007, 0.13104, 0.1734, 0.25875, 233);
        updatePos(4, 0.33174, 0.77062, 0.17514, 0.20854, 82);
        updatePos(5, 0.32292, 0.06611, 0.16125, 0.23299, 281);
        updatePos(6, 0.10819, 0.6534, 0.14813, 0.18917, 43);
        updatePos(7, 0.11451, 0.20632, 0.1441, 0.19681, 318);
        updatePos(8, 0.03653, 0.43028, 0.14549, 0.20278, 0);

        break;
      case 8:
        updatePos(0, 0.03361, 0.41, 0.18007, 0.3409, 0);
        updatePos(1, 0.32958, 0.70104, 0.18007, 0.3409, 90);
        updatePos(2, 0.32958, 0.11375, 0.18007, 0.3409, 270);
        updatePos(3, 0.63847, 0.41, 0.18007, 0.3409, 180);
        updatePos(4, 0.13757, 0.17104, 0.18007, 0.24681, 315);
        updatePos(5, 0.1375, 0.65549, 0.18007, 0.2491, 45);
        updatePos(6, 0.61917, 0.16743, 0.18007, 0.26188, 225.5049);
        updatePos(7, 0.61715, 0.65194, 0.18007, 0.24944, 135);
        break;
    }
  }
}
