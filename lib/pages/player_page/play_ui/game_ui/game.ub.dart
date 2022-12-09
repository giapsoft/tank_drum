part of '../../player.page.dart';

@Ui_(state: [
  SF_<bool>(name: 'isPlaying'),
  SF_<bool>(name: 'isAuto'),
  SF_<int>(name: 'bpm', init: 130),
  SF_<int>(name: 'totalGameNote', init: 4),
  SF_<int>(name: 'currentPoint'),
  SF_<bool>(name: 'newPoint'),
  SF_<int>(name: 'totalPoint'),
  SF_<int>(name: 'runDuration', init: 2000),
  SF_<bool>(name: 'isDisplayLyrics'),
])
class _GameUb extends _Game$Ub {
  double maxWidth = 0;
  double maxHeight = 0;
  double get noteWidth => maxWidth / state.totalGameNote;
  @override
  Widget build() {
    return LayoutBuilder(builder: (context, constraints) {
      maxWidth = constraints.maxWidth;
      maxHeight = constraints.maxHeight;
      ctrl.calculator
          .updateGameNoteConstraints(constraints, state.totalGameNote);
      return Stack(
        children: [
          buildGameNoteStack(),
          buildCurrentPoint(),
          buildLyrics(),
          buildTopPanel(),
          buildBottomPanel(),
          buildStartGamePanel(),
        ],
      );
    });
  }

  buildLyrics() {
    return Obx(() => !state.isDisplayLyrics
        ? const SizedBox()
        : Positioned(
            height: 64,
            width: maxWidth,
            left: 0,
            top: ctrl.calculator.catcherBottom,
            child: Container(
              alignment: AlignmentDirectional.bottomCenter,
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              color: Colors.green.shade100,
              child: RepaintBoundary(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: ctrl.lyricStages
                      .map((e) => SizedBox(
                          width: (maxWidth - 16) / ctrl.lyricStages.length,
                          height: 28,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: e.ui,
                          )))
                      .toList(),
                ),
              ),
            )));
  }

  buildGameNoteStack() {
    buildNote(_GameNoteUb gameNote, int i) {
      return Positioned(
          top: 0,
          left: noteWidth * i,
          width: noteWidth,
          height: maxHeight,
          child: gameNote.ui);
    }

    return Obx(() {
      ctrl.prepareGameNotes();
      return LayoutBuilder(builder: (context, constraints) {
        return Stack(
          children: [
            ...ctrl.gameNotes.map((e) => buildNote(e, e.idx)),
          ],
        );
      });
    });
  }

  Widget buildCurrentPoint() {
    return Positioned(
        top: 180,
        width: Get.width,
        height: 100,
        left: 0,
        child: RepaintBoundary(
          child: Center(
              child: Obx(() => AnimatedContainer(
                  curve: Curves.fastOutSlowIn,
                  duration: !state.newPoint
                      ? const Duration(seconds: 2)
                      : const Duration(milliseconds: 100),
                  onEnd: () => state.newPoint = false,
                  width: state.newPoint ? 200 : 0,
                  height: state.newPoint ? 80 : 0,
                  child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        ctrl.currentPointName(),
                        style: TextStyle(color: ctrl.currentPointColor()),
                      ))))),
        ));
  }

  Widget setGameNotes() {
    return SizedBox(
      width: 300,
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Row(
          children: [
            Obx(() => Text(state.totalGameNote.toString())),
            Obx(() => Slider(
                value: state.totalGameNote.toDouble(),
                divisions: 7,
                min: 2,
                max: 8,
                onChanged: ((value) {
                  ctrl.calculator.updateGameNote(value.toInt());
                  state.totalGameNote = value.toInt();
                })))
          ],
        ),
      ),
    );
  }

  Widget bpm() {
    return SizedBox(
      width: 300,
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Row(
          children: [
            Obx(() => Text(state.bpm.toString())),
            Obx(() => Slider(
                value: state.bpm.toDouble(),
                divisions: 241,
                min: 60,
                max: 300,
                onChanged: ((value) => state.bpm = value.toInt())))
          ],
        ),
      ),
    );
  }

  pointCounter() {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => Text(ctrl.pointSummary)));
  }

  buildBottomPanel() {
    bottomPanel() {
      return Obx(() => state.isPlaying
          ? Wrap(children: [])
          : const SizedBox(
              width: 0,
              height: 0,
            ));
    }

    return Positioned(
      bottom: 0,
      left: 0,
      width: maxWidth,
      height: 200,
      child: Obx(() => state.isPlaying
          ? Wrap(children: [bottomPanel()])
          : const SizedBox(
              width: 0,
              height: 0,
            )),
    );
  }

  autoBtn() {
    return TextButton(
      onPressed: () {
        state.isAuto = !state.isAuto;
      },
      child: Obx(() => Text(state.isAuto ? 'Auto-ON' : 'Auto-OFF')),
    );
  }

  lyricBtn() {
    return TextButton(
      onPressed: () {
        state.isDisplayLyrics = !state.isDisplayLyrics;
      },
      child:
          Obx(() => Text(state.isDisplayLyrics ? 'Lyrics-ON' : 'Lyrics-OFF')),
    );
  }

  buildTopPanel() {
    topPanel() {
      return Wrap(children: [stopBtn(), pointCounter(), autoBtn()]);
    }

    return Positioned(
      top: 0,
      left: 0,
      width: maxWidth,
      height: 160,
      child: RepaintBoundary(
        child: Obx(() => state.isPlaying
            ? Wrap(children: [topPanel()])
            : const SizedBox(
                width: 0,
                height: 0,
              )),
      ),
    );
  }

  backBtn() {
    return IconButton(
        onPressed: () {
          ctrl.back();
        },
        icon: const Icon(Icons.arrow_back));
  }

  stopBtn() {
    return IconButton(
        onPressed: () {
          ctrl.stop();
        },
        icon: const Icon(Icons.stop));
  }

  buildStartGamePanel() {
    playBtn() {
      return TextButton(
          onPressed: () {
            ctrl.play();
          },
          child: const Text('play'));
    }

    gameRunningDuration() {
      return Obx(() => Slider(
          value: state.runDuration / 1000,
          divisions: 64,
          min: 1,
          max: 63,
          label: state.runDuration.toString(),
          onChanged: ((value) {
            final milli = 1000 * value.toInt();
            ctrl.calculator.runMilliseconds = milli;
            state.runDuration = milli;
          })));
    }

    buildPanel() {
      return Container(
        width: maxWidth * 0.8,
        height: maxHeight * 0.8,
        color: Colors.white,
        child: Wrap(
          children: [
            backBtn(),
            parent.buildPlayModeButton(),
            lyricBtn(),
            bpm(),
            setGameNotes(),
            gameRunningDuration(),
            playBtn(),
          ],
        ),
      );
    }

    return Positioned(
      top: 0,
      left: 0,
      width: maxWidth,
      height: maxHeight,
      child: Obx(
        () => state.isPlaying
            ? const SizedBox(
                width: 0,
                height: 0,
              )
            : Center(
                child: buildPanel(),
              ),
      ),
    );
  }
}
