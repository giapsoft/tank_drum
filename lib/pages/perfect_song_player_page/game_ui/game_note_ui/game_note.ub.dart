part of '../../perfect_song_player.page.dart';

@Ui_(isSingle: true, state: [
  SF_<bool>(name: 'isTouchingDown'),
])
class _GameNoteUb extends _GameNote$Ub {
  _GameNoteUb(this.idx, this.game);

  int idx;
  final _GameUb game;

  _GameCalculator get calculator => game.ctrl.calculator;

  buildCatcherBtn() {
    return Positioned(
      top: calculator.catcherTop,
      width: calculator.catcherSize,
      height: calculator.catcherSize,
      child: Obx(() => AnimatedPadding(
            duration: state.isTouchingDown
                ? Duration.zero
                : const Duration(milliseconds: 100),
            padding: state.isTouchingDown
                ? EdgeInsets.all(calculator.tutPadding)
                : const EdgeInsets.all(0.0),
            child: Container(
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 242, 204),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                      width: 1, color: const Color.fromARGB(255, 197, 89, 17))),
            ),
          )),
    );
  }

  @override
  Widget build() {
    return Listener(
        onPointerDown: (e) {
          ctrl.touchDown();
        },
        onPointerUp: (e) {
          ctrl.touchUp();
        },
        child: Stack(children: [
          buildBackground(),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: calculator.catcherPadding),
            child: RepaintBoundary(
              child: Stack(
                children: [
                  buildCatcherBtn(),
                  ...ctrl.tuts.map((t) => t.ui),
                ],
              ),
            ),
          )
        ]));
  }

  buildDebugNoteBound() {
    return Center(
      child: Container(
          height: calculator.nodeHeight,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 242, 204),
            border: Border.all(
                width: 0.5, color: const Color.fromARGB(255, 244, 177, 131)),
          )),
    );
  }

  buildBackground() {
    return Container(
        decoration: BoxDecoration(
      color: const Color.fromARGB(255, 255, 242, 204),
      border: Border.all(
          width: 0.5, color: const Color.fromARGB(255, 244, 177, 131)),
    ));
  }
}
