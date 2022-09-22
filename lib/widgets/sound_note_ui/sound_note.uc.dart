part of 'sound_note.ub.dart';

class _SoundNoteUc extends _SoundNote$Ctrl {
  late Function() animationTrigger;

  setAnimationTrigger(Function() trigger) {
    animationTrigger = trigger;
  }

  play() async {
    SoundSet.playSound(builder.soundName);
    animationTrigger();
    if (builder.onTouchPlay != null) {
      builder.onTouchPlay!();
    }
  }
}
