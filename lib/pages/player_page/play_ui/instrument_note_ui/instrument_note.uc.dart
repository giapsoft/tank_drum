part of '../../player.page.dart';

class _InstrumentNoteUc extends _InstrumentNote$Ctrl {
  @override
  postConstruct() {
    state.note$.listen((p0) {
      if (p0.width > 0) {
        builder.instrumentUc.soundIdxToNoteUb[builder.currentSoundIdx] =
            builder;
      }
    });
  }

  Color? getColor(bool isActive, bool isWaiter) {
    return (isActive && isWaiter)
        ? const Color.fromARGB(255, 112, 7, 7)
        : isActive
            ? const Color.fromARGB(255, 255, 39, 39)
            : isWaiter
                ? const Color.fromARGB(255, 255, 81, 81)
                : null;
  }

  play() async {
    SoundSet.play(builder.currentSoundIdx);
  }

  active() {
    state.isActive = true;
  }

  inactive() {
    state.isActive = false;
  }

  wait() {
    state.isWait = true;
  }

  unwait() {
    state.isWait = false;
  }

  triggerTut() {}

  bool _inBody = false;
  swipe(Offset pos) {
    if (isInBody(pos)) {
      if (!_inBody) {
        _inBody = true;
        Future.delayed(const Duration(milliseconds: 500)).then((_) {
          _inBody = false;
        });
        doSwipedIn();
      }
    } else if (isInBorder(pos)) {
      _inBody = false;
    }
  }

  doSwipedIn() {
    builder.innerNote.trigger();
  }

  double borderWidth = 30;

  double get topWidthInset => state.note.top + builder.instrumentUc.top;
  double get leftWithInset => builder.left + builder.instrumentUc.left;

  bool isInBorder(Offset pos) {
    return topWidthInset - borderWidth < pos.dy &&
        leftWithInset - borderWidth < pos.dx &&
        topWidthInset + builder.height + borderWidth * 2 > pos.dy &&
        leftWithInset + builder.width + borderWidth * 2 > pos.dx;
  }

  bool isInBody(Offset pos) {
    return topWidthInset < pos.dy &&
        leftWithInset < pos.dx &&
        topWidthInset + builder.height > pos.dy &&
        leftWithInset + builder.width > pos.dx;
  }

  void updateNote([InstrumentNote? note]) {
    state.note = note ?? InstrumentNote(top: 1, left: 0.5);
  }
}
