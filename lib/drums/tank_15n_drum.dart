import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tankdrum_learning/drums/drum.dart';

import 'drum_note/drum_note.dart';
import '../songs/music_note_lib.dart';

class Tank15NDrum with Drum {
  static bool isMute = false;

  static final note1 =
      DrumNote('1', MusicNoteLib.of('1')!, 0.24, 0.78, 0.13, 0.17, 75.0);
  static final note1U =
      DrumNote('1U', MusicNoteLib.of('1U')!, 0.14, 0.72, 0.1, 0.13, 54.0);

  static final note2 =
      DrumNote('2', MusicNoteLib.of('2')!, 0.041, 0.29, 0.136, 0.173, 339.0);
  static final note2U =
      DrumNote('2U', MusicNoteLib.of('2U')!, 0.112, 0.17, 0.115, 0.133, 303.0);

  static final note3 =
      DrumNote('3', MusicNoteLib.of('3')!, 0.045, 0.577, 0.135, 0.173, 37.0);
  static final note3D =
      DrumNote('3D', MusicNoteLib.of('3D')!, 0.31, 0.36, 0.273, 0.273, 0.0);
  static final note3U =
      DrumNote('3U', MusicNoteLib.of('3U')!, 0.02, 0.440, 0.12, 0.14, 0.0);

  static final note4 =
      DrumNote('4', MusicNoteLib.of('4')!, 0.694, 0.636, 0.132, 0.188, 145.0);
  static final note4D =
      DrumNote('4D', MusicNoteLib.of('4D')!, 0.714, 0.388, 0.206, 0.265, 180.0);

  static final note5 =
      DrumNote('5', MusicNoteLib.of('5')!, 0.686, 0.219, 0.130, 0.240, 218.0);
  static final note5D =
      DrumNote('5D', MusicNoteLib.of('5D')!, 0.520, 0.085, 0.171, 0.259, 230.0);

  static final note6 =
      DrumNote('6', MusicNoteLib.of('6')!, 0.385, 0.8, 0.120, 0.171, 93.0);
  static final note6D =
      DrumNote('6D', MusicNoteLib.of('6D')!, 0.513, 0.739, 0.150, 0.24, 125.0);

  static final note7 =
      DrumNote('7', MusicNoteLib.of('7')!, 0.394, 0.032, 0.128, 0.163, 270.0);
  static final note7D =
      DrumNote('7D', MusicNoteLib.of('7D')!, 0.218, 0.093, 0.158, 0.210, 284.0);

  static DrumNote note(String name) {
    return notes[name]!;
  }

  @override
  List<DrumNote> get drumNotes => notes.values.toList();

  static Map<String, DrumNote>? _notes;

  static Map<String, DrumNote> get notes => _notes ??= <String, DrumNote>{
        note1.name: note1,
        note1U.name: note1U,
        note2.name: note2,
        note2U.name: note2U,
        note3.name: note3,
        note3U.name: note3U,
        note3D.name: note3D,
        note4.name: note4,
        note4D.name: note4D,
        note5.name: note5,
        note5D.name: note5D,
        note6.name: note6,
        note6D.name: note6D,
        note7.name: note7,
        note7D.name: note7D,
      };
}

class Tank15NDrumWidget extends StatelessWidget {
  const Tank15NDrumWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      final width = constraint.maxWidth;
      final height = constraint.maxHeight;
      final drumSize = math.min(500.0, math.min(width, height));
      return SizedBox(
        width: drumSize,
        height: drumSize,
        child: Stack(
          children: <Widget>[
            Container(
              width: drumSize,
              height: drumSize,
              decoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  borderRadius: BorderRadius.all(Radius.circular(drumSize))),
            ),
            ...Tank15NDrum.notes.values.map((e) => e.build(drumSize)).toList(),
          ],
        ),
      );
    });
  }
}
