class NotePositionSet {
  // static List<InstrumentNote> _calculateTutPathPositions(
  //     InstrumentNote parent, int totalNotes) {
  //   int otherCount = (totalNotes / 2).ceil();
  //   bool isLandscape = parent.width > parent.height;
  //   int row = isLandscape ? 2 : otherCount;
  //   int col = isLandscape ? otherCount : 2;

  //   double sizeHolderWidth = parent.width / col;
  //   double sizeHolderHeight = parent.height / row;
  //   double sizeHolder = math.min(sizeHolderWidth, sizeHolderHeight);
  //   double size = sizeHolder * 0.8;
  //   double paddingTopBottom = (sizeHolderHeight - size) / 2;
  //   double paddingLeftRight = (sizeHolderWidth - size) / 2;

  //   final halfWidth = parent.width / 2;
  //   final halfHeight = parent.height / 2;
  //   final list = <InstrumentNote>[];
  //   int len = totalNotes;

  //   int countedNote = 0;
  //   if (isLandscape) {
  //     final height = halfHeight - (paddingTopBottom / 2);
  //     if (totalNotes % 2 == 1) {
  //       list.add(InstrumentNote(
  //           posIdx: 0,
  //           top: parent.top + height / 2,
  //           left: parent.left + paddingLeftRight,
  //           width: size,
  //           height: parent.top + (parent.height - size) / 2 + size,
  //           tutDirection: TutDirection.fromLeft,
  //           tutShape: TutShape.radius));
  //       len--;
  //       countedNote++;
  //     }

  //     for (int i = 0; i < len; i++) {
  //       final isFirstHalf = i < len / 2;
  //       final left =
  //           sizeHolder * (i % (len / 2) + countedNote) + paddingLeftRight;
  //       final width = size;
  //       double top = isFirstHalf ? 0 : halfHeight + (paddingTopBottom / 2);

  //       final direction =
  //           isFirstHalf ? TutDirection.fromTop : TutDirection.fromBottom;

  //       list.add(InstrumentNote(
  //           posIdx: i + countedNote,
  //           left: parent.left + left,
  //           width: width,
  //           top: parent.top + top,
  //           height: height,
  //           tutDirection: direction,
  //           tutShape: TutShape.radius));
  //     }
  //   } else {
  //     final width = halfWidth - paddingLeftRight / 2;
  //     if (totalNotes % 2 == 1) {
  //       list.add(InstrumentNote(
  //           posIdx: 0,
  //           top: parent.top,
  //           left: parent.left +
  //               (parent.width - (size + paddingLeftRight * 2)) / 2,
  //           width: size + paddingLeftRight * 2,
  //           height: size + paddingTopBottom,
  //           tutDirection: TutDirection.fromTop,
  //           tutShape: TutShape.radius));
  //       len--;
  //       countedNote++;
  //     }

  //     for (int i = 0; i < len; i++) {
  //       final isFirstHalf = i < len / 2;
  //       double noteLeft = isFirstHalf ? 0 : halfWidth + paddingLeftRight / 2;

  //       double top =
  //           sizeHolder * (i % (len / 2) + countedNote) + paddingTopBottom;
  //       final height = size;
  //       final direction =
  //           isFirstHalf ? TutDirection.fromTop : TutDirection.fromBottom;

  //       list.add(InstrumentNote(
  //           posIdx: i + countedNote,
  //           left: parent.left + noteLeft,
  //           width: width,
  //           top: parent.top + top,
  //           height: height,
  //           tutDirection: direction,
  //           tutShape: TutShape.radius));
  //     }
  //   }

  //   return list;
  // }

  // static List<InstrumentNote> _calculateCirclePositions(
  //     InstrumentNote parent, int totalNotes) {
  //   totalNotes = math.max(6, totalNotes);
  //   final list = <InstrumentNote>[];
  //   int len = totalNotes;
  //   final diffSize = (parent.height - parent.width).abs();
  //   final halfDiff = diffSize / 2;
  //   final minParentSize = math.min(parent.width, parent.height);

