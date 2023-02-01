part of '../perfect_song_player.page.dart';

class _GameUc extends _Game$Ctrl {
  List<_GameNoteUb> gameNotes = [];
  List<int> noteQueue = [];
  bool isCurrentLeftSide = false;
  late AudioPlayer _backgroundPlayer;
  final calculator = _GameCalculator();
  PerfectSong get song => parent.ctrl.song!;
  String mp3Path = '';
  List<SilenceNode> notes = [];
  @override
  postConstruct() async {
    mp3Path = await song.mp3Path;
    notes = song.notes()
      ..sort((n1, n2) => n1.start.orElse(0) - n2.start.orElse(0));
    initLyrics();
  }

  prepareGameNotes() {
    if (gameNotes.length != state.totalGameNote) {
      gameNotes.clear();
      for (int i = 0; i < state.totalGameNote; i++) {
        gameNotes.add(_GameNoteUb(i, builder));
      }
    }
  }

  final pointName = {0: 'Miss', 1: 'Cool', 2: 'Great', 3: 'Perfect'};
  get pointCounter => {
        0: () => totalMiss++,
        1: () => totalCool++,
        2: () => totalGreat++,
        3: () => totalPerfect++,
      };
  int continuousPerfectCount = 0;
  int totalMiss = 0;
  int totalGreat = 0;
  int totalCool = 0;
  int totalPerfect = 0;
  addPoint(int point) {
    state.totalPoint += point;
  }

  String get perfectXString {
    return state.currentPoint == 3 && continuousPerfectCount > 1
        ? ' x$continuousPerfectCount'
        : '';
  }

  calcTutPoint(_NoteTutUb tut) {
    int point = calculator.calcTutPoint(
        tut.touchedDownMoment, tut.note.start.orElse(0));
    if (tut.isLongNote &&
        point == 0 &&
        tut.state.isRunning &&
        tut.touchedDownMoment -
                calculator.triggerMoment -
                tut.note.start.orElse(0) >
            calculator.halfRunMilliseconds) {
      point = 1;
    }
    state.currentPoint = point;
    if (point == 3) {
      continuousPerfectCount++;
    } else {
      continuousPerfectCount = 0;
    }
    return max(continuousPerfectCount - 1, 0) + point;
  }

  onTutTouchedDown(_NoteTutUb tut) {
    final point = calcTutPoint(tut);
    tut.isPointed = true;
    updatePoint(tut, point);
    if (tut.isLongNote) {
      tut.short();
    } else {
      tut.reset();
      tut.gameNote.ctrl.holdingTut = null;
    }
  }

  onTutFinishShorting(_NoteTutUb tut) {
    if (tut.state.isRunning && !tut.isPointed) {
      state.currentPoint = 0;
      tut.isPointed = true;
      updatePoint(tut, 0);
    }
  }

  onTutTouchedUp(_NoteTutUb tut) {
    if (tut.isLongNote) {
      tut.reset();
    }
  }

  updatePoint(_NoteTutUb tut, int point, {increaseCurrentPointType = true}) {
    tut.synchronized(() {
      if (increaseCurrentPointType) {
        pointCounter[state.currentPoint]();
      }
      if (point == 0) {
        state.totalPoint$.refresh();
      } else {
        state.totalPoint += point;
      }
      animateNewPoint(tut);
      if (tut.isLongNote && tut.state.isRunning) {
        Future.delayed(const Duration(milliseconds: 200)).then((value) {
          if (tut.state.isRunning) {
            updatePoint(tut, point, increaseCurrentPointType: false);
          }
        });
      }
    });
  }

  animateNewPoint(_NoteTutUb tut) {
    state.newPoint = true;
  }

  String currentPointName() {
    return '${pointName[state.currentPoint]!}$perfectXString';
  }

  final pointColors = {
    0: Colors.black,
    1: Colors.green,
    2: Colors.orange,
    3: Colors.pink,
  };
  Color currentPointColor() {
    return pointColors[state.currentPoint]!.withOpacity(0.4);
  }

  play() {
    resetPoint();
    noteQueue.clear();
    state.isPlaying = true;
    prepareHardCodedSong();
  }

  prepareHardCodedSong() {
    AuPlayer.playLocalPath(mp3Path, _backgroundPlayer).then((value) {
      final hardCodedPlayingNotes = notes.iterator;
      calculator.triggerMoment = DateTime.now().millisecondsSinceEpoch -
          calculator.halfRunMilliseconds;
      startHardCodedSong(hardCodedPlayingNotes);
      prepareLyrics();
    });
  }

