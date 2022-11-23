part of '../../../../player.page.dart';

@Ui_(
  isSingle: true,
  state: [
    SF_<bool>(name: 'isRunning'),
    SF_<bool>(name: 'isTouching'),
    SF_<bool>(name: 'isShorting'),
  ],
)
class _NoteTutUb extends _NoteTut$Ub {
  _NoteTutUb(
    this.index,
    this.gameNote, {
    required this.width,
    required this.maxTop,
    required this.minTop,
    required this.onTouchedDown,
    required this.onTouchedUp,
    required this.onFinishShorting,
  });

  _GameNoteUb gameNote;
  int index;
  double width;
  double maxTop;
  double minTop;
  Function(_NoteTutUb) onTouchedDown;
  Function(_NoteTutUb) onTouchedUp;
  Function(_NoteTutUb) onFinishShorting;
  int milliseconds = 0;

  GameCalculator get calculator => gameNote.game.ctrl.calculator;

  late SongNote note;
  trigger(SongNote note, Function(_NoteTutUb) callback) {
    this.note = note;
    milliseconds = note.milliseconds;
    state.isRunning = true;
    callback(this);
  }

  bool get isLongNote {
    return milliseconds > 0;
  }

  bool isPointed = false;
  reset() {
    state.isShorting = false;
    milliseconds = 0;
    state.isTouching = false;
    state.isRunning = false;
    isPointed = false;
  }

  int touchedDownMoment = 0;
  touchDown(int moment) {
    touchedDownMoment = moment;
    if (state.isRunning) {
      state.isTouching = true;
      onTouchedDown(this);
    }
  }

  touchUp() {
    state.isTouching = false;
    onTouchedUp(this);
  }

  playThenReset() {
    note.play();
    reset();
  }

  short() {
    if (!state.isShorting && isLongNote) {
      state.isShorting = true;
      Future.delayed(Duration(milliseconds: milliseconds)).then(
        (value) {
          onFinishShorting(this);
          reset();
        },
      );
    }
  }

  double get shortNoteBottomEnd {
    return -calculator.tutSize - calculator.tutPadding + calculator.nodePadding;
  }

  double get longNoteBottomEnd {
    return calculator.nodeHeight / 2 -
        calculator.tutSize / 2 -
        calculator.tutPadding +
        calculator.nodePadding;
  }

  double get bottomStart {
    return calculator.nodeHeight -
        calculator.tutPadding +
        calculator.nodePadding;
    // return calculator.minPoint;
  }

  Duration get catchDuration {
    return state.isShorting
        ? const Duration(days: 100)
        : state.isRunning
            ? isLongNote
                ? calculator.halfRunDuration
                : calculator.runDuration
            : Duration.zero;
  }

  @override
  Widget build() {
    return Obx(() => AnimatedPositioned(
        bottom: !state.isRunning
            ? bottomStart
            : isLongNote
                ? longNoteBottomEnd
                : shortNoteBottomEnd,
        width: calculator.catcherSize,
        height: calculator.tutPathLong,
        left: 0,
        duration: catchDuration,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.all(calculator.tutPadding),
              child: Obx(() => AnimatedContainer(
                    duration: state.isShorting
                        ? Duration(milliseconds: milliseconds)
                        : Duration.zero,
                    width: calculator.tutSize,
                    height: !isLongNote || state.isShorting
                        ? calculator.tutSize
                        : calculator.tutSize * 4,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 159, 209, 142),
                        borderRadius: BorderRadius.circular(100),
                        border: isLongNote
                            ? null
                            : Border.all(
                                color: const Color.fromARGB(255, 84, 130, 53),
                                width: 3)),
                  )),
            ),
          ],
        )));
  }
}
