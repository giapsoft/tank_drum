import 'package:tankdrum_learning/models/song_sentence.dart';

import 'song_note.dart';

class SongPlayer {
  List<SongSentence> sentences = [];
  List<SongNote> get notes => currentSentence?.notes ?? [];
  SongSentence? get currentSentence =>
      currentSentenceIdx >= 0 && currentSentenceIdx < sentences.length - 1
          ? sentences[currentSentenceIdx]
          : null;

  bool _isPlaying = false;
  Function()? onFinish;
  Function()? onPause;
  Function()? onPlay;
  Function()? onStop;
  Function()? onStartNote;
  Function()? onEndNote;
  Function()? onNextNote;
  Function()? onNextSentence;
  Function(int)? onTouchedIdx;
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
    this.onTouchedIdx,
    this.onNextNote,
  });

  play({
    List<SongSentence>? songSentences,
    int? bpm,
  }) {
    sentences = songSentences ?? [];
    this.bpm = bpm ?? 100;
    _currentNoteIdx = 0;
    _currentNoteIdx = 0;
    _isPlaying = true;
    _run(onPlay);
    _play();
  }

  reset({List<SongSentence>? songSentences}) {
    sentences = songSentences ?? [];
    _currentNoteIdx = 0;
    currentSentenceIdx = 0;
  }

  int _currentNoteIdx = 0;
  int currentSentenceIdx = 0;

  SongNote? get currentNote => _getNote(_currentNoteIdx);
  SongNote? get prevNote => _getNote(_currentNoteIdx - 1);
  SongNote? get nextNote => _getNote(_currentNoteIdx + 1);
  SongNote? get nextNote2 => _getNote(_currentNoteIdx + 2);
  SongNote? _getNote(int idx) {
    return (notes.isNotEmpty && notes.length > idx) ? notes[idx] : null;
  }

  _play() async {
    if (_isPlaying && sentences.length > _currentNoteIdx) {
      _run(onStartNote);
      await currentNote?.waitBpm(bpm);
      if (!isSilence) {
        currentNote?.play(tune: tune);
      }
      _run(onEndNote);
      _nextNote();
      _play();
    } else {
      _run(onFinish);
      _run(stop);
    }
  }

  List<int> waitingIdx = [];
  _nextNote() {
    if (currentSentence != null) {
      if (_currentNoteIdx < currentSentence!.notes.length - 1) {
        _currentNoteIdx++;
      } else {
        currentSentenceIdx++;
        _run(onNextSentence);
        _currentNoteIdx = 0;
      }
      waitingIdx = currentNote?.soundIdxList ?? [];
      _run(onNextNote);
    }
  }

  touchIdx(int idx) {
    waitingIdx.removeWhere((waitingIdx) {
      if (waitingIdx == idx + tune) {
        if (onTouchedIdx != null) {
          onTouchedIdx!(waitingIdx);
        }
        return true;
      }
      return false;
    });
    while (nextNote != null && waitingIdx.isEmpty) {
      _nextNote();
    }
  }

  _run(Function()? func) {
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
