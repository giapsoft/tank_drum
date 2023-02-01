part of '../../perfect_song_player.page.dart';

@Ui_(isSingle: true, state: [
  SF_<String>(name: 'state', init: 'free'),
  SF_<String>(name: 'lyric'),
  SF_<bool>(name: 'isActive'),
])
class _LyricsUb extends _Lyrics$Ub {
  SilenceNode note = SilenceNode();
  static const free = 'free';
  static const start = 'start';
  static const outstanding = 'outstanding';
  static const end = 'end';
  static const allState = [free, start, outstanding, end];
  int idx;
  _LyricsUb(this.idx, this.onFree);
  Function(_LyricsUb) onFree;

  int triggerMoment = 0;

  setNote(SilenceNode songNote) {
    note = songNote;
    state.isActive = true;
    state.state = start;
    state.lyric = note.text.orElse('');
    final now = DateTime.now().millisecondsSinceEpoch;
    final delta = now - triggerMoment;
    Future.delayed(
            Duration(milliseconds: note.start.orElse(0) - delta + 1000 - 100))
        .then((value) => state.state = outstanding);
  }

  reset() {
    note = SilenceNode();
    state.state = free;
    state.lyric = '';
    state.isActive = false;
  }

  double get fontSize {
    return [13.0, 13.0, 20.0, 30.0][currentStateIdx];
  }

  int get milliseconds {
    return [
      100,
      500,
      500,
      note.duration.orElse(0) + 1000
    ][allState.indexOf(state.state)];
  }

  double get opacity {
    return [0, 1, 0.99, 0.001][currentStateIdx].toDouble();
  }

  FontWeight get fontWeight {
    return [
      FontWeight.normal,
      FontWeight.normal,
      FontWeight.w900,
      FontWeight.normal
    ][allState.indexOf(state.state)];
  }

  Offset get offset {
    return [
      Offset.zero,
      Offset.zero,
      const Offset(0, -0.6),
      const Offset(0, -1)
    ][currentStateIdx];
  }

  int get currentStateIdx => allState.indexOf(state.state);

  Color get color {
    return [
      Colors.green.shade200,
      Colors.green,
      Colors.orange,
      Colors.redAccent
    ][currentStateIdx];
  }

  bool isFree() {
    return state.state == free;
  }

  get curve => Curves.easeInOutBack;

  @override
  Widget build() {
    return Obx(
      () => !state.isActive
          ? const SizedBox()
          : AnimatedSlide(
              curve: curve,
              offset: offset,
              duration: Duration(milliseconds: milliseconds),
              child: Obx(() => AnimatedOpacity(
                  curve: curve,
                  opacity: opacity,
                  duration: Duration(milliseconds: milliseconds),
                  onEnd: () {
                    if (state.state == end) {
                      state.state = free;
                      onFree(this);
                    } else if (state.state == outstanding) {
                      state.state = end;
                    }
                  },
                  child: Obx(
                    () => FittedBox(
                      child: AnimatedDefaultTextStyle(
                          curve: curve,
                          maxLines: 1,
                          style: TextStyle(
                              overflow: TextOverflow.visible,
                              fontSize: 16,
                              fontWeight: fontWeight,
                              color: color),
                          duration: Duration(milliseconds: milliseconds),
                          child: Obx(() => Text(state.lyric))),
                    ),
                  ))),
            ),
    );
  }
}
