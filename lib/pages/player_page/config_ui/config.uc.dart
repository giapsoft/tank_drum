part of '../player.page.dart';

class _ConfigUc extends _Config$Ctrl {
  List<InstrumentNote> positions(BoxConstraints constraints) {
    return [];
  }

  changeType() {}

  addNote() {
    state.totalNotes++;
  }

  reduceNote() {
    state.totalNotes--;
  }
}
