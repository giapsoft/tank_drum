import 'package:tankdrum_learning/models/song_note_group.dart';

import 'song_note.dart';

class NoteWaiter {
  int _bpm = 90;
  static const byBpm = 'byBpm';
  static const byMillisecond = 'byMillisecond';
  String mode = '';

  update(int? bpm) {
    if (bpm == null) {
      mode = byMillisecond;
    } else {
      _bpm = bpm;
      mode = byBpm;
    }
  }

  wait(SongNoteGroup note) async {
    if (mode == byBpm) {
      await note.waitingByBeats(_bpm);
    } else {
      await note.waitingByMillisecond();
    }
  }
}

class SongPlayer {
  List<SongNoteGroup> noteGroups = [];
  bool _isPlaying = false;
  NoteWaiter waiter = NoteWaiter();
  Function()? onFinish;
  Function()? onPause;
  Function()? onPlay;
  Function()? onStop;
  Function(List<int>)? onStartNoteIdxRange;
  Function(SongNote)? onStartNote;
  Function(SongNote)? onEndNote;
  Function(SongNoteGroup group, SongNoteGroup? prev, SongNoteGroup? next,
      SongNoteGroup? next2)? onStartNoteGroup;
  Function(SongNoteGroup group, SongNoteGroup? prev, SongNoteGroup? next,
      SongNoteGroup? next2)? onEndNoteGroup;
  bool isSilence;
  int delayGroupSecond = 0;
  SongPlayer({
    this.onStartNoteGroup,
    this.onEndNoteGroup,
    this.isSilence = false,
    this.onFinish,
    this.onPlay,
    this.onPause,
    this.onStop,
    this.onStartNoteIdxRange,
    this.onStartNote,
    this.onEndNote,
    this.delayGroupSecond = 0,
  });

  play({List<SongNote>? notes, int? bpm, List<SongNoteGroup>? songNoteGroups}) {
    if (songNoteGroups != null) {
      noteGroups = songNoteGroups;
    } else if (notes != null) {
      noteGroups = SongNoteGroup.parse(notes);
    }

    _currentGroupIdx = 0;
    _currentNoteIdx = 0;

    _runFunction(onPlay);

    _isPlaying = true;
    waiter.update(bpm);
    _play();
  }

  reset({List<SongNoteGroup>? noteGroups}) {
    if (noteGroups != null) {
      this.noteGroups = noteGroups;
    }
    _currentGroupIdx = 0;
    _currentNoteIdx = 0;
  }

  setBpm(int bpm) {
    waiter.update(bpm);
  }

  int _currentGroupIdx = 0;
  int _currentNoteIdx = 0;
  SongNoteGroup get currentGroupNote => noteGroups[_currentGroupIdx];
  SongNoteGroup? get prevGroupNote =>
      _currentGroupIdx < 1 ? null : noteGroups[_currentGroupIdx - 1];
  SongNoteGroup? get nextGroupNote => _currentGroupIdx >= noteGroups.length - 1
      ? null
      : noteGroups[_currentGroupIdx + 1];

  SongNoteGroup? get nextGroupNote2 => _currentGroupIdx >= noteGroups.length - 2
      ? null
      : noteGroups[_currentGroupIdx + 2];
  bool get hasNext => _currentGroupIdx < noteGroups.length - 1;

  SongNoteGroup next() {
    return noteGroups[++_currentGroupIdx];
  }

  _onStartNoteGroup(SongNoteGroup group) async {
    if (onStartNoteIdxRange != null) {
      final list = [
        for (var i = _currentNoteIdx;
            i < _currentNoteIdx + group.notes.length;
            i++)
          i
      ];
      onStartNoteIdxRange!(list);
    }

    if (onStartNoteGroup != null) {
      onStartNoteGroup!(group, prevGroupNote, nextGroupNote, nextGroupNote2);
    }

    _currentNoteIdx += group.notes.length;
  }

  _onEndNoteGroup(SongNoteGroup group) async {
    if (onEndNoteGroup != null) {
      if (delayGroupSecond > 0) {
        await Future.delayed(Duration(seconds: delayGroupSecond));
      }
      onEndNoteGroup!(group, prevGroupNote, nextGroupNote, nextGroupNote2);
    }
  }

  _onFinish() async {
    _runFunction(onFinish);
  }

  _play() async {
    if (_isPlaying && noteGroups.length > _currentGroupIdx) {
      final group = noteGroups[_currentGroupIdx];
      _onStartNoteGroup(group);
      group.play(
          onStartNote: onStartNote, onEndNote: onEndNote, isSilence: isSilence);
      await waiter.wait(group);
      _onEndNoteGroup(group);
      _currentGroupIdx++;
    } else {
      _onFinish();
      return;
    }
    _play();
  }

  _runFunction(Function()? func) {
    if (func != null) {
      func();
    }
  }

  stop() {
    _isPlaying = false;
    _currentGroupIdx = 0;
    _runFunction(onStop);
  }

  pause() {
    _isPlaying = false;
    _runFunction(onPause);
  }
}
