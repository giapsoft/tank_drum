part of '../../player.page.dart';

class _InstrumentNoteUc extends _InstrumentNote$Ctrl {
  Color? getColor(bool isActive, bool isWaiter) {
    return (isActive && isWaiter)
        ? const Color.fromARGB(255, 112, 7, 7)
        : isActive
            ? const Color.fromARGB(255, 250, 6, 6)
            : isWaiter
                ? const Color.fromARGB(255, 255, 145, 0)
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

  queue() {
    state.isWait = true;
  }

  deque() {
    state.isWait = false;
  }

  triggerTut() {}

  double lastTouchedTop = 0;
  bool isHolding = false;

  doSwipedIn([Offset? pos]) {
    if (state.isPointerIn) {
      if (!isHolding && pos != null && lastTouchedTop - pos.dy > 10) {
        isHolding = true;
        holding();
      }
    } else {
      if (pos != null && lastTouchedTop <= 0) {
        lastTouchedTop = pos.dy;
      }
      state.isPointerIn = true;
      builder.onTouchPlay(builder);
    }
  }

  doSwipedOut() {
    isHolding = false;
    lastTouchedTop = 0;
    state.isPointerIn = false;
  }

  holding() {
    if (state.isPointerIn) {
      Future.delayed(const Duration(milliseconds: 100)).then((value) {
        if (state.isPointerIn) {
          builder.onHold(builder);
          holding();
        }
      });
    }
  }

  double borderBy = 30;

  double get topWidthInset => builder.top + builder.instrumentUc.top;
  double get leftWithInset => builder.left + builder.instrumentUc.left;

  bool isInBorder(Offset pos) {
    if (state.note.angle != 0) {
      return convertNote(pos, (dx, dy) => _isInBorder(dx, dy));
    }
    return _isInBorder(pos.dx, pos.dy);
  }

  bool _isInBorder(double dx, double dy) {
    isInBorderTop() =>
        topWidthInset > dy &&
        topWidthInset - borderBy < dy &&
        leftWithInset - borderBy < dx &&
        leftWithInset + builder.width + borderBy > dx;
    isInBorderBottom() =>
        topWidthInset + builder.height < dy &&
        topWidthInset + builder.height + borderBy > dy &&
        leftWithInset - borderBy < dx &&
        leftWithInset + builder.width + borderBy > dx;
    isInBorderLeft() =>
        topWidthInset - borderBy < dy &&
        topWidthInset + builder.height + borderBy > dy &&
        leftWithInset - borderBy < dx &&
        leftWithInset > dx;
    isInBorderRight() =>
        topWidthInset - borderBy < dy &&
        topWidthInset + builder.height + borderBy > dy &&
        leftWithInset + builder.width < dx &&
        leftWithInset + builder.width + borderBy > dx;

    return isInBorderTop() ||
        isInBorderLeft() ||
        isInBorderRight() ||
        isInBorderBottom();
  }

  convertNote(Offset pos, bool Function(double, double) action) {
    final b = topWidthInset + builder.height / 2;
    final a = leftWithInset + builder.width / 2;
    return MathUtils.baiToan1(
      a: a,
      b: b,
      a2: pos.dx,
      b2: pos.dy,
      degree: state.note.angle,
    ).any((convertedPos) => action(convertedPos[0], convertedPos[1]));
  }

  bool isInBody(Offset pos) {
    if (state.note.angle != 0) {
      return convertNote(pos, (dx, dy) => _isInBody(dx, dy));
    }
    return _isInBody(pos.dx, pos.dy);
  }

  _isInBody(double dx, double dy) {
    return topWidthInset < dy &&
        leftWithInset < dx &&
        topWidthInset + builder.height > dy &&
        leftWithInset + builder.width > dx;
  }

  bool isIn(Offset pos) {
    return isInBody(pos) || isInBorder(pos);
  }

  void updateNote([InstrumentNote? note]) {
    state.note = note ?? InstrumentNote(top: 1, left: 0.5);
  }
}