  startHardCodedSong(Iterator<SilenceNode> hardCodedPlayingNotes) {
    if (state.isPlaying && hardCodedPlayingNotes.moveNext()) {
      Future.delayed(calculator
              .delayNote(hardCodedPlayingNotes.current.start.orElse(0)))
          .then((value) {
        trigger(hardCodedPlayingNotes.current);
        startHardCodedSong(hardCodedPlayingNotes);
      });
    }
  }

  trigger(SilenceNode? songNote) async {
    if (songNote == null || gameNotes.isEmpty) {
      return;
    }
    final gameNote = nextGameNote();
    noteQueue.add(gameNote.idx);
    gameNote.ctrl.trigger(songNote, (tut) {
      validateAndAutoTouch(gameNote, tut);
      if (!tut.isLongNote) {
        calculator.onTutOverTime(() {
          if (tut.state.isRunning) {
            onTutTouchedDown(tut);
          }
        });
      } else {
        Future.delayed(calculator.halfRunDuration).then((_) {
          tut.short();
        });
      }
    });
  }

  int calcDelta(_NoteTutUb tut) {
    final moment = DateTime.now().millisecondsSinceEpoch;
    final runnedTime = moment - calculator.triggerMoment;
    return runnedTime - tut.note.start.orElse(0);
  }

  validateAndAutoTouch(_GameNoteUb gameNote, _NoteTutUb tut) {
    if (state.isAuto) {
      Future.delayed(Duration(
              milliseconds: calculator.halfRunMilliseconds - calcDelta(tut)))
          .then((_) {
        gameNote.ctrl.touchDown();
        Future.delayed(
                Duration(milliseconds: tut.note.duration.orElse(0) + 100))
            .then((_) {
          gameNote.ctrl.touchUp();
        });
      });
    }
  }

  stop() {
    resetPoint();
    state.isPlaying = false;
    _backgroundPlayer.stop();
    currentStageIdx = 0;
  }

  resetPoint() {
    continuousPerfectCount = 0;
    totalCool = 0;
    totalGreat = 0;
    totalPerfect = 0;
    totalMiss = 0;
    state.totalPoint = 0;
    state.currentPoint = 0;
    state.newPoint = false;
    for (var element in lyricStages) {
      element.reset();
    }
  }

  String get pointSummary => [
        'Total: ${state.totalPoint}',
        'Miss: $totalMiss',
        'Cool: $totalCool',
        'Great: $totalGreat',
        'Perfect: $totalPerfect'
      ].join('\n');
  _GameNoteUb nextGameNote() {
    final halfTotalGameNote = state.totalGameNote ~/ 2;
    final noteIdx = isCurrentLeftSide
        ? NumberUt.randomBetween(0, halfTotalGameNote)
        : NumberUt.randomBetween(halfTotalGameNote, state.totalGameNote);
    isCurrentLeftSide = !isCurrentLeftSide;
    return gameNotes[noteIdx];
  }

  @override
  onWillBuild() {
    _backgroundPlayer = AudioPlayer();
    _backgroundPlayer.onPlayerCompletion.listen((event) {
      stop();
    });
    resetPoint();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  close() {
    stop();
    _backgroundPlayer.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return super.close();
  }

  final lyricStages = <_LyricsUb>[];
  final lyricQueue = <SilenceNode>[];
  initLyrics() {
    for (int i = 0; i < 8; i++) {
      lyricStages.add(_LyricsUb(i, triggerNextLyricNote));
    }
  }

  prepareLyrics() {
    if (!state.isDisplayLyrics) {
      return;
    }
    lyricQueue.clear();
    for (var stage in lyricStages) {
      stage.triggerMoment = calculator.triggerMoment;
    }
    startLyricNotes(song
        .notes()
        .where((element) => element.text.orElse('').isNotEmpty)
        .iterator);
  }

  startLyricNotes(Iterator<SilenceNode> hardCodedLyricNotes) {
    if (state.isPlaying && hardCodedLyricNotes.moveNext()) {
      Future.delayed(calculator
              .delayNote(hardCodedLyricNotes.current.start.orElse(0) - 2000))
          .then((value) {
        triggerLyric(hardCodedLyricNotes.current);
        startLyricNotes(hardCodedLyricNotes);
      });
    }
  }

  triggerNextLyricNote(_LyricsUb stage) {
    final inQueue = lyricQueue.isEmpty ? null : lyricQueue.removeAt(0);
    if (inQueue != null) {
      triggerLyric(inQueue);
    }
  }

  int currentStageIdx = 0;
  triggerLyric(SilenceNode note) {
    if (lyricStages.every((element) => element.isFree())) {
      currentStageIdx = 0;
    }
    final stage = lyricStages[currentStageIdx];
    if (stage.isFree()) {
      stage.setNote(note);
      currentStageIdx++;
      if (currentStageIdx >= lyricStages.length) {
        currentStageIdx = 0;
      }
    } else {
      lyricQueue.add(note);
    }
  }
}
