import 'dart:math';

import 'package:flutter/widgets.dart';

class GameCalculator {
  int runMilliseconds = 2000;
  int get halfRunMilliseconds => runMilliseconds ~/ 2;
  Duration get runDuration => Duration(milliseconds: runMilliseconds);
  Duration get halfRunDuration => Duration(milliseconds: halfRunMilliseconds);

  double maxCatcherWidth = 80;

  double tutPadding = 8.0;
  double tutPathRate = 0.5;

  double catcherBottom = 0;
  double catcherTop = 0;
  double catcherSize = 0;
  double tutPathLong = 0;
  double nodeHeight = 0;
  double nodePadding = 0;
  double get tutSpeed =>
      tutPathLong == 0 ? 0 : halfRunMilliseconds / (tutPathLong * 4);
  double minPointRate = 0;
  double maxPointRate = 0;
  double get avgPointRate => (maxPointRate + minPointRate) / 2;
  int triggerMoment = 0;
  double tutSize = 0;

  onTutOverTime(callback) {
    Future.delayed(
            Duration(milliseconds: (maxPointRate * runMilliseconds).ceil()))
        .then((value) {
      callback();
    });
  }

  double catcherPadding = 0.0;
  double centerPoint = 0;
  double nodeWidth = 0;
  double maxPoint = 0;
  double minPoint = 0;
  late BoxConstraints constraints;
  void updateGameNoteConstraints(BoxConstraints constraints, int totalNote) {
    this.constraints = constraints;
    updateGameNote(totalNote);
  }

  updateGameNote(int totalNote) {
    nodeWidth = constraints.maxWidth / totalNote;
    nodeHeight = constraints.maxHeight - nodePadding * 2;

    catcherPadding = max(0, (nodeWidth - maxCatcherWidth) / 2);
    catcherSize = nodeWidth - 2 * catcherPadding;
    catcherTop = (nodeHeight - catcherSize) / 2 + nodePadding;
    catcherBottom = (nodeHeight + catcherSize) / 2;
    tutSize = catcherSize - 2 * tutPadding;

    tutPathLong = nodeHeight + tutSize + tutPadding * 2 - 2 * nodePadding;

    centerPoint = (nodeHeight - tutSize) / 2 - tutPadding + nodePadding;
    maxPoint = centerPoint + tutSize + tutPadding;
    final maxTime =
        (nodeHeight + catcherSize) / 2 + tutSize + tutPadding - nodePadding;
    maxPointRate = maxTime / tutPathLong;
    minPoint = centerPoint - catcherSize - tutPadding;
    final minTime = (nodeHeight - catcherSize) / 2 + tutPadding;
    minPointRate = minTime / tutPathLong;
  }

  int calcTutPoint(int touchedDownMoment, int startPoint) {
    final perfectMoment = triggerMoment + startPoint;
    final deltaMoment = (touchedDownMoment - perfectMoment).abs();
    final runnedRate = deltaMoment / runMilliseconds;
    // print(
    //     'deltaMoment: $deltaMoment, runnedRate: $runnedRate, minPointRate: $minPointRate, maxPointRate: $maxPointRate, avgPointRate: $avgPointRate');
    int point = 0;
    if (runnedRate < minPointRate || runnedRate > maxPointRate) {
      point = 0;
    } else {
      final deltaRate = (runnedRate - avgPointRate).abs();
      final rate = deltaRate / (maxPointRate - avgPointRate) * 100;
      if (rate > 60) {
        point = 1;
      } else if (rate > 16) {
        point = 2;
      } else {
        point = 3;
      }
    }
    return point;
  }

  Duration delayNote(int startPoint) {
    return Duration(
        milliseconds:
            startPoint + triggerMoment - DateTime.now().millisecondsSinceEpoch);
  }
}
