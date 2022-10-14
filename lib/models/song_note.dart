import 'package:tankdrum_learning/models/note_link_type.dart';
import 'package:tankdrum_learning/models/sound_note.dart';

import 'sound_set.dart';

class SongNote {
  int beats = 1;
  int soundIdx = -1;
  int millisecond = 0;
  bool hasLink = false;
  NoteLinkType linkType = NoteLinkType.none;
  String get soundName => SoundNote.getNoteName(soundIdx);
  SongNote(String soundNames)
      : soundIdxList =
            soundNames.split(',').map((e) => SoundNote.getNoteIdx(e)).toList();

  List<int> soundIdxList;

  Future<void> waiting(int bpm) {
    final time = Duration(milliseconds: (bpm / 60 * beats * 1000).round());
    return Future.delayed(time);
  }

  play({int tune = 0}) async {
    SoundSet.play(soundIdx + tune);
  }
}
