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

  setWrapper(BoxConstraints constraints, EdgeInsets insets) {
    instrumentConstraints = constraints;
    instrumentInsets = insets;
    setNoteCount();
  }

  InstrumentNote get instrumentWrapper {
    if (maxWidth > maxHeight) {
      if (instrument.isKalimba) {
        return InstrumentNote(
            insets: instrumentInsets,
            posIdx: 0,
            top: 0,
            left: 0,
            width: maxWidth,
            height: maxHeight * largeBarSize);
      } else {
        return InstrumentNote(
            insets: instrumentInsets,
            posIdx: 0,
            top: 0,
            left: maxWidth / barSize,
            width: maxWidth * largeBarSize,
            height: maxHeight);
      }
    } else {
      if (instrument.isKalimba) {
        return InstrumentNote(
            insets: instrumentInsets,
            posIdx: 0,
            top: 0,
            left: 0,
            width: maxWidth,
            height: maxHeight * largeBarSize);
      } else {
        return InstrumentNote(
            insets: instrumentInsets,
            posIdx: 0,
            top: maxHeight / barSize,
            left: 0,
            width: maxWidth,
            height: maxHeight * largeBarSize);
      }
    }
  }

  barWrap(List<Widget> controls) {
    final child = Wrap(
      children: controls,
    );
    if (maxWidth > maxHeight) {
      if (instrument.isKalimba) {
        return Positioned(
            bottom: 0,
            left: 0,
            width: maxWidth,
            height: maxHeight * smallBarSize,
            child: child);
      } else {
        return Positioned(
            left: 0,
            top: 0,
            width: maxWidth * smallBarSize,
            height: maxHeight,
            child: child);
      }
    } else {
      if (instrument.isKalimba) {
        return Positioned(
            bottom: 0,
            left: 0,
            width: maxWidth,
            height: maxHeight * smallBarSize,
            child: child);
      } else {
        return Positioned(
            left: 0,
            top: 0,
            width: maxWidth,
            height: maxHeight * smallBarSize,
            child: child);
      }
    }
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
      inactiveAllNotes();
      setSongNotes(songNotes);
      highlightCurrentTrigger();
    }
  }

  inactiveAllNotes() {
    for (var sound in noteBuilders) {
      sound.ctrl.soundBuilder.inactive();
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
        inactiveAllNotes();
      },
      onStartNoteGroup: (group, prev, next, next2) {
        if (prev == null) {
          groupTrigger(group)?.active();
          groupTrigger(next)?.wait();
        }
        triggerTut(group, next, next2);
      },
    );
    state.bpm$.listen((p0) {
      player.setBpm(p0);
    });
    state.tune$.listen((tune) {
      player.tune = tune;
      instrument.customTune = tune;
    });
    state.currentSong$.listen((songName) {
      if (songName.isEmpty) {
        setSongNotes([]);
        inactiveAllNotes();
        instrument.reset();
        setNoteCount();
        return;
      }

      final songNotes = songs[songName]!;
      setSongNotes(songNotes);
      inactiveAllNotes();
      if (state.isSelfMode) {
        highlightCurrentTrigger();
      }
      final soundIdxSet = songNotes.map((e) => e.soundIdx).toSet();
      if (!instrument.isAbleToPlay(soundIdxSet)) {
        final name = Instrument.findInstrumentCanPlay(soundIdxSet).name;
        Instrument.getInstrument(name).prepareSounds(soundIdxSet);
        state.instrumentName = name;
      } else {
        instrument.prepareSounds(currentSoundIdxSet);
      }
      setNoteCount();
    });

    state.instrumentName$.listen((_) {
      SoundSet.current = instrument.defaultSoundSet;
      setNoteCount();
    });
  }

  Set<int> get currentSoundIdxSet => songNotes.map((e) => e.soundIdx).toSet();

  setNoteCount([int? count]) {
    state.noteCount = count ?? instrument.noteList.length;
    instrument.setPositionNotes(state.noteCount);
    resetNoteBuilders();
    updateSoundIdxToNote();
  }

  resetNoteBuilders() {
    if (noteBuilders.length == state.noteCount) {
      return;
    }
    noteBuilders.clear();
    for (final instrumentNote in instrument.noteList) {
      noteBuilders.add(_InstrumentNoteUb(this, instrumentNote, onTouchPlay: () {
        if (state.isSelfMode) {
          final trigger = groupTrigger(player.currentGroupNote)!;
          if (trigger.isFinalNote(instrumentNote.currentSoundIdx) &&
              player.hasNext) {
            player.next();
            highlightCurrentTrigger();
          }
        }
      }));
    }
    instrument.setWrapper(instrumentWrapper);
  }

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
          tut.instrumentNote.play();
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
    for (var songNote in group.notes) {
      final ub = soundIdxToNote[songNote.soundIdx];
      if (ub != null) {
        trigger.addTut(ub.ctrl.pickTut());
        trigger.soundUbs.add(ub.ctrl.soundBuilder);
      } else {
        print('missing idx: ${songNote.soundIdx}');
      }
    }
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

  List<_InstrumentNoteUb> noteBuilders = [];
  Map<int, _InstrumentNoteUb> soundIdxToNote = {};
  updateSoundIdxToNote() {
    soundIdxToNote.clear();
    for (var e in noteBuilders) {
      soundIdxToNote[e.note.currentSoundIdx] = e;
    }
  }

  onDrag(DragUpdateDetails details) {
    drag(details.globalPosition);
  }

  startDrag(DragStartDetails details) {
    drag(details.globalPosition);
  }

  drag(Offset offset) async {
    for (var note in noteBuilders) {
      note.ctrl.swipe(offset);
    }
  }

  void touchAutoSound() {
    state.isAutoSound = !state.isAutoSound;
  }

  nextNoteCount() {
    setNoteCount(instrument.nextNoteCount());
  }

  prevNoteCount() {
    setNoteCount(instrument.prevNoteCount());
  }
}
