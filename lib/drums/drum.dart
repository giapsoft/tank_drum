import 'package:tankdrum_learning/drums/drum_note/drum_note.dart';
import 'package:tankdrum_learning/drums/tank_15n_drum.dart';

mixin Drum {
  static Drum playingDrum = Tank15NDrum();

  List<DrumNote> get drumNotes;

  void rebuildNotes() {
    for (var element in drumNotes) {
      element.rebuild();
    }
  }
}
