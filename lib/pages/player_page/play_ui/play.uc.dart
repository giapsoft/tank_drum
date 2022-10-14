part of '../player.page.dart';

class _PlayUc extends _Play$Ctrl {
  late SongPlayer player;

  Instrument get instrument => Instrument.getInstrument(state.instrumentName);

  late BoxConstraints instrumentConstraints;
  late EdgeInsets instrumentInsets;
  double get maxWidth => instrumentConstraints.maxWidth;
  double get maxHeight => instrumentConstraints.maxHeight;
  int get barSize => 4;
  double get smallBarSize => 1 / barSize;
  double get largeBarSize => (barSize - 1) / barSize;

  bool get isFreeMode => state.songNotes.isEmpty;
  bool get isTrainingMode => !isFreeMode && state.playMode == 0;
  bool get isPerformanceMode => !isFreeMode && state.playMode == 1;

  setWrapper(BoxConstraints constraints, EdgeInsets insets) {
    instrumentConstraints = constraints;
    instrumentInsets = insets;
  }

  @override
  close() {
    PoolPlayer.realeaseAllSounds();
  }

  final songs = {
    '': <SongNote>[],
    'Castle In The Sky': SongLib.castleInTheSky,
    'Endless Love': SongLib.endlessLove,
    'Happy Birth Day': SongLib.happyBirthDay,
    'Proud Of You': SongLib.proudOfYou,
  };

  List<SongNote> songNotes = [];
  List<SongNoteGroup> songNoteGroups = [];
  setSongNotes(List<SongNote> notes) {
    songNotes = notes;
    songNoteGroups = SongNoteGroup.parse(notes);
    player.reset(noteGroups: songNoteGroups);
    groupTriggers.clear();
  }

  touchSelfMode() {
    state.isSelfMode = !state.isSelfMode;
    if (state.isSelfMode) {
      children.instrument.ctrl.inactiveAll();
      setSongNotes(songNotes);
      highlightCurrentTrigger();
    }
  }

  @override
  postConstruct() {
    player = SongPlayer(
      isSilence: true,
      delayGroupSecond: 2,
      onPlay: groupTriggers.clear,
      onFinish: () async {
        state.isPlaying = false;
        await Future.delayed(const Duration(seconds: 2));
        children.instrument.ctrl.inactiveAll();
      },
      onStartNoteGroup: (group, prev, next, next2) {
        if (prev == null) {
          groupTrigger(group)?.active();
          groupTrigger(next)?.wait();
        }
        triggerTut(group, next, next2);
      },
    );
    // state.bpm$.listen((p0) {
    //   player.setBpm(p0);
    // });
    // state.tune$.listen((tune) {
    //   player.tune = tune;
    //   instrument.customTune = tune;
    // });
    // state.currentSong$.listen((songName) {
    //   if (songName.isEmpty) {
    //     setSongNotes([]);
    //     inactiveAllNotes();
    //     instrument.reset();
    //     setNoteCount();
    //     return;
    //   }

    //   final songNotes = songs[songName]!;
    //   setSongNotes(songNotes);
    //   inactiveAllNotes();
    //   if (state.isSelfMode) {
    //     highlightCurrentTrigger();
    //   }
    //   final soundIdxSet = songNotes.map((e) => e.soundIdx).toSet();
    //   if (!instrument.isAbleToPlay(soundIdxSet)) {
    //     final name = Instrument.findInstrumentCanPlay(soundIdxSet).name;
    //     Instrument.getInstrument(name).prepareSounds(soundIdxSet);
    //     state.instrumentName = name;
    //   } else {
    //     instrument.prepareSounds(currentSoundIdxSet);
    //   }
    //   setNoteCount();
    // });
  }

  Set<int> get currentSoundIdxSet => songNotes.map((e) => e.soundIdx).toSet();

  highlightCurrentTrigger() {
    groupTrigger(player.prevGroupNote)?.inActive();
    groupTrigger(player.currentGroupNote)?.active();
    groupTrigger(player.nextGroupNote)?.wait();
  }

  triggerTut(SongNoteGroup group, SongNoteGroup? next, SongNoteGroup? next2) {
    final gTrigger = groupTrigger(group)!;
    for (var tut in gTrigger.tuts) {
      tut.ctrl.trigger(() {
        if (state.isAutoSound) {
          // tut.instrumentNote.play();
        }
        if (gTrigger.isCountEnded()) {
          gTrigger.inActive();
          groupTrigger(next)?.active();
          groupTrigger(next2)?.wait();
        }
      });
    }
  }

  Map<int, _NoteGroupTrigger> groupTriggers = {};
  _NoteGroupTrigger? groupTrigger(SongNoteGroup? group) {
    if (group == null) {
      return null;
    }
    return groupTriggers[group.idx] ??= genTut(group);
  }

  _NoteGroupTrigger genTut(SongNoteGroup group) {
    final trigger = _NoteGroupTrigger(group);
    // for (var songNote in group.notes) {
    //   final ub = children.instrument.ctrl.getNoteBySoundIdx(songNote.soundIdx);
    //   if (ub != null) {
    //     trigger.addTut(ub.ctrl.pickTut());
    //     trigger.soundUbs.add(ub.ctrl.soundBuilder);
    //   } else {
    //     print('missing idx: ${songNote.soundIdx}');
    //   }
    // }
    return trigger;
  }

  touchPlay() {
    if (state.isPlaying) {
      state.isPlaying = false;
      player.stop();
    } else {
      state.isPlaying = true;
      player.play(songNoteGroups: songNoteGroups, bpm: state.bpm);
    }
  }

  onDrag(DragUpdateDetails details) {
    drag(details.globalPosition);
  }

  startDrag(DragStartDetails details) {
    drag(details.globalPosition);
  }

  drag(Offset offset) async {
    for (var note in children.instrument.ctrl.currentUbs) {
      note.ctrl.swipe(offset);
    }
  }
}
