import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';
import 'package:synchronized/extension.dart';

class _SetConstants {
  static const tank15Tones = 'Tank Drum 15 Tones';
}

class SoundSet {
  final String name; // to show the name on screen
  final String folderPath; // to get files inside
  final List<String> soundNoteNames;

  static final pool = Soundpool.fromOptions(
      options: const SoundpoolOptions(
    streamType: StreamType.notification,
  ));

  static Map<String, int> setSoundId = {};
  static Future<void> loadSound(String soundPath) async {
    'loadSound'.synchronized(() async {
      if (setSoundId[soundPath] != null) {
        return;
      }
      await rootBundle.load(soundPath).then((soundData) async {
        final id = await pool.load(soundData);
        setSoundId[soundPath] = id;
      }).catchError((error) {
        // no need handle
        log('error when load bundle: $error');
      });
    });
  }

  static playSoundPath(String soundPath) {
    if (setSoundId[soundPath] == null) {
      loadSound(soundPath);
    } else {
      pool.play(setSoundId[soundPath]!);
    }
  }

  _init() async {
    for (var soundNoteName in soundNoteNames) {
      await _SoundNote.of(soundNoteName).loadFolder(folderPath);
    }
  }

  _play(String soundNoteName) async {
    _SoundNote.of(soundNoteName).play(folderPath);
  }

  SoundSet(this.name, this.folderPath, this.soundNoteNames);
  static SoundSet of(String setName) {
    return all[setName]!;
  }

  static playSound(String soundNoteName) async {
    current._play(soundNoteName);
  }

  static late SoundSet current;
  static Map<String, SoundSet> all = {};
  static loadLocal() async {
    all[_SetConstants.tank15Tones] = _tank15Sounds();
    for (final soundSet in all.values) {
      await soundSet._init();
    }
    current = all.values.first;
  }

  static const allSoundNames = [
    'A3',
    'A4',
    'B3',
    'B4',
    'C#4',
    'C#5',
    'D4',
    'D5',
    'E4',
    'E5',
    'F#3',
    'F#4',
    'F#5',
    'G3',
    'G4',
  ];

  static SoundSet _tank15Sounds() {
    return SoundSet(_SetConstants.tank15Tones, 'assets/note_sounds/guzheng', [
      'A3',
      'A4',
      'B3',
      'B4',
      'C#4',
      'C#5',
      'D4',
      'D5',
      'E4',
      'E5',
      'F#3',
      'F#4',
      'F#5',
      'G3',
      'G4'
    ]);
  }
}

class _SoundNote {
  final String name;
  Soundpool pool = Soundpool.fromOptions(
      options: const SoundpoolOptions(
    streamType: StreamType.music,
  ));
  _SoundNote(this.name);

  Map<String, int> setSoundId = {};
  Future<void> loadFolder(String folderPath) async {
    if (setSoundId.isEmpty) {
      final soundPath = '$folderPath/$name.mp3';
      await rootBundle.load(soundPath).then((soundData) async {
        final id = await pool.load(soundData);
        setSoundId[folderPath] = id;
      }).catchError((error) {
        // no need handle
        log('error when load bundle: $error');
      });
    }
  }

  play(String folderPath) {
    final id = setSoundId[folderPath];
    if (id != null) {
      pool.play(id);
    }
  }

  static Map<String, _SoundNote> notes = {};
  static _SoundNote of(String name) {
    return notes[name] ??= _SoundNote(name);
  }
}
