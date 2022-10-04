import 'song_note.dart';

class SongNoteGroup {
  List<SongNote> notes;
  int beats = 1;
  int waitingMillisecond = 0;
  int idx;
  SongNoteGroup(this.notes, this.beats, this.waitingMillisecond, this.idx);

  play({
    isSilence = false,
    Function(SongNote)? onStartNote,
    Function(SongNote)? onEndNote,
    int tune = 0,
  }) async {
    for (final note in notes) {
      if (onStartNote != null) {
        onStartNote(note);
      }
      if (!isSilence) {
        note.play(tune: tune);
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
    bool lastHasLink = false;
    int idx = 0;
    for (final note in notes) {
      if (!lastHasLink) {
        result.add(SongNoteGroup([note], note.beats, note.millisecond, idx++));
      } else {
        result.last.notes.add(note);
        result.last.beats = note.beats;
        result.last.waitingMillisecond = note.millisecond;
      }
      lastHasLink = note.hasLink;
    }
    return result;
  }
}
