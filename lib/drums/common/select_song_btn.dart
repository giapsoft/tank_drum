import 'package:flutter/material.dart';
import 'package:tankdrum_learning/drums/common/select_play_mode_btn.dart';
import 'package:tankdrum_learning/songs/song_ctrl.dart';
import 'package:tankdrum_learning/songs/song_lib.dart';
import 'package:tankdrum_learning/songs/song_sub.dart';

import '../tank_15n_drum.dart';
import '../../songs/song.dart';

class SelectSongBtn extends StatefulWidget {
  const SelectSongBtn(this.rebuild, {Key? key}) : super(key: key);

  final void Function() rebuild;

  @override
  State<SelectSongBtn> createState() => _SelectSongBtnState();
}

class _SelectSongBtnState extends State<SelectSongBtn> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<Song>(
        value: SongCtrl.playingSong,
        underline: Container(
          height: 2,
          color: Colors.black26,
        ),
        items: SongLib.songs
            .map((e) => DropdownMenuItem<Song>(
                  value: e,
                  child: Text(e?.name ?? 'Chọn bài'),
                ))
            .toList(),
        onChanged: (selectedSong) {
          SongCtrl.pause();
          SongCtrl.playingSong = selectedSong;
          SongCtrl.reset();
          SongSub.rebuild();
          SelectPlayModeBtn.rebuild();
          SongCtrl.resetAllNoteIdx();
          for (var note in Tank15NDrum.notes.values) {
            note.rebuild();
          }
          setState(() {
            // widget.rebuild();
          });
        });
  }
}
