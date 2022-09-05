import 'package:flutter/material.dart';
import '../../songs/music_note.dart';

import 'drum_note_widget.dart';

class DrumNote {
  final String name;
  final MusicNote musicNote;
  final double top;
  final double left;
  final double width;
  final double height;
  final double angle;

  DrumNote(this.name, this.musicNote, this.top, this.left, this.width,
      this.height, this.angle);

  play() async {
    musicNote.play();
  }

  final List<Function()> builders = [];
  rebuild() {
    for (var builder in builders) {
      builder();
    }
  }

  Widget build(double drumSize) {
    return DrumNoteWidget(this, drumSize);
  }
}
