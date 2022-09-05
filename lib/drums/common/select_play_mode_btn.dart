import 'package:flutter/material.dart';
import 'package:tankdrum_learning/drums/drum.dart';
import 'package:tankdrum_learning/songs/song_line_ctrl.dart';
import 'package:tankdrum_learning/songs/song_sub.dart';

import '../../songs/song_ctrl.dart';

enum SongPlayMode {
  repeatSong,
  oneSong,
  repeatLine,
  oneLine,
  oneLimitNoteLine,
  repeatLimitNoteLine,
  autoNext
}

class SelectPlayModeBtn extends StatefulWidget {
  const SelectPlayModeBtn({Key? key}) : super(key: key);

  static Function() rebuild = () {};

  @override
  State<SelectPlayModeBtn> createState() => _SelectPlayModeBtnState();
}

class _SelectPlayModeBtnState extends State<SelectPlayModeBtn> {
  Widget dropDownBtn() {
    return DropdownButton<SongPlayMode>(
        underline: Container(
          height: 2,
          color: Colors.black26,
        ),
        value: SongCtrl.playMode,
        items: SongPlayMode.values
            .map((e) =>
                DropdownMenuItem<SongPlayMode>(value: e, child: Text(e.name)))
            .toList(),
        onChanged: (mode) {
          if (mode == null) {
            return;
          }
          SongCtrl.isPlaying = false;
          SongLineCtrl.resetNoteIdx();
          SongSub.rebuild();
          SongCtrl.playMode = mode;
          SongCtrl.reset();
          Drum.playingDrum.rebuildNotes();
          setState(() {});
        });
  }

  @override
  Widget build(BuildContext context) {
    SelectPlayModeBtn.rebuild = () => setState(() {});
    return SongCtrl.playingSong == null ? const SizedBox() : dropDownBtn();
  }
}
