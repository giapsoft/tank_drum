import 'sound_note.dart';
import 'sound_set.dart';

class SongNote {
  int beats = 1;
  int milliseconds = 0;
  SongNote(String soundNames, [this.beats = 1])
      : soundIdxList =
            soundNames.split(',').map((e) => SoundNote.getNoteIdx(e)).toList();

  List<int> soundIdxList;

  Future<void> waitBpm(int bpm) {
    final time = Duration(milliseconds: (bpm / 60 * beats * 1000).round());
    return Future.delayed(time);
  }

  Future<void> wait() {
    return Future.delayed(Duration(milliseconds: milliseconds));
  }

  play({int tune = 0}) async {
    for (var idx in soundIdxList) {
      SoundSet.play(idx + tune);
    }
  }
}
