// ignore_for_file: library_private_types_in_public_api

part of '../../player.page.dart';

@Ui_(
  isSingle: true,
  state: [
    SF_<InstrumentNote>(name: 'note'),
    SF_<int>(name: 'tune'),
    SF_<bool>(name: 'isActive'),
    SF_<bool>(name: 'isWait'),
    SF_<bool>(name: 'isPointerIn')
  ],
)
class _InstrumentNoteUb extends _InstrumentNote$Ub {
  _InstrumentNoteUb(this.instrumentUc,
      {required this.onTouchPlay, required this.onHold});
  final _InstrumentUc instrumentUc;
  final Function(_InstrumentNoteUb) onTouchPlay;
  final Function(_InstrumentNoteUb) onHold;

  int get currentSoundIdx =>
      state.tune +
      state.note.deltaSoundIdx +
      instrumentUc.playState.tune +
      instrumentUc.instrument.startCycleIdx;
  void tuneTo(int soundIdx) {
    state.tune = soundIdx -
        state.note.deltaSoundIdx -
        instrumentUc.playState.tune -
        instrumentUc.instrument.startCycleIdx;
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
          child: buildRotatePart(),
        ));
  }

  buildRotatePart() {
    return AnimatedRotation(
      duration: moveDuration,
      curve: Curves.fastOutSlowIn,
      turns: state.note.angle / 360,
      child: buildMovePart(),
    );
  }

  buildMovePart() {
    final outerNote = AnimatedContainer(
      duration: moveDuration,
      child: Obx(() => Container(
          decoration: instrumentUc.instrument.buildDecoration(state.note,
              color: ctrl.getColor(state.isActive, state.isWait)),
          child: instrumentUc.instrument
              .buildInnerNote(state.note$, currentSoundIdx))),
    );
    return buildStaticPart(outerNote);
  }

  buildStaticPart(Widget child) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Obx(() => SizedBox(
                width: constraints.maxWidth * (state.isPointerIn ? 0.9 : 1),
                height: constraints.maxHeight * (state.isPointerIn ? 0.9 : 1),
                child: child,
              ));
        },
      ),
    );
  }
}
