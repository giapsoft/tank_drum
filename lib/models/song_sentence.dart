import 'package:tankdrum_learning/models/song_note.dart';

class SongSentence {
  List<SongNote> notes;
  SongSentence(this.notes);
  SongNote? get firstNote => notes.isEmpty ? null : notes.first;
  SongNote? get lastNote => notes.isEmpty ? null : notes.last;
}
