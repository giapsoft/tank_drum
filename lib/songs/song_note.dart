import 'package:flutter/material.dart';
import 'package:tankdrum_learning/drums/drum_note/drum_note.dart';
import 'package:tankdrum_learning/songs/song_ctrl.dart';

import '../drums/tank_15n_drum.dart';

class SongNote {
  static int waitingUnit = 300;

  int get waitingMs => waitingUnit * longWaiter;

  List<DrumNote> drumNotes = [];
  int longWaiter = 1;

  Future<void> delay() async {
    await Future.delayed(Duration(milliseconds: waitingMs));
  }

  play() {
    for (var drumNote in drumNotes) {
      drumNote.play();
    }
  }

  Map<String, int>? _hitCounter;
  Map<String, int> get hitCounter {
    if (_hitCounter == null) {
      _hitCounter = {};
      for (var drumNote in drumNotes) {
        _hitCounter![drumNote.name] = 0;
      }
    }
    return _hitCounter!;
  }

  resetHitCounter() {
    hitCounter.forEach((noteName, _) {
      hitCounter[noteName] = 0;
    });
  }

  static SongNote? lastNote;

  bool hit(DrumNote drumNote) {
    int? count = hitCounter[drumNote.name];
    if (count != null) {
      lastNote = this;
      hitCounter[drumNote.name] = count + 1;
    }
    return hitCounter.values.every((element) => element > 0);
  }

  bool get isEnded => hitCounter.values.every((element) => element > 0);

  final List<String> noteNames;
  int noteIdx;

  SongNote(this.noteIdx, this.noteNames, [this.longWaiter = 1]) {
    drumNotes = noteNames.map((e) => Tank15NDrum.note(e)).toList();
    resetHitCounter();
  }

  static SongNote parse(int idx, String noteString) {
    List<String> noteNames = [];
    int longWaiter = 1;
    final rawDrumNotes = noteString.split('-');
    for (int i = 0; i < rawDrumNotes.length; i++) {
      final rawDrumNote = rawDrumNotes[i];
      final name = rawDrumNote.replaceAll(RegExp('[^A-Za-z0-9]'), '');
      noteNames.add(name);
      longWaiter = '.'.allMatches(noteString).length + 1;
    }
    return SongNote(idx, noteNames, longWaiter);
  }

  static List<SongNote> parseList(String noteListString) {
    List<SongNote> notes = [];
    final rawNotes = noteListString
        .split(',')
        .where((element) => element.trim().isNotEmpty)
        .toList();
    for (int i = 0; i < rawNotes.length; i++) {
      final rawNote = rawNotes[i];
      notes.add(SongNote.parse(i, rawNote));
    }
    return notes;
  }

  bool hasDrumNote(String name) {
    return noteNames.contains(name);
  }

  void rebuild() {
    for (var drumNote in drumNotes) {
      drumNote.rebuild();
    }
  }

  Widget buildSub() {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: SongNoteSub(this),
    );
  }
}

class SongNoteSub extends StatefulWidget {
  const SongNoteSub(this.songNote, {Key? key}) : super(key: key);

  final SongNote songNote;

  @override
  State<SongNoteSub> createState() => _SongNoteSubState();
}

class _SongNoteSubState extends State<SongNoteSub> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: widget.songNote.noteIdx < (SongCtrl.currentNote?.noteIdx ?? 0)
            ? Colors.deepOrange
            : Colors.amber,
      ),
      padding: const EdgeInsets.all(5),
      child: Column(
          children: widget.songNote.noteNames.map((e) => Text(e)).toList()),
    );
  }
}
