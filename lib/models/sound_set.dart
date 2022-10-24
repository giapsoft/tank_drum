import 'package:flutter/material.dart';
import 'package:flutter_ogg_piano/flutter_ogg_piano.dart';
import 'package:tankdrum_learning/tank_icon_icons.dart';
import 'pool_player.dart';
import 'sound_note.dart';

class SoundSet {
  final String name; // to show the name on screen
  final String id; // to get files inside
  final String ext;
  SoundSet(this.name, this.id, this.ext);

  IconData get iconData => setIcon[name]!;

  static final fop = FlutterOggPiano();

  String _getNotePath(int noteIdx) {
    final name = SoundNote.getNoteName(noteIdx);
    return 'assets/standard_notes/$id/$name.$ext';
  }

  _play(int noteIdx) {
    PoolPlayer.playMusicSound(noteIdx, _getNotePath(noteIdx));
  }

  static final tankDrum = SoundSet('Tank Drum', 'tankdrum', 'mp3');
  static final piano = SoundSet('Piano', 'piano', 'ogg');
  static final kalimba = SoundSet('Kalimba', 'kalimba', 'mp3');
  static final lyre = SoundSet('Lyre Harp', 'harp', 'ogg');
  static final guzheng = SoundSet('Guzheng', 'guzheng', 'mp3');
  static final allSet = {
    kalimba.name: kalimba,
    guzheng.name: guzheng,
    tankDrum.name: tankDrum,
    lyre.name: lyre,
    piano.name: piano
  };
  static SoundSet getSet(String name) => allSet[name]!;
  static final setIcon = {
    kalimba.name: TankIcon.sound_kalimba,
    guzheng.name: TankIcon.sound_guzheng,
    tankDrum.name: TankIcon.sound_tank_drum,
    lyre.name: TankIcon.sound_lyre_harp,
    piano.name: TankIcon.sound_piano,
  };

  static SoundSet _current = tankDrum;
  static SoundSet get current => _current;
  static set current(SoundSet soundSet) {
    _current = soundSet;
    loadCurrentSet();
  }

  static loadCurrentSet() {
    List<String> paths = [];
    List<int> idxList = [];
    for (int i = SoundNote.getNoteIdx('C3');
        i <= SoundNote.getNoteIdx('B6');
        i++) {
      paths.add(current._getNotePath(i));
      idxList.add(i);
    }
    PoolPlayer.loadSounds(idxList, paths);
  }

  static play(int soundIdx) {
    current._play(soundIdx);
  }
}
