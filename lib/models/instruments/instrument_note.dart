class InstrumentNote {
  double top;
  double left;
  double width;
  double height;
  double angle;
  int posIdx;
  int deltaSoundIdx;
  String deltaName;

  InstrumentNote({
    this.posIdx = 0,
    this.top = 0,
    this.left = 0,
    this.width = 0,
    this.height = 0,
    this.deltaSoundIdx = -1,
    this.angle = 0,
    this.deltaName = '',
  });

  @override
  String toString() {
    return 'postIdx: $posIdx, delta: $deltaSoundIdx, top:$top, left:$left, width: $width, height: $height';
  }
}
