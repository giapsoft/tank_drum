import 'package:flutter/material.dart';
import 'package:tankdrum_learning/songs/song.dart';

import 'song_note.dart';

class SongLine {
  final List<SongNote> songNotes;
  final Song song;

  SongLine(this.song, this.songNotes);

  build() {
    for (var e
        in song.lines.map((e) => e.songNotes).expand((element) => element)) {
      e.rebuild();
    }
  }

  static parse(Song song, String noteListRaw) {
    return SongLine(song, SongNote.parseList(noteListRaw));
  }

  Widget buildSub() {
    final subLines = <List<SongNote>>[];
    for (int i = 0; i < songNotes.length; i++) {
      if (i % 7 == 0) {
        subLines.add([]);
      }
      subLines.last.add(songNotes[i]);
    }

    buildLine(List<SongNote> notes) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: notes.map((e) => e.buildSub()).toList(),
      );
    }

    return Container(
      color: Colors.deepOrange,
      child: Column(
        children: subLines.map((e) => buildLine(e)).toList(),
      ),
    );
  }
}
