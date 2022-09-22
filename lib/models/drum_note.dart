import 'dart:convert';

import 'package:tankdrum_learning/models/sound_set.dart';

import 'drum.dart';
import 'note_position_calculator.dart';

class DrumNote {
  String name, soundNoteName;
  int order;
  String toJson() {
    return jsonEncode({
      "name": name,
      "soundNoteName": soundNoteName,
      "order": order,
    });
  }

  factory DrumNote.fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    final soundNoteName = json['soundNoteName'];
    final order = json['order'];
    return DrumNote(name: name, soundNoteName: soundNoteName, order: order);
  }

  DrumNote(
      {required this.name, required this.soundNoteName, required this.order});

  NotePosition get pos {
    return NotePositionCalculator.of(Drum.current.drumNotes.length).pos[order];
  }

  playSound() async {
    SoundSet.playSound(soundNoteName);
  }
}
