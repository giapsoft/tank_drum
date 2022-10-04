part of 'sound_note.ub.dart';

class _SoundNoteUc extends _SoundNote$Ctrl {
  late Function() animationTrigger;

  setAnimationTrigger(Function() trigger) {
    animationTrigger = trigger;
  }

  DateTime lastPlayed = DateTime.now();
  play() async {
    if (DateTime.now().difference(lastPlayed).inMilliseconds > 80) {
      SoundSet.play(builder.soundIdx);
      animationTrigger();
      if (builder.onTouchPlay != null) {
        builder.onTouchPlay!();
      }
      lastPlayed = DateTime.now();
    }
  }
}
