import 'music_note.dart';

class MusicNoteLib {
  static Future<void> init() async {
    for (var note in notes) {
      await note.init();
    }
  }

  static final note1 = MusicNote('1');
  static final note1U = MusicNote('1U');

  static final note2 = MusicNote('2');
  static final note2U = MusicNote('2U');

  static final note3 = MusicNote('3');
  static final note3D = MusicNote('3D');
  static final note3U = MusicNote('3U');

  static final note4 = MusicNote('4');
  static final note4D = MusicNote('4D');

  static final note5 = MusicNote('5');
  static final note5D = MusicNote('5D');

  static final note6 = MusicNote('6');
  static final note6D = MusicNote('6D');

  static final note7 = MusicNote('7');
  static final note7D = MusicNote('7D');

  static MusicNote? of(String noteName) {
    return notesMap[noteName];
  }

  static Map<String, MusicNote>? _notesMap;

  static List<MusicNote>? _notes;
  static List<MusicNote> get notes => _notes ??= notesMap.values.toList();

  static Map<String, MusicNote> get notesMap {
    return _notesMap ??= <String, MusicNote>{
      note1.name: note1,
      note1U.name: note1U,
      note2.name: note2,
      note2U.name: note2U,
      note3.name: note3,
      note3U.name: note3U,
      note3D.name: note3D,
      note4.name: note4,
      note4D.name: note4D,
      note5.name: note5,
      note5D.name: note5D,
      note6.name: note6,
      note6D.name: note6D,
      note7.name: note7,
      note7D.name: note7D,
    };
  }
}
