part of '../player.page.dart';

class _NoteGroupTrigger {
  List<_NoteTutUb> tuts = [];
  List<SoundNoteUb> soundUbs = [];
  final SongNoteGroup group;
  _NoteGroupTrigger(this.group);
  List<int>? _soundNames;
  List<int> get soundNames =>
      _soundNames ??= group.notes.map((e) => e.soundIdx).toList();

  int _count = -1;
  startCount() {
    _count = group.notes.length;
  }

  startCountIfNot() {
    if (_count < 0) {
      _count = group.notes.length;
    }
  }

  bool hasSound(int soundIdx) {
    return soundNames.contains(soundIdx);
  }

  bool isCountEnded() {
    startCountIfNot();
    final result = --_count == 0;
    if (result) {
      _count = -1;
    }
    return result;
  }

  List<int> leftNotes = [];
  bool isFinalNote(int soundIdx) {
    if (leftNotes.isEmpty) {
      leftNotes = soundNames;
    }
    if (leftNotes.contains(soundIdx)) {
      leftNotes.remove(soundIdx);
    }
    return leftNotes.isEmpty;
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
