// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tankdrum_learning/models/instruments/instrument.dart';
import 'package:tankdrum_learning/models/instruments/piano.dart';
import 'package:tankdrum_learning/models/sound_note.dart';
import 'package:tankdrum_learning/utils/math_utils.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    print(
        MathUtils.baiToan1(a: 2, b: 2, a2: 3.225, b2: 3.225, degree: 360 + 45));
  });
}

testFillDelta1() {
  final cycle = [2, 2, 1, 2, 2, 2, 1];
  final result = <int>[0];
  for (int i = 1; i < 21; i++) {
    final time = i ~/ cycle.length;

    int add = cycle[(i - 1) % cycle.length];
    result.add(result[i - 1] + add);

    print('i: $i, time: $time, add: $add, result: ${result[i]}');
  }
  print(result);
}

fillTank() {
  final test = [2, 2, 1, 2, 2, 2];
  int first = SoundNote.getNoteIdx('G#3');
  int count = 0;
  final result = [first];
  for (int i = 1; i < 21; i++) {
    if (count == test.length) {
      count = 0;
      result.add(result[i - 1] + 1);
    } else {
      result.add(result[i - 1] + test[count]);
      count++;
    }
  }
  const tank15 = 'F#3,G3,A3,B3,C#4,D4,E4,F#4,G4,A4,B4,C#5,D5,E5,F#5';
  const tank9 = 'A3,C4,C5,D4,E5,G4,D5,E4,A4';
  const kalimba21 =
      'G#3,A#3,C4,C#4,D#4,F4,G4,G#4,A#4,C5,C#5,D#5,F5,G5,G#5,A#5,C6,C#6,D#6,F6,G6';
  int edit = SoundNote.getNoteIdx('G#3') - SoundNote.getNoteIdx('C3');
  final list =
      kalimba21.split(',').map((s) => SoundNote.getNoteIdx(s)).toList();
  list.sort();
  print(list.length);
  final tuning = <String>[];
  for (int i = 0; i < list.length; i++) {
    tuning.add(SoundNote.getNoteName(list[i] - edit));
    if (i > 0) {
      list[i] -= list[0];
    }

    print('$i: ${list[i]},');
  }
  print(tuning);
}
