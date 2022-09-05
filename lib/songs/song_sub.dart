import 'package:flutter/material.dart';
import 'package:tankdrum_learning/songs/song_ctrl.dart';
import 'package:tankdrum_learning/drums/tank_15n_drum.dart';

class SongSub extends StatefulWidget {
  const SongSub({Key? key}) : super(key: key);

  static final List<Function()> _rebuild = [];
  static rebuild() {
    for (var runnable in _rebuild) {
      runnable();
    }
  }

  @override
  State<SongSub> createState() => _SongSubState();
}

class _SongSubState extends State<SongSub> {
  @override
  Widget build(BuildContext context) {
    SongSub._rebuild.clear();
    SongSub._rebuild.add(() => setState(() {}));
    return Column(
      children: [
        SongCtrl.playingLine?.buildSub() ?? const SizedBox(),
        SongCtrl.playingLine == null ? const SizedBox() : const SubControl(),
      ],
    );
  }
}

class SubControl extends StatefulWidget {
  const SubControl({Key? key}) : super(key: key);

  @override
  State<SubControl> createState() => _SubControlState();
}

class _SubControlState extends State<SubControl> {
  @override
  Widget build(BuildContext context) {
    SongSub._rebuild.add(() => setState(() {}));
    final currentLineNo = SongCtrl.currentLineIdx + 1;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              Tank15NDrum.isMute = !Tank15NDrum.isMute;
              for (var note in Tank15NDrum.notes.values) {
                note.rebuild();
              }
            });
          },
          icon: Icon(Tank15NDrum.isMute
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined),
          color: Tank15NDrum.isMute ? Colors.black : Colors.deepOrange,
        ),
        const IconButton(
            onPressed: SongCtrl.prevLine, icon: Icon(Icons.skip_previous)),
        Text('$currentLineNo/${SongCtrl.playingLines.length}'),
        const IconButton(
            onPressed: SongCtrl.nextLine, icon: Icon(Icons.skip_next)),
        IconButton(
          icon: Icon(
              color: Colors.deepOrange,
              SongCtrl.isPlaying ? Icons.pause_circle : Icons.play_circle),
          onPressed: () {
            setState(() {});
            if (SongCtrl.isPlaying) {
              SongCtrl.pause();
            } else {
              SongCtrl.play();
            }
          },
        ),
      ],
    );
  }
}
