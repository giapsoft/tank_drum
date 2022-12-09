part of 'create_song.page.dart';

class _CreateSongPc extends _CreateSong$Ctrl {
  List<_NoteUb> notes = [];
  List<SoundNoteUb> soundNotes = [];
  final songName = StringInput('Song Name');
  late SongPlayer player;
  bool get isPlaying =>
      state.isPlayingCurrentPage || state.isPlayingFromCurrentNote;

  @override
  postConstruct() {
    initNotes() {
      for (int i = 0; i < 15; i++) {
        notes.add(_NoteUb(i,
            onLeave: onLeave,
            onActiveChanged: onNoteActiveChanged,
            onChangeLinkType: onChangeLinkType,
            onWillAcceptNote: onWillAcceptNote,
            onAcceptNote: onAcceptNote,
            notes: notes)
          ..ctrl.clearDrag());
      }
    }

    initSoundNotes() {
      final size = Get.width / 8;
      for (int i = 0; i < 15; i++) {
        soundNotes.add(SoundNoteUb(
          state.tune + i,
          width: size,
          height: size,
          padding: 2.0,
        ));
      }
      // add one silence to delete note
      soundNotes.add(SoundNoteUb(-1, width: size, height: size, padding: 2.0));
    }

    initNotes();
    initSoundNotes();
    // state.songNotes = SongLib.endlessLove;
    renderSongNotesToScreen();
    player = SongPlayer(
      onFinish: () {
        if (state.isPlayingCurrentPage) {
          state.isPlayingCurrentPage = false;
        }
        if (state.isPlayingFromCurrentNote) {
          if (!isLastPage() && nextPage()) {
            _doPlayNotesInCurrentPage();
          } else {
            state.isPlayingFromCurrentNote = false;
          }
        }
      },
    );

    state.tune$.listen((tune) {
      for (var note in soundNotes) {
        note.soundIdx += tune;
      }
    });
  }

  bool onWillAcceptNote(_NoteUb note, Object? data) {
    data as _DragData;
    data.action = _DragAction.none;
    final isFromKeyboard = data.fromIdx < 0;

    bool processDelete() {
      if (note.ctrl.soundName.isEmpty) {
        return false;
      }
      note.state.draggingName = '';
      note.state.draggingType = NoteLinkType.none;
      note.state.beats = 1;
      for (int i = note.idx; i < notes.length - 1; i++) {
        final nextNote = notes[i + 1];
        if (nextNote.state.soundName.isNotEmpty) {
          notes[i].ctrl.updateDraggingData(nextNote);
        } else {
          notes[i].state.draggingName = '';
          notes[i].state.draggingType = NoteLinkType.none;
          notes[i].state.beats = 1;
          break;
        }
      }
      if (state.songNotes.length > state.currentNoteIdx + notes.length) {
        final songNote = state.songNotes[state.currentNoteIdx + notes.length];
        notes.last.state.draggingBeats = songNote.beats;
        // notes.last.state.draggingName = songNote.soundName;
      }
      data.action = _DragAction.delete;
      data.validatedData = note.idx;
      return true;
    }

    bool processInsert() {
      if (note.idx >= notes.length - 1) {
        return false;
      }
      notes[note.idx + 1].state.draggingName = data.soundName;
      for (int i = note.idx + 2; i < notes.length; i++) {
        final prevNote = notes[i - 1];
        if (prevNote.state.soundName.isNotEmpty) {
          notes[i].ctrl.updateDraggingData(prevNote);
        }
      }
      data.action = _DragAction.insert;
      data.validatedData = note.idx + 1;
      return true;
    }

    if (isFromKeyboard &&
        data.isLinking &&
        data.soundName.isNotEmpty &&
        note.ctrl.soundName.isNotEmpty) {
      return processInsert();
    }

    if (data.isLinking && !isFromKeyboard) {
      return false;
    }

    if (!isFromKeyboard && !data.isLinking) {
      return false;
    }
    if (isFromKeyboard && data.isDeleting) {
      return processDelete();
    }

    if (note.ctrl.soundName.isNotEmpty) {
      note.state.draggingName = data.soundName;
      data.action = _DragAction.changeSound;
      data.validatedData = note.idx;
    } else {
      if (data.soundName.isEmpty) {
        return false;
      }
      for (int i = 0; i < notes.length; i++) {
        if (notes[i].ctrl.soundName.isEmpty) {
          notes[i].state.draggingName = data.soundName;
          data.action = _DragAction.insert;
          data.validatedData = i;
          break;
        }
      }
    }
    return true;
  }

  changeCurrentNoteIdx(double newIdx) {
    state.currentNoteIdx = newIdx.toInt() - 1;
    renderSongNotesToScreen();
  }

