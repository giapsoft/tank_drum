part of '../../player.page.dart';

class _GameUc extends _Game$Ctrl {
  List<_GameNoteUb> gameNotes = [];
  List<int> noteQueue = [];
  bool isCurrentLeftSide = false;
  late SongPlayer _flexPlayer;
  late AudioPlayer _backgroundPlayer;
  final calculator = GameCalculator();

  @override
  postConstruct() {
    state.bpm$.listen((p0) {
      _flexPlayer.bpm = p0;
    });

    _flexPlayer = SongPlayer(
        isSilence: true,
        onStartNote: () {
          trigger(_flexPlayer.currentNote);
        },
        onFinish: () {
          Future.delayed(const Duration(seconds: 3)).then((value) {
            state.isPlaying = false;
          });
        });
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
    int point =
        calculator.calcTutPoint(tut.touchedDownMoment, tut.note.startPoint);
    if (tut.isLongNote &&
        point == 0 &&
        tut.state.isRunning &&
        tut.touchedDownMoment - calculator.triggerMoment - tut.note.startPoint >
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
      tut.playThenReset();
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
    if (parent.ctrl.isFixedSong) {
      prepareHardCodedSong();
    } else {
      _flexPlayer.play(
        songSentences: parent.state.sentences,
        bpm: state.bpm,
      );
    }
  }

  prepareHardCodedSong() {
    AuPlayer.play('songs/${parent.state.songName}.mp3', _backgroundPlayer)
        .then((value) {
      final hardCodedPlayingNotes = parent.state.sentences.first.notes.iterator;
      calculator.triggerMoment = DateTime.now().millisecondsSinceEpoch -
          calculator.halfRunMilliseconds;
      startHardCodedSong(hardCodedPlayingNotes);
      prepareLyrics();
    });
  }

  startHardCodedSong(Iterator<SongNote> hardCodedPlayingNotes) {
    if (state.isPlaying && hardCodedPlayingNotes.moveNext()) {
      Future.delayed(
              calculator.delayNote(hardCodedPlayingNotes.current.startPoint))
          .then((value) {
        trigger(hardCodedPlayingNotes.current);
        startHardCodedSong(hardCodedPlayingNotes);
      });
    }
  }

  trigger(SongNote? songNote) async {
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
    return runnedTime - tut.note.startPoint;
  }

  validateAndAutoTouch(_GameNoteUb gameNote, _NoteTutUb tut) {
    if (state.isAuto) {
      Future.delayed(Duration(
              milliseconds: calculator.halfRunMilliseconds - calcDelta(tut)))
          .then((_) {
        gameNote.ctrl.touchDown();
        Future.delayed(Duration(milliseconds: tut.note.milliseconds + 100))
            .then((_) {
          gameNote.ctrl.touchUp();
        });
      });
    }
  }

  back() {
    parent.state.isGameMode = false;
  }

  stop() {
    resetPoint();
    state.isPlaying = false;
    _flexPlayer.stop();
    _backgroundPlayer.stop();
    for (var element in lyricStages) {
      element.reset();
    }
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
  final lyricQueue = <SongNote>[];
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
    startLyricNotes(parent.state.sentences.first.notes
        .where((element) => element.name.isNotEmpty)
        .iterator);
  }

  startLyricNotes(Iterator<SongNote> hardCodedLyricNotes) {
    if (state.isPlaying && hardCodedLyricNotes.moveNext()) {
      Future.delayed(calculator
              .delayNote(hardCodedLyricNotes.current.startPoint - 2000))
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
  triggerLyric(SongNote note) {
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
