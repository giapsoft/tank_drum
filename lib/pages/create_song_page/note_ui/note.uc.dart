part of '../create_song.page.dart';

class _NoteUc extends _Note$Ctrl {
  _NoteUb? get nextNote => builder.idx < builder.notes.length - 1
      ? builder.notes[builder.idx + 1]
      : null;
  _NoteUb? get prevNote =>
      builder.idx > 0 ? builder.notes[builder.idx - 1] : null;

  reset() {
    clearDrag();
    state.isActive = false;
    state.soundName = '';
    state.beats = 1;
    state.linkType = NoteLinkType.none;
  }

  clearDrag() {
    state.draggingName = 'NO_NAME';
    state.draggingBeats = -1;
    state.draggingType = NoteLinkType.from('');
  }

  bool get isDragging {
    return state.draggingName != 'NO_NAME' ||
        !state.draggingType.isUndefined() ||
        state.draggingBeats > 0;
  }

  String get soundName =>
      state.draggingName == 'NO_NAME' ? state.soundName : state.draggingName;
  int get beats => state.draggingBeats < 1 ? state.beats : state.draggingBeats;

  bool get isNextNoteEmpty => nextNote?.ctrl.soundName.isEmpty ?? false;

  bool get isDiffTypeWithPrev =>
      !linkType.isNone() &&
      prevNote != null &&
      prevNote!.ctrl.linkType.type != linkType.type;

  NoteLinkType get linkType =>
      state.draggingType.isUndefined() ? state.linkType : state.draggingType;

  bool isRenderBeats() {
    return (linkType.isNone() && soundName.isNotEmpty);
  }

  Color get activeColor {
    return state.isActive ? Colors.blueAccent : Colors.grey;
  }

  Color get noteColor {
    return isDragging ? Colors.green : activeColor;
  }

  touchActive() {
    if (state.soundName.isEmpty) {
      return;
    }
    state.isActive = !state.isActive;
    setActiveInLink();
  }

  setActiveInLink() {
    final sameLinkIdx = sameLinkNotes().map((e) => e.idx).toList();
    for (var element in builder.notes) {
      if (element.idx == builder.idx) {
        continue;
      }
      if (sameLinkIdx.contains(element.idx)) {
        element.state.isActive = state.isActive;
      } else {
        element.state.isActive = false;
      }
    }
    builder.onActiveChanged(builder);
  }

  List<_NoteUb> sameLinkNotes() {
    final result = <_NoteUb>[];
    _NoteUb? traceNote = prevNote;
    bool isEnd = false;
    while (traceNote != null) {
      if (traceNote.ctrl.linkType.isNone()) {
        isEnd = true;
      }
      if (!isEnd) {
        result.add(traceNote);
      }
      traceNote = traceNote.ctrl.prevNote;
    }

    traceNote = nextNote;
    isEnd = false;
    while (traceNote != null) {
      if (traceNote.ctrl.prevNote!.ctrl.linkType.isNone()) {
        isEnd = true;
      }
      if (!isEnd) {
        result.add(traceNote);
      }
      traceNote = traceNote.ctrl.nextNote;
    }
    return result;
  }

  updateDraggingData(_NoteUb other) {
    state.draggingName = other.state.soundName;
    state.draggingType = other.state.linkType;
    state.draggingBeats = other.state.beats;
  }
}
