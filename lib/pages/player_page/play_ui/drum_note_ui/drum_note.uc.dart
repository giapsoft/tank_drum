part of '../../player.page.dart';

class _DrumNoteUc extends _DrumNote$Ctrl {
  DrumNote get drumNote =>
      Drum.current.getDrumNoteBySoundName(builder.soundName);
  static const totalTuts = 10;

  late SoundNoteUb soundBuilder;
  @override
  postConstruct() {
    soundBuilder = SoundNoteUb(builder.soundName,
        paddingText: 6, onTouchPlay: builder.onTouchPlay);
  }

  List<_NoteTutUb>? _tuts;
  List<_NoteTutUb> get tuts => _tuts ??= genTuts();
  List<_NoteTutUb> genTuts() {
    final t = <_NoteTutUb>[];
    for (int i = 0; i < totalTuts; i++) {
      t.add(_NoteTutUb(drumNote, i));
    }
    return t;
  }

  int _readyIdx = 0;

  _NoteTutUb pickTut() {
    final result = tuts[_readyIdx];
    if (_readyIdx == tuts.length - 1) {
      _readyIdx = 0;
    } else {
      _readyIdx++;
    }
    return result;
  }

  play() async {
    soundBuilder.ctrl.play();
  }

  bool isSwipedIn = false;

  bool inBody = false;
  bool fromIn = false;
  swipe(Offset pos) {
    if (drumNote.pos.isInBody(pos)) {
      if (!inBody) {
        inBody = true;
        doSwipedIn();
      }
    } else if (drumNote.pos.isInBorder(pos)) {
      inBody = false;
    }
  }

  doSwipedIn() {
    play();
  }
}
