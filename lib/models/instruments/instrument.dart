import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tankdrum_learning/models/instruments/instrument_note.dart';
import 'package:tankdrum_learning/models/instruments/instrument_size_mode.dart';
import 'package:tankdrum_learning/models/instruments/piano.dart';

import '../sound_note.dart';
import 'kalimba.dart';
import 'tank_drum.dart';

abstract class Instrument {
  bool get isKalimba => instrumentName == Kalimba.name;
  bool get isTankDrum => instrumentName == TankDrum.name;
  bool get isPiano => instrumentName == Piano.name;

  IconData get iconData;

  static final allInstruments = {
    Kalimba.name: Kalimba(),
    TankDrum.name: TankDrum(),
    Piano.name: Piano(),
  };
  static Instrument getInstrument(String name) => allInstruments[name]!;

  int get sizeMode;
  bool get isSquare => sizeMode == InstrumentSizeMode.square;

  int get defaultNoteCount;

  BoxDecoration buildDecoration(InstrumentNote note, {Color? color});
  Widget buildInnerNote(Rx<InstrumentNote> note, int soundIdx);

  String get instrumentName;
  List<int> get noteSizeSet;
  int get startCycleIdx => SoundNote.getStartIdxOfCycle(deltaCycleIdx);

  int get deltaCycleIdx => 0;

  List<InstrumentNote> getNotes(int totalNotes);

  List<List<int>> playableNoteSet(Set<int> soundIdxSet) {
    final properIdxSet = SoundNote.findProperSoundSet(
      deltaCycleIdx,
      possibleSizes: noteSizeSet,
      soundIdxSet: soundIdxSet,
    );
    return properIdxSet;
  }

  static List<String> playableInstruments(Set<int> soundIdxSet) {
    return Instrument.allInstruments.values
        .where((i) => i.playableNoteSet(soundIdxSet).isNotEmpty)
        .map((e) => e.instrumentName)
        .toList();
  }

  String nextName() {
    if (isKalimba) {
      return TankDrum.name;
    }
    if (isTankDrum) {
      return Piano.name;
    }
    return Kalimba.name;
  }
}
