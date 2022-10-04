import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tankdrum_learning/models/sound_note.dart';
import 'package:tankdrum_learning/models/sound_set.dart';

import '../../widgets/note_idx_sign.dart';
import '../../widgets/sound_name_text.dart';
import 'instrument.dart';
import 'tut_direction.dart';

class InstrumentNote {
  double top;
  double left;
  double width;
  double height;
  double angle;
  int posIdx;
  Instrument? instrument;
  int deltaSoundIdx;
  int notePitch = 0;
  TutDirection tutDirection;
  EdgeInsets? insets;
  BorderRadiusGeometry? borderRadius;
  EdgeInsets? padding;
  Widget nameBuilder() =>
      !instrument!.isKalimba ? buildName() : buildKalimbaName();

  Widget buildName() {
    return NoteIdxSign(
      pitchIdx,
      padding: instrument!.isFreeGrid
          ? EdgeInsets.all(width / 5)
          : const EdgeInsets.only(top: 3),
    );
  }

  Widget buildKalimbaName() {
    final nameWidth = min(25, width).toDouble();
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SoundNameText(SoundNote.getNoteName(currentSoundIdx), isVertical: true),
        Container(
            decoration: BoxDecoration(
                color: const Color.fromARGB(59, 255, 255, 255),
                borderRadius: BorderRadius.circular(200)),
            height: nameWidth * 1.4,
            width: nameWidth,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: NoteIdxSign(pitchIdx),
            ))
      ],
    );
  }

  int pitchIdx = 0;
  InstrumentNote({
    this.instrument,
    required this.posIdx,
    this.top = 1,
    this.left = 1,
    this.width = 1,
    this.height = 1,
    this.deltaSoundIdx = -1,
    this.angle = 0,
    this.insets,
    this.tutDirection = TutDirection.around,
  });

  updatePos(
      double top, double left, double width, double height, double angle) {
    this.top = top;
    this.left = left;
    this.width = width;
    this.height = height;
    this.angle = angle;
  }

  double borderWidth = 10;

  double get topWidthInset => top + (insets?.top ?? 0);
  double get leftWithInset => left + (insets?.left ?? 0);

  bool isInBorder(Offset pos) {
    return topWidthInset - borderWidth < pos.dy &&
        leftWithInset - borderWidth < pos.dx &&
        topWidthInset + height + borderWidth * 2 > pos.dy &&
        leftWithInset + width + borderWidth * 2 > pos.dx;
  }

  bool isInBody(Offset pos) {
    return topWidthInset < pos.dy &&
        leftWithInset < pos.dx &&
        topWidthInset + height > pos.dy &&
        leftWithInset + width > pos.dx;
  }

  increaseTune() {
    notePitch = SoundNote.increaseTune(notePitch);
  }

  decreaseTune() {
    notePitch = SoundNote.decreaseTune(notePitch);
  }

  resetPitch() {
    notePitch = 0;
  }

  tuneTo(int idx) {
    notePitch = idx - instrument!.baseSoundIdx - deltaSoundIdx;
  }

  int get currentSoundIdx =>
      notePitch + deltaSoundIdx + instrument!.baseSoundIdx;

  play() async {
    SoundSet.play(currentSoundIdx);
  }

  @override
  String toString() {
    return 'postIdx: $posIdx, delta: $deltaSoundIdx, sign: $pitchIdx, top:$top, left:$left, width: $width, height: $height';
  }
}
