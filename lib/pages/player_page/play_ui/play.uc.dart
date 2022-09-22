part of '../player.page.dart';

class _PlayUc extends _Play$Ctrl {
  late SongPlayer player;

  final songs = {
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
      highlight();
    }
  }

  inactiveAllNotes() {
    for (var sound in soundNameToDrumNoteUb.values) {
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
    for (final soundName in SoundSet.allSoundNames) {
      soundNameToDrumNoteUb[soundName] =
          _DrumNoteUb(this, soundName, onTouchPlay: () {
        if (state.isSelfMode) {
          final trigger = groupTrigger(player.currentGroupNote)!;
          if (trigger.hasSound(soundName) &&
              trigger.isCountEnded() &&
              player.hasNext) {
            player.next();
            highlight();
          }
        }
      });
    }
    setSongNotes(SongLib.castleInTheSky);
  }

  highlight() {
    groupTrigger(player.prevGroupNote)?.inActive();
    groupTrigger(player.currentGroupNote)!.active();
    groupTrigger(player.nextGroupNote)?.wait();
  }

  triggerTut(SongNoteGroup group, SongNoteGroup? next, SongNoteGroup? next2) {
    final gTrigger = groupTrigger(group)!;
    gTrigger.tuts
        // ignore: avoid_function_literals_in_foreach_calls
        .forEach((tut) {
      tut.ctrl.trigger(() {
        if (state.isAutoSound) {
          tut.drumNote.playSound();
        }
        if (gTrigger.isCountEnded()) {
          gTrigger.inActive();
          groupTrigger(next)?.active();
          groupTrigger(next2)?.wait();
        }
      });
    });
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
      final ub = soundNameToDrumNoteUb[songNote.soundName]!;
      trigger.addTut(ub.ctrl.pickTut());
      trigger.soundUbs.add(ub.ctrl.soundBuilder);
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

  final Map<String, _DrumNoteUb> soundNameToDrumNoteUb = {};

  Map<String, List<_DrumNoteUb>> notesByDrum = {};

  List<_DrumNoteUb> get drumNoteBuilders =>
      notesByDrum[Drum.current.name] ??= Drum.current.drumNotes
          .map((e) => soundNameToDrumNoteUb[e.soundNoteName]!)
          .toList();

  onDrag(DragUpdateDetails details) {
    drag(details.globalPosition);
  }

  startDrag(DragStartDetails details) {
    drag(details.globalPosition);
  }

  drag(Offset offset) async {
    for (var note in drumNoteBuilders) {
      note.ctrl.swipe(offset);
    }
  }

  void touchAutoSound() {
    state.isAutoSound = !state.isAutoSound;
  }

  void changeSong(String? songName) {
    state.currentSong = songName!;
    setSongNotes(songs[songName]!);
    inactiveAllNotes();
    if (state.isSelfMode) {
      highlight();
    }
  }
}

class _NoteGroupTrigger {
  List<_NoteTutUb> tuts = [];
  List<SoundNoteUb> soundUbs = [];
  final SongNoteGroup group;
  _NoteGroupTrigger(this.group);
  List<String>? _soundNames;
  List<String> get soundNames =>
      _soundNames ??= group.notes.map((e) => e.soundName).toList();

  int _count = -1;
  startCount() {
    _count = group.notes.length;
  }

  startCountIfNot() {
    if (_count < 0) {
      _count = group.notes.length;
    }
  }

  bool hasSound(String soundName) {
    return soundNames.contains(soundName);
  }

  bool isCountEnded() {
    startCountIfNot();
    final result = --_count == 0;
    if (result) {
      _count = -1;
    }
    return result;
  }

  addTut(_NoteTutUb tut) {
    tuts.add(tut);
  }

  active() {
    for (var tut in tuts) {
      tut.state.isActive = true;
      tut.state.isWaiter = false;
    }
    for (var ub in soundUbs) {
      ub.active();
    }
  }

  wait() {
    for (var tut in tuts) {
      tut.state.isWaiter = true;
    }
    for (var ub in soundUbs) {
      ub.waiter();
    }
  }

  void inActive() {
    for (var tut in tuts) {
      tut.ctrl.inActive();
    }
    for (var ub in soundUbs) {
      ub.inactive();
    }
  }
}
