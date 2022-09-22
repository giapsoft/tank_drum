import 'note_link_type.dart';
import 'song_note.dart';

class SongNoteGroup {
  List<SongNote> notes;
  NoteLinkType linkType;
  int beats = 1;
  int waitingMillisecond = 0;
  int idx;
  SongNoteGroup(
      this.notes, this.linkType, this.beats, this.waitingMillisecond, this.idx);

  play({
    isSilence = false,
    Function(SongNote)? onStartNote,
    Function(SongNote)? onEndNote,
  }) async {
    for (final note in notes) {
      if (onStartNote != null) {
        onStartNote(note);
      }
      if (!isSilence) {
        note.playSound();
      }
      if (linkType.isSwipe()) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      if (onEndNote != null) {
        onEndNote(note);
      }
    }
  }

  Future<void> waitingByBeats(int bpm) async {
    final time = Duration(milliseconds: (60 / bpm * beats * 1000).round());
    await Future.delayed(time);
  }

  Future<void> waitingByMillisecond() async {
    final time = Duration(milliseconds: waitingMillisecond);
    await Future.delayed(time);
  }

  static List<SongNoteGroup> parse(List<SongNote> notes) {
    final result = <SongNoteGroup>[];
    NoteLinkType lastLink = NoteLinkType.none;
    int idx = 0;
    for (final note in notes) {
      if (lastLink.isNone()) {
        result.add(SongNoteGroup(
            [note], note.linkType, note.beats, note.millisecond, idx++));
      } else {
        result.last.notes.add(note);
        result.last.beats = note.beats;
        result.last.waitingMillisecond = note.millisecond;
        result.last.linkType = note.linkType;
      }
      lastLink = note.linkType;
    }
    return result;
  }
}
