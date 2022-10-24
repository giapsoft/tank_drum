import 'package:flutter/material.dart';
import 'package:tankdrum_learning/models/instruments/instrument_note.dart';
import 'package:tankdrum_learning/models/instruments/instrument_size_mode.dart';
import 'package:tankdrum_learning/models/instruments/piano.dart';

import '../sound_note.dart';
import 'kalimba.dart';
import 'tank_drum.dart';

abstract class Instrument {
  static const kalimba = 'Kalimba';
  static const tankDrum = 'Tank Drum';
  static const piano = 'Piano';

  bool get isKalimba => name == kalimba;
  bool get isTankDrum => name == tankDrum;
  bool get isPiano => name == piano;

  IconData get iconData;

  static final allInstruments = {
    kalimba: () => Kalimba(),
    tankDrum: () => TankDrum(),
    piano: () => Piano(),
  };
  static Instrument getInstrument(String name) => allInstruments[name]!();

  int get sizeMode;
  bool get isSquare => sizeMode == InstrumentSizeMode.square;

  int get defaultNoteCount;

  BoxDecoration buildDecoration(InstrumentNote note, {Color? color});
  String get name;
  List<int> get possibleNoteCount;
  int get startCycleIdx => SoundNote.getStartIdxOfCycle(deltaCycleIdx);

  int get deltaCycleIdx => 0;
  bool get isAllowTuning;

  List<InstrumentNote> getNotes(int totalNotes);

  List<List<int>> playableNoteSet(Set<int> soundIdxSet);
  static List<String> playableInstruments(Set<int> soundIdxSet) {
    return Instrument.allInstruments.values
        .map((e) => e())
        .where((i) => i.playableNoteSet(soundIdxSet).isNotEmpty)
        .map((e) => e.name)
        .toList();
  }

  String nextName() {
    if (isKalimba) {
      return tankDrum;
    }
    if (isTankDrum) {
      return piano;
    }
    return kalimba;
  }
}
