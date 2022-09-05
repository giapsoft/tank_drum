import 'package:tankdrum_learning/songs/song.dart';
import 'package:tankdrum_learning/songs/song_ctrl.dart';
import 'package:tankdrum_learning/songs/song_line.dart';

import '../drums/drum_note/drum_note.dart';
import 'song_note.dart';
import 'song_sub.dart';

class SongLineCtrl {
  static SongLine? get playingLine => SongCtrl.playingLine;
  static Song? get playingSong => SongCtrl.playingSong;
  static List<SongNote> get songNotes => playingLine?.songNotes ?? [];
  static int maxNotesPerRow = 5;
  static int maxNotesPerLine = 8;

  static int currentNoteIdx = 0;

  static SongNote? get currentNote =>
      currentNoteIdx < songNotes.length ? songNotes[currentNoteIdx] : null;
  static SongNote? get nextNote => currentNoteIdx + 1 >= songNotes.length
      ? null
      : songNotes[currentNoteIdx + 1];
  static SongNote? get prevNote => (currentNote != null && currentNoteIdx > 0)
      ? songNotes[currentNoteIdx - 1]
      : null;

  // play(Function() lastNoteCallBack) async {
  //   for (int i = currentNoteIdx; i < songNotes.length; i++) {
  //     if (SongCtrl.isPlaying) {
  //       final note = songNotes[i];
  //       note.play();
  //       await note.delay();
  //     } else {
  //       lastNoteCallBack();
  //       return;
  //     }
  //   }
  //   lastNoteCallBack();
  // }

  static List<SongNote> get notesFromCurrent {
    final result = <SongNote>[];
    for (int i = currentNoteIdx; i < songNotes.length; i++) {
      result.add(songNotes[i]);
    }
    return result;
  }

  static void resetNoteIdx() {
    currentNoteIdx = 0;
  }

  static bool hit(DrumNote note) {
    bool isOver = false;
    if (currentNote?.hit(note) ?? false) {
      if (currentNoteIdx >= songNotes.length - 1) {
        currentNoteIdx = 0;
        isOver = true;
      } else {
        currentNoteIdx++;
      }
      () async {
        currentNote?.resetHitCounter();
        SongSub.rebuild();
        currentNote?.rebuild();
        SongNote.lastNote?.rebuild();
      }();
    }
    return isOver;
  }
}
