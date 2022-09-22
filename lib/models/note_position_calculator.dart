import 'dart:math' as math;
import 'dart:ui';

import 'package:get/get.dart';

enum TutDirection { fromLeft, fromRight, fromTop }

class NotePosition {
  final double top;
  final double left;
  final double size;
  final TutDirection direction;
  NotePosition(this.top, this.left, this.size, this.direction);

  NotePosition? _firstTutPos;
  NotePosition get firstTutPos {
    return _firstTutPos ??= NotePosition(
        tutPathTop!,
        direction == TutDirection.fromRight
            ? left + tutPathWidth! - size
            : tutPathLeft!,
        size,
        direction);
  }

  double borderWidth = 20;

  bool isInBorder(Offset pos) {
    return top - borderWidth < pos.dy &&
        left - borderWidth < pos.dx &&
        top + size + borderWidth * 2 > pos.dy &&
        left + size + borderWidth * 2 > pos.dx;
  }

  bool isInBody(Offset pos) {
    return top < pos.dy &&
        left < pos.dx &&
        top + size > pos.dy &&
        left + size > pos.dx;
  }

  double? get tutPathTop {
    if (direction == TutDirection.fromTop) {
      return -size;
    }
    return top;
  }

  double? get tutPathLeft {
    if ([TutDirection.fromTop, TutDirection.fromRight].contains(direction)) {
      return left;
    }

    return -(tutPathWidth! - left - size);
  }

  double? get tutPathWidth {
    if (direction == TutDirection.fromTop) {
      return size;
    }
    return Get.width / 2 + size;
  }

  double? get tutPathHeight {
    if (direction == TutDirection.fromTop) {
      return top + 2 * size;
    }
    return size;
  }
}

class NotePositionCalculator {
  final int totalNotes;
  static final Map<int, NotePositionCalculator> _calculated = {};

  static NotePositionCalculator of(int noteLength) =>
      _calculated[noteLength] ??= NotePositionCalculator(noteLength);

  static clear() {
    _calculated.clear();
  }

  NotePositionCalculator(this.totalNotes);
  List<NotePosition>? _pos;
  List<NotePosition> get pos => _pos ??= _calcPos();

  List<NotePosition> _calcPos() {
    double minSize = math.min(Get.width, Get.height);
    double currentTop = 0.2 * Get.height;
    final bigSize = 0.2 * minSize;

    final halfWidth = 0.5 * minSize;

    final list = <NotePosition>[];
    int len = totalNotes;
    if (totalNotes % 2 == 1) {
      list.add(NotePosition(
          currentTop, halfWidth - bigSize / 2, bigSize, TutDirection.fromTop));
      currentTop += bigSize;
      len--;
    }

    final remainHeight = Get.height - currentTop;
    final holderUnit = remainHeight / (len / 2);

    final normalSize = holderUnit * 0.9;
    final gap = math.max(holderUnit - normalSize, 0);

    for (int i = 0; i < len; i++) {
      final isFirstHalf = i < len / 2;
      final left = isFirstHalf
          ? halfWidth - normalSize - (gap * 2)
          : halfWidth + (gap * 2);
      final topFactor = isFirstHalf ? i : i - len / 2;
      final direction =
          isFirstHalf ? TutDirection.fromLeft : TutDirection.fromRight;

      list.add(NotePosition(
          currentTop + holderUnit * topFactor, left, normalSize, direction));
    }
    return list;
  }

  List<NotePosition> _calculateCircle() {
    final list = <NotePosition>[];
    int len = totalNotes;
    if (len % 2 == 1) {
      list.add(NotePosition(0.35, 0.35, 0.3, TutDirection.fromLeft));
      len--;
    }

    List<double> calcCircleDistributePos(int totalNote, int seq) {
      final degree = 360 / totalNote * seq + 7;
      final radian = -degree * math.pi / 180;
      final factorA = math.tan(radian);
      final factorB = 0.5 - 0.5 * factorA;
      final isSecond = totalNote / 2 < seq;
      final a = 1 + factorA * factorA;
      final b = 2 * factorA * factorB - 1 - factorA;
      final c = factorB * factorB - factorB + 0.35;
      final delta = b * b - 4 * a * c;
      final sqrtDelta = math.sqrt(delta);
      double dx = 0;
      if (isSecond) {
        dx = (-b + sqrtDelta) / (2 * a);
      } else {
        dx = (-b - sqrtDelta) / (2 * a);
      }
      final dy = factorA * dx + factorB;
      return [dx, dy];
    }

    for (int i = 0; i < len; i++) {
      final pos = calcCircleDistributePos(len, i + 1);
      list.add(NotePosition(
          pos[1] - 0.07, pos[0] - 0.07, 0.14, TutDirection.fromLeft));
    }
    return list;
  }
}
