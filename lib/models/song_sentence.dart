import 'package:tankdrum_learning/models/song_note.dart';

class SongSentence {
  List<SNote> notes;
  SongSentence(this.notes);
  SNote? get firstNote => notes.isEmpty ? null : notes.first;
  SNote? get lastNote => notes.isEmpty ? null : notes.last;
}
