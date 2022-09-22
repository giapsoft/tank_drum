import 'dart:convert';

import '../entities/sys_config.dart';
import 'drum_note.dart';

class Drum {
  late String name;
  List<DrumNote> drumNotes = [];
  Map<String, DrumNote> soundNameToNote = {};
  double ratio = 1.0;

  _initSoundNameToNote() {
    for (var drumNote in drumNotes) {
      soundNameToNote[drumNote.soundNoteName] = drumNote;
    }
  }

  Drum({required this.name, required this.drumNotes, required this.ratio}) {
    _initSoundNameToNote();
  }

  Drum.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    ratio = json['ratio'];
    final rawNotes = json['drumNotes'] as List<dynamic>;
    drumNotes =
        rawNotes.cast<Map<String, dynamic>>().map(DrumNote.fromJson).toList();
    _initSoundNameToNote();
  }

  DrumNote getDrumNoteBySoundName(String soundName) {
    return soundNameToNote[soundName]!;
  }

  static List<Drum> parseList(String rawListString) {
    final rawList = jsonDecode(rawListString) as List<dynamic>;
    return rawList.cast<Map<String, dynamic>>().map(Drum.fromJson).toList();
  }

  static late Drum current;
  static List<Drum> drums = [];
  static init() {
    drums = [
      ...Drum._initLocalDrums(),
      ...Drum.parseList(SysConfig.instance.encodedDrums.orElse('[]'))
    ];
    current = drums.first;
  }

  static List<Drum> _initLocalDrums() {
    return [_tank15()];
  }

  static Drum _tank15() {
    return Drum(
      name: 'Tank Drum 15 Tones',
      ratio: 1.0,
      drumNotes: [
        DrumNote(name: '3D', soundNoteName: 'F#3', order: 0),
        DrumNote(name: '5D', soundNoteName: 'A3', order: 1),
        DrumNote(name: '7', soundNoteName: 'C#5', order: 2),
        DrumNote(name: '7D', soundNoteName: 'C#4', order: 3),
        DrumNote(name: '2U', soundNoteName: 'E5', order: 4),
        DrumNote(name: '2', soundNoteName: 'E4', order: 5),
        DrumNote(name: '3U', soundNoteName: 'F#5', order: 6),
        DrumNote(name: '3', soundNoteName: 'F#4', order: 7),
        DrumNote(name: '1U', soundNoteName: 'D5', order: 8),
        DrumNote(name: '1', soundNoteName: 'D4', order: 9),
        DrumNote(name: '6', soundNoteName: 'B4', order: 10),
        DrumNote(name: '6D', soundNoteName: 'B3', order: 11),
        DrumNote(name: '4', soundNoteName: 'G4', order: 12),
        DrumNote(name: '4D', soundNoteName: 'G3', order: 13),
        DrumNote(name: '5', soundNoteName: 'A4', order: 14),
      ],
    );
  }
}
