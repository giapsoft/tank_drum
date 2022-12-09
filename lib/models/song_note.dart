import 'package:tankdrum_learning/models/au_player.dart';

import 'sound_note.dart';
import 'sound_set.dart';

class SNote {
  int beats = 1;
  int milliseconds = 0;
  int startPoint = 0;
  String name = '';
  SNote(String soundNames, [this.beats = 1])
      : soundIdxList =
            soundNames.split(',').map((e) => SoundNote.getNoteIdx(e)).toList();
  List<int> soundIdxList = [];

  SNote.timed({
    this.name = '',
    this.milliseconds = 0,
    this.startPoint = 0,
  });

  Future<void> wait([int? bpm]) {
    if (milliseconds == 0 && bpm != null) {
      final time = Duration(milliseconds: (60 * beats * 1000 / bpm).round());
      return Future.delayed(time);
    }
    return Future.delayed(Duration(milliseconds: milliseconds));
  }

  play({int tune = 0}) async {
    if (milliseconds > 0) {
      if (name.isNotEmpty) {
        AuPlayer.playLocal(name);
      } else {
        ting();
      }
    } else {
      for (var idx in soundIdxList) {
        SoundSet.play(idx + tune);
      }
    }
  }

  ting() {
    // AuPlayer.playLocal('action_sounds/ting.mp3');
  }
}
