import 'package:tankdrum_learning/models/note_link_type.dart';

import 'sound_set.dart';

class SongNote {
  int beats = 1;
  String soundName;
  int millisecond = 0;
  NoteLinkType linkType = NoteLinkType.none;

  SongNote(this.soundName);

  Future<void> waiting(int bpm) {
    final time = Duration(milliseconds: (bpm / 60 * beats * 1000).round());
    return Future.delayed(time);
  }

  playSound() async {
    SoundSet.playSound(soundName);
  }
}