  onAcceptNote(_NoteUb note, Object? data) {
    data as _DragData;
    final idx = data.validatedData + state.currentNoteIdx;
    switch (data.action) {
      case _DragAction.delete:
        state.songNotes.removeAt(idx);
        break;
      case _DragAction.changeSound:
        // state.songNotes[idx].soundIdx = SoundNote.getNoteIdx(data.soundName);
        break;
      case _DragAction.insert:
        // state.songNotes.insert(idx, SongNote(data.soundName));
        break;
      case _DragAction.none:
        break;
    }
    state.songNotes = [...state.songNotes];
    renderSongNotesToScreen();
  }

  onLeave(_NoteUb note, Object? data) {
    for (var element in notes) {
      element.ctrl.clearDrag();
    }
  }

  renderSongNotesToScreen() {
    for (int i = 0; i < notes.length; i++) {
      final note = notes[i];
      note.ctrl.reset();
      final songNoteIdx = state.currentNoteIdx + i;
      if (state.songNotes.length > songNoteIdx) {
        final songNote = state.songNotes[songNoteIdx];
        var noteState = note.state;
        noteState.beats = songNote.beats;
      }
    }
    state.activeNoteBeats = -1;
  }

  SNote getSongNote(_NoteUb note) {
    return state.songNotes[note.idx];
  }

  onChangeLinkType(_NoteUb note) {
    if (note.ctrl.soundName.isNotEmpty &&
        note.ctrl.nextNote != null &&
        note.ctrl.nextNote!.state.soundName.isNotEmpty) {
      note.state.linkType = note.state.linkType.next();
      if (note.state.linkType.isNone()) {
        fixToSameLink(note.ctrl.prevNote);
        fixToSameLink(note.ctrl.nextNote);
        renderSongNotesToScreen();
      } else {
        fixToSameLink(note);
      }
    }
    if (!note.state.isActive) {
      note.ctrl.touchActive();
    } else {
      note.ctrl.setActiveInLink();
    }
  }

  fixToSameLink(_NoteUb? note) {
    if (note == null) {
      return;
    }
    final sameLink = note.ctrl.sameLinkNotes();
    note.ctrl.sameLinkNotes().forEach((element) {
      if (element.idx < sameLink.last.idx) {
        element.state.linkType = note.state.linkType;
      }
    });
  }

  int get lastActiveIdx => notes.lastIndexWhere((e) => e.state.isActive);
  _NoteUb? get lastActiveNote =>
      lastActiveIdx > -1 ? notes[lastActiveIdx] : null;

  onNoteActiveChanged(_NoteUb note) {
    if (lastActiveIdx >= 0) {
      state.activeNoteBeats = notes[lastActiveIdx].state.beats;
    } else {
      state.activeNoteBeats = -1;
    }
  }

  setActiveNoteBeats(double beats) {
    if (lastActiveIdx >= 0) {
      final note = notes[lastActiveIdx];
      note.state.beats = beats.toInt();
      getSongNote(note).beats = note.state.beats;
      state.activeNoteBeats = beats.toInt();
    }
  }

  playCurrentPage() {
    if (!state.isPlayingCurrentPage) {
      state.isPlayingCurrentPage = true;
      _doPlayNotesInCurrentPage();
    } else {
      player.pause();
      state.isPlayingCurrentPage = false;
    }
  }

  _doPlayNotesInCurrentPage() {}

  playFromCurrentNote() {
    if (state.isPlayingFromCurrentNote) {
      player.pause();
      state.isPlayingFromCurrentNote = false;
    } else {
      state.isPlayingFromCurrentNote = true;
      _doPlayNotesInCurrentPage();
    }
  }

  List<SNote> getIndependentNotesInCurrentPage() {
    int addIdx = notes.length;
    if (!notes.last.state.linkType.isNone()) {
      final lastNote = notes.last;
      addIdx = [lastNote, ...lastNote.ctrl.sameLinkNotes()]
          .map((e) => e.idx)
          .reduce(min);
    }
    return state.songNotes.sublist(state.currentNoteIdx,
        min(state.songNotes.length, state.currentNoteIdx + addIdx));
  }

  bool isLastPage() {
    return state.currentNoteIdx + notes.length >= state.songNotes.length;
  }

  bool nextPage() {
    final maxNextIdx =
        min(state.songNotes.length - 1, state.currentNoteIdx + notes.length);
    if (state.currentNoteIdx < maxNextIdx) {
      final lastNote = notes.last;
      if (!lastNote.state.linkType.isNone()) {
        final nextIdx = [lastNote, ...lastNote.ctrl.sameLinkNotes()]
            .map((e) => e.idx)
            .reduce(min);
        state.currentNoteIdx = state.currentNoteIdx + nextIdx;
      } else {
        state.currentNoteIdx = maxNextIdx;
      }
      renderSongNotesToScreen();
      return true;
    }
    return false;
  }

  prevPage() {
    final prevIdx = max(0, state.currentNoteIdx - notes.length);
    if (state.currentNoteIdx > prevIdx) {
      state.currentNoteIdx = prevIdx;
      renderSongNotesToScreen();
    }
  }
}
