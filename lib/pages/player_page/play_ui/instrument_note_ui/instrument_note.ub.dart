// ignore_for_file: library_private_types_in_public_api

part of '../../player.page.dart';

@Ui_(
  isSingle: true,
  state: [
    SF_<InstrumentNote>(name: 'note'),
    SF_<int>(name: 'tune'),
    SF_<bool>(name: 'isActive'),
    SF_<bool>(name: 'isWait'),
  ],
)
class _InstrumentNoteUb extends _InstrumentNote$Ub {
  _InstrumentNoteUb(this.instrumentUc, {required this.onTouchPlay});
  final _InstrumentUc instrumentUc;
  final Function() onTouchPlay;

  int get currentSoundIdx =>
      state.tune + state.note.deltaSoundIdx + instrumentUc.playState.tune;
  void tuneTo(int soundSet) {
    state.tune =
        soundSet - state.note.deltaSoundIdx - instrumentUc.playState.tune;
  }

  double get top => instrumentUc.getTop(state.note.top);
  double get left => instrumentUc.getLeft(state.note.left);
  double get width => instrumentUc.getWidth(state.note.width);
  double get height => instrumentUc.getHeight(state.note.height);

  static const moveDuration = Duration(seconds: 1);

  @override
  Widget build() {
    return Obx(() => AnimatedPositioned(
          duration: moveDuration,
          curve: Curves.fastLinearToSlowEaseIn,
          top: top,
          left: left,
          width: width,
          height: height,
          child: buildAnimationRotateChild(),
        ));
  }

  buildAnimationRotateChild() {
    return AnimatedRotation(
      duration: moveDuration,
      curve: Curves.fastOutSlowIn,
      turns: state.note.angle / 360,
      child: buildInnerNote(),
    );
  }

  buildInnerNote() {
    return BounceButton(
        AnimatedContainer(
          duration: moveDuration,
          decoration: instrumentUc.instrument.buildDecoration(state.note,
              color: ctrl.getColor(state.isActive, state.isWait)),
          child: const Center(child: SizedBox()),
        ),
        onTrigger: onTouchPlay);
  }
}
