import 'dart:math' as math;

import 'package:tankdrum_learning/drums/common/select_play_mode_btn.dart';
import 'package:tankdrum_learning/songs/song_sub.dart';
import 'package:tankdrum_learning/drums/drum.dart';

import '../drums/drum_note/drum_note.dart';
import 'song.dart';
import 'song_line.dart';
import 'song_line_ctrl.dart';
import 'song_note.dart';

class SongCtrl {
  static Song? playingSong;
  static SongPlayMode playMode = SongPlayMode.repeatSong;

  static reset() {
    currentLineIdx = 0;
  }

  static SongNote? get currentNote => SongLineCtrl.currentNote;
  static int currentLineIdx = 0;
  static SongLine? get playingLine => playingLines.isEmpty
      ? null
      : playingLines[math.min(currentLineIdx, playingLines.length - 1)];
  static bool isPlaying = false;

  static bool get isLastLine {
    return currentLineIdx >= playingLines.length - 1;
  }

  static _playCurrentLine() async {
    for (final note in SongLineCtrl.notesFromCurrent) {
      if (!isPlaying) {
        return;
      }
      for (var drumNote in note.drumNotes) {
        if (hit(drumNote)) {
          if ([SongPlayMode.oneSong, SongPlayMode.repeatSong]
              .contains(SongCtrl.playMode)) {
            if (!isLastLine || SongPlayMode.repeatSong == SongCtrl.playMode) {
              nextLine();
              await note.delay();
              _playAround();
              return;
            }
          }
        }
      }
      await note.delay();
    }
  }

  static play() async {
    if (playingSong == null) {
      return;
    }
    isPlaying = true;
    await _playAround();
  }

  static _playAround() async {
    if (isPlaying) {
      await _playCurrentLine();
      if ([SongPlayMode.oneLine, SongPlayMode.oneLimitNoteLine]
          .contains(SongCtrl.playMode)) {
        isPlaying = false;
        _rebuildCurrentLine();
        return;
      }
      if ([SongPlayMode.repeatLine, SongPlayMode.repeatLimitNoteLine]
          .contains(SongCtrl.playMode)) {
        _playAround();
      }
    } else {
      SelectPlayModeBtn.rebuild();
      return;
    }
  }

  static resetAllNoteIdx() {
    SongLineCtrl.resetNoteIdx();
    SongSub.rebuild();
    Drum.playingDrum.rebuildNotes();
  }

  static void pause() {
    isPlaying = false;
  }

  static List<SongLine> get playingLines => playingSong?.lines ?? [];

  static SongLine? lineNext() {
    return currentLineIdx > playingLines.length - 1
        ? playingLines[currentLineIdx + 1]
        : null;
  }

  static _rebuildCurrentLine() {
    SongLineCtrl.resetNoteIdx();
    playingLine?.build();
    SongSub.rebuild();
  }

  static nextLine() {
    if (currentLineIdx < playingLines.length - 1) {
      currentLineIdx++;
    } else {
      currentLineIdx = 0;
    }
    _rebuildCurrentLine();
  }

  static prevLine() {
    if (currentLineIdx > 0) {
      currentLineIdx--;
    } else {
      currentLineIdx = playingLines.length - 1;
    }
    _rebuildCurrentLine();
  }

  static bool hit(DrumNote drumNote) {
    bool endLine = false;
    if (SongCtrl.playMode == SongPlayMode.autoNext &&
        SongCtrl.playingSong != null) {
      () {
        // ignore: avoid_function_literals_in_foreach_calls
        SongLineCtrl.currentNote?.drumNotes.forEach((note) {
          note.play();
          endLine = SongLineCtrl.hit(note);
        });
      }();
    } else {
      drumNote.play();
      endLine = SongLineCtrl.hit(drumNote);
    }
    () async {
      if (!isPlaying && endLine) {
        if ([
          SongPlayMode.repeatSong,
          SongPlayMode.oneSong,
          SongPlayMode.autoNext
        ].contains(playMode)) {
          nextLine();
        } else if (playMode == SongPlayMode.oneLine) {
          pause();
        }
      }
    }();

    return endLine;
  }
}
