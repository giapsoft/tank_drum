import 'package:flutter_ogg_piano/flutter_ogg_piano.dart';
import 'ogg_player.dart';
import 'sound_note.dart';

class SoundSet {
  final String name; // to show the name on screen
  final String id; // to get files inside
  SoundSet(this.name, this.id, String baseNotes)
      : baseIdxList =
            baseNotes.split(',').map((e) => SoundNote.getNoteIdx(e)).toList() {
    baseIdxList.sort();
    minIdx = baseIdxList.first;
    maxIdx = baseIdxList.last;
  }
  int minIdx = 0;
  int maxIdx = 0;
  List<int> baseIdxList;

  static final fop = FlutterOggPiano();

  String _getNotePath(int noteIdx) {
    final name = SoundNote.getNoteName(noteIdx);
    return 'assets/note_sounds/$id/$name.ogg';
  }

  _play(int noteIdx) {
    final pitchs = _getPitch(noteIdx);
    OggPlayer.play(_getNotePath(pitchs[0]), pitchs[1]);
  }

  final Map<int, List<int>> _pitchs = {};
  List<int> _getPitch(int noteIdx) =>
      _pitchs[noteIdx] ??= _calculatePitch(noteIdx);

  List<int> _calculatePitch(int noteIdx) {
    if (baseIdxList.contains(noteIdx)) {
      return [noteIdx, 0];
    }
    int baseIdx = 0;
    if (noteIdx < minIdx) {
      baseIdx = baseIdxList.firstWhere(
          (e) => e - 12 * ((minIdx - noteIdx) / 12).ceil() >= noteIdx);
    } else if (noteIdx > maxIdx) {
      baseIdx = baseIdxList.firstWhere(
          (e) => e + 12 * ((noteIdx - maxIdx) / 12).ceil() >= noteIdx);
    } else {
      baseIdx = baseIdxList.reversed.firstWhere((e) => e <= noteIdx);
    }
    int pitch = noteIdx - baseIdx;
    return [baseIdx, pitch];
  }

  static final tankDrum = SoundSet('Tank Drum', 'tankdrum',
      'A3,A4,B3,B4,C#4,C#5,D4,D5,E4,F#3,F#4,F#5,G3,G4');
  static final kalimba = SoundSet('Kalimba', 'kalimba',
      'G5,G#6,G#5,F5,F4,F#5,F#4,E5,E4,D5,D4,D#5,D#4,C5,C4,C#5,C#4,B5,B4,A5,A4,A#5,A#4');
  static final kalimbaLite =
      SoundSet('Kalimba Lite', 'kalimba', 'F4,F#4,E4,D4,D#4,C4,C#4,B4,A4,A#4');
  static final harp = SoundSet('Harp', 'harp',
      'A#3,A#4,A#5,A#6,A3,A4,A5,A6,B3,B4,B5,B6,C#4,C#5,C#6,C4,C5,C6,D#4,D#5,D#6,D4,D5,D6,E4,E5,E6,F#3,F#4,F#5,F#6,F4,F5,F6,G#3,G#4,G#5,G#6,G3,G4,G5,G6');
  static final harpLite =
      SoundSet('Harp Lite', 'harp', 'A4,A#4,B4,C4,C#4,D4,D#4,E4,F4,F#4,G4,G#4');
  static final guzheng = SoundSet('Guzheng', 'guzheng',
      'A#4,A#5,A3,A4,A5,B3,B4,B5,C5,C6,D#5,D2,D4,D5,D6,E3,E4,E5,F#3,F#4,F#5,F5');
  static final kalimbaReverb = SoundSet('Kalimba Reverb', 'kalimba_reverb',
      "A#4,A#5,A5,B4,B5,C#5,C5,D#4,D#5,D5,E5,F#5,F4,F5,G#4,G#5,G4,G5");
  static final steelDrum = SoundSet('Steel Drum', 'steeldrum',
      'A#4,A#5,A#6,A4,A5,A6,B4,B5,B6,C#5,C#6,C5,C6,D#5,D#6,D5,D6,E5,E6,F#4,F#5,F#6,F5,F6,G#4,G#5,G#6,G4,G5,G6');
  static final steelDrumLite = SoundSet('Steel Drum Lite', 'steeldrum',
      'A#4,A4,B4,C#5,C5,D#5,D5,E5,F5,F#5,G5,G#5');
  static final allSet = {
    kalimba.name: kalimba,
    kalimbaLite.name: kalimbaLite,
    kalimbaReverb.name: kalimbaReverb,
    guzheng.name: guzheng,
    tankDrum.name: tankDrum,
    harp.name: harp,
    harpLite.name: harpLite,
    steelDrum.name: steelDrum,
    steelDrumLite.name: steelDrumLite,
  };

  static bool hasBase(int noteIdx) {
    return current.baseIdxList.contains(noteIdx);
  }

  static SoundSet _current = tankDrum;
  static SoundSet get current => _current;
  static set current(SoundSet soundSet) {
    _current = soundSet;
    current.loadCurrentSet();
  }

  loadCurrentSet() {
    OggPlayer.load(baseIdxList.map((e) => _getNotePath(e)).toList());
  }

  static play(int soundIdx) {
    current._play(soundIdx);
  }

  static playPitch(int soundIdx, int pitch) {
    OggPlayer.play(current._getNotePath(soundIdx), pitch);
  }
}
