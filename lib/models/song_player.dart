import 'package:tankdrum_learning/models/song_sentence.dart';
import 'package:tankdrum_learning/models/sound_set.dart';

import 'song_note.dart';

class SongPlayer {
  List<SongSentence> sentences = [];
  List<SNote> get notes => currentSentence?.notes ?? [];
  SongSentence? get currentSentence =>
      _currentSentenceIdx >= 0 && _currentSentenceIdx < sentences.length
          ? sentences[_currentSentenceIdx]
          : null;
  SongSentence? get nextSentence =>
      _currentSentenceIdx >= 0 && _currentSentenceIdx < sentences.length - 1
          ? sentences[_currentSentenceIdx + 1]
          : null;
  SongSentence? get prevSentence =>
      _currentSentenceIdx > 0 ? sentences[_currentSentenceIdx - 1] : null;

  bool _isPlaying = false;
  Function()? onFinish;
  Function()? onPause;
  Function()? onPlay;
  Function()? onStop;
  Function()? onStartNote;
  Function()? onEndNote;
  Function()? onNextNote;
  Function()? onNextSentence;
  Function(int)? onTouchedWaiter;
  int bpm = 100;
  bool isSilence;
  int tune = 0;
  SongPlayer({
    this.isSilence = false,
    this.onNextSentence,
    this.onFinish,
    this.onPlay,
    this.onPause,
    this.onStop,
    this.onStartNote,
    this.onEndNote,
    this.onTouchedWaiter,
    this.onNextNote,
  });

  play({
    List<SongSentence>? songSentences,
    int? bpm,
  }) {
    sentences = songSentences ?? [];
    this.bpm = bpm ?? 100;
    _currentNoteIdx = 0;
    _currentSentenceIdx = 0;
    _isPlaying = true;
    _run(onPlay);
    _play();
  }

  reset({List<SongSentence>? songSentences}) {
    sentences = songSentences ?? [];
    _currentNoteIdx = 0;
    _currentSentenceIdx = 0;
    updateWaitingIdx();
  }

  int _currentNoteIdx = 0;
  int _currentSentenceIdx = 0;

  SNote? get currentNote => _getNote(_currentNoteIdx);
  SNote? get prevNote => _currentNoteIdx > 0
      ? _getNote(_currentNoteIdx - 1)
      : prevSentence?.lastNote;
  SNote? get nextNote {
    if (_currentNoteIdx < (currentSentence?.notes.length ?? 0) - 1) {
      return _getNote(_currentNoteIdx + 1);
    }
    return nextSentence?.firstNote;
  }

  SNote? _getNote(int idx) {
    return (notes.isNotEmpty && notes.length > idx) ? notes[idx] : null;
  }

  _play() async {
    if (_isPlaying && sentences.length > _currentSentenceIdx) {
      _run(onStartNote);
      currentNote?.wait(bpm).then((value) {
        if (!isSilence) {
          currentNote?.play(tune: tune);
        }
        _run(onEndNote);
        _nextNote();
        _play();
      });
    } else {
      _run(onFinish);
      _run(stop);
    }
  }

  List<int> waitingIdx = [];
  updateWaitingIdx() async {
    waitingIdx = [...(currentNote?.soundIdxList ?? [])];
    waitingIdx.sort();
  }

  _nextNote() {
    if (currentSentence != null) {
      if (_currentNoteIdx < currentSentence!.notes.length - 1) {
        _currentNoteIdx++;
      } else {
        _currentSentenceIdx++;
        _currentNoteIdx = 0;
        _run(onNextSentence);
      }
      updateWaitingIdx();
      _run(onNextNote);
    }
  }

  touchIdx(int idx) {
    waitingIdx.removeWhere((waiter) {
      if (waiter == idx + tune) {
        touchWaiter(waiter);
        return true;
      }
      return false;
    });
    nextIfEmpty();
  }

  touchWaiter(int waiter) {
    if (onTouchedWaiter != null) {
      onTouchedWaiter!(waiter);
    }
  }

  bool playAllWaiterIfMatchLast(int idx) {
    bool touched = false;
    if (waitingIdx.isNotEmpty && waitingIdx.last == idx + tune) {
      for (var waiter in waitingIdx) {
        touchWaiter(waiter + tune);
        SoundSet.play(waiter + tune);
      }
      waitingIdx.clear();
      touched = true;
    }
    nextIfEmpty();
    return touched;
  }

  nextIfEmpty() {
    while (waitingIdx.isEmpty && nextNote != null) {
      _nextNote();
    }
  }

  _run(Function()? func) async {
    if (func != null) {
      func();
    }
  }

  stop() {
    _isPlaying = false;
    _currentNoteIdx = 0;
    _run(onStop);
  }

  pause() {
    _isPlaying = false;
    _run(onPause);
  }
}
