part of '../../../player.page.dart';

class _GameNoteUc extends _GameNote$Ctrl {
  List<_NoteTutUb> tuts = [];

  @override
  postConstruct() {
    final width = builder.calculator.tutSize;
    final minBottom = builder.calculator.nodeHeight;
    final minIdx = builder.idx * 10;
    for (int i = 0; i < 10; i++) {
      tuts.add(_NoteTutUb(i + minIdx, builder,
          width: width,
          minTop: minBottom,
          maxTop: -width,
          onFinishShorting: builder.game.ctrl.onTutFinishShorting,
          onTouchedUp: builder.game.ctrl.onTutTouchedUp,
          onTouchedDown: builder.game.ctrl.onTutTouchedDown));
    }
  }

  _NoteTutUb? holdingTut;
  touchDown() {
    final moment = DateTime.now().millisecondsSinceEpoch;
    state.isTouchingDown = true;
    holdingTut = tuts.firstWhereOrNull((tut) => tut.state.isRunning);
    if (holdingTut != null) {
      holdingTut!.touchDown(moment);
    }
  }

  touchUp() {
    state.isTouchingDown = false;
    holdingTut?.touchUp();
  }

  trigger(SNote note, Function(_NoteTutUb) callback) {
    tuts.add(tuts.removeAt(0)..trigger(note, callback));
  }
}