  //   List<double> calcCircleDistributePos(int totalNote, int noteOrderFrom1) {
  //     final degree = 360 / totalNote * noteOrderFrom1 + 7;
  //     final radian = -degree * math.pi / 180;
  //     final factorA = math.tan(radian);
  //     final factorB = 0.5 - 0.5 * factorA;
  //     final isSecond = totalNote / 2 < noteOrderFrom1;
  //     final a = 1 + factorA * factorA;
  //     final b = 2 * factorA * factorB - 1 - factorA;
  //     final c = factorB * factorB - factorB + 0.35;
  //     final delta = b * b - 4 * a * c;
  //     final sqrtDelta = math.sqrt(delta);
  //     double dx = 0;
  //     if (isSecond) {
  //       dx = (-b + sqrtDelta) / (2 * a);
  //     } else {
  //       dx = (-b - sqrtDelta) / (2 * a);
  //     }
  //     final dy = factorA * dx + factorB;
  //     return [dx, dy];
  //   }

  //   int reducedLen = 0;
  //   if (parent.width > parent.height) {
  //     if (len % 2 == 1) {
  //       list.add(InstrumentNote(
  //           posIdx: 0,
  //           top: parent.top + 0.35 * minParentSize,
  //           left: parent.left + halfDiff + 0.35 * minParentSize,
  //           width: 0.3 * minParentSize,
  //           height: 0.3 * minParentSize,
  //           tutDirection: TutDirection.fromCenter,
  //           tutShape: TutShape.radius));
  //       len--;
  //       reducedLen++;
  //     }
  //     double size = 0.7 * minParentSize * math.pi / len;
  //     for (int i = 0; i < len; i++) {
  //       final centerRate = calcCircleDistributePos(len, i + 1);
  //       final centerX = halfDiff + centerRate[0] * minParentSize;
  //       final centerY = centerRate[1] * minParentSize;
  //       final maxSize = NumberUt.minDouble([
  //             centerX,
  //             centerY,
  //             parent.height - centerY,
  //             parent.width - centerX
  //           ]) *
  //           2;
  //       if (size > maxSize) {
  //         size = maxSize;
  //       }
  //       final top = centerY - size / 2;
  //       final left = centerX - size / 2;
  //       list.add(InstrumentNote(
  //           posIdx: i + reducedLen,
  //           top: parent.top + top,
  //           left: parent.left + left,
  //           width: size,
  //           height: size,
  //           tutDirection: TutDirection.fromCenter,
  //           tutShape: TutShape.radius));
  //     }
  //   } else {
  //     if (len % 2 == 1) {
  //       list.add(InstrumentNote(
  //           posIdx: 0,
  //           top: parent.top + halfDiff + 0.35 * minParentSize,
  //           left: parent.left + 0.35 * minParentSize,
  //           width: 0.3 * minParentSize,
  //           height: 0.3 * minParentSize,
  //           tutDirection: TutDirection.fromCenter,
  //           tutShape: TutShape.radius));
  //       len--;
  //       reducedLen++;
  //     }
  //     for (int i = 0; i < len; i++) {
  //       final centerRate = calcCircleDistributePos(len, i + 1);
  //       final centerX = centerRate[0] * minParentSize;
  //       final centerY = halfDiff + centerRate[1] * minParentSize;
  //       final size = 0.6 * minParentSize * math.pi / len;
  //       final top = centerY - size / 2;
  //       final left = centerX - size / 2;
  //       list.add(InstrumentNote(
  //           posIdx: i + reducedLen,
  //           top: parent.top + top,
  //           left: parent.left + left,
  //           width: size,
  //           height: size,
  //           tutDirection: TutDirection.fromCenter,
  //           tutShape: TutShape.radius));
  //     }
  //   }

  //   return list;
  // }
}
