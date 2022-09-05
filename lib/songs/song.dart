import 'package:tankdrum_learning/songs/song_line_ctrl.dart';

import '../drums/common/select_play_mode_btn.dart';
import 'song_ctrl.dart';
import 'song_line.dart';

class Song {
  final String name;

  Song(this.name);
  List<SongLine> get lines => [
        SongPlayMode.oneLimitNoteLine,
        SongPlayMode.repeatLimitNoteLine
      ].contains(SongCtrl.playMode)
          ? linesWithCutOff
          : originLines;

  List<SongLine>? _linesWithCutOff;
  int lastMaxNotePerLine = 0;
  List<SongLine> get linesWithCutOff {
    if (_linesWithCutOff == null ||
        lastMaxNotePerLine != SongLineCtrl.maxNotesPerLine) {
      _linesWithCutOff = createLimitLines();
    }
    return _linesWithCutOff!;
  }

  List<SongLine> createLimitLines() {
    final lineList = <SongLine>[];
    lastMaxNotePerLine = SongLineCtrl.maxNotesPerLine;
    final notes = originLines
        .map((e) => e.songNotes)
        .expand((element) => element)
        .toList();
    for (int i = 0; i < notes.length; i++) {
      if (i % 5 == 0) {
        lineList.add(SongLine(this, []));
      }
      lineList.last.songNotes.add(notes[i]);
    }
    return lineList;
  }

  final List<SongLine> originLines = [];

  void addLine(String noteListRaw) {
    originLines.add(SongLine.parse(this, noteListRaw));
  }
}
