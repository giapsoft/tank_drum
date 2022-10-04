import 'package:flutter/material.dart';
import 'package:tankdrum_learning/models/sound_note.dart';
import 'package:tankdrum_learning/models/sound_set.dart';

class TestPitch extends StatefulWidget {
  const TestPitch({Key? key}) : super(key: key);

  @override
  State<TestPitch> createState() => _TestPitchState();
}

class _TestPitchState extends State<TestPitch> {
  String currentSet = SoundSet.current.name;
  int baseIdx = 30;
  int pitch = 0;
  int editPitch = 0;

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      buildBaseIdx(),
      buildPitch(),
      buildEditPitch(),
    ]);
    // return MaterialApp(
    //   home: SafeArea(
    //     child: Scaffold(
    //       body: Wrap(children: [
    //         buildSelectSoundSet(),
    //         buildBaseIdx(),
    //         buildPitch(),
    //         buildEditPitch(),
    //       ]),
    //     ),
    //   ),
    // );
  }

  Widget buildSelectSoundSet() {
    return DropdownButton<String>(
        value: currentSet,
        items: SoundSet.allSet.keys
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (soundSet) {
          if (soundSet != null) {
            setState(() {
              currentSet = soundSet;
              SoundSet.current = SoundSet.allSet[soundSet]!;
            });
          }
        });
  }

  Widget buildBaseIdx() {
    return buildNumber(
      () => '$baseIdx, ${SoundNote.getNoteName(baseIdx)}',
      !SoundSet.hasBase(baseIdx) ? null : () => SoundSet.play(baseIdx),
      () => baseIdx++,
      () => baseIdx--,
    );
  }

  Widget buildPitch() {
    return buildNumber(
      () => '$pitch, ${SoundNote.getNoteName(baseIdx + pitch)}',
      () => SoundSet.playPitch(baseIdx, pitch),
      () => pitch++,
      () => pitch--,
    );
  }

  Widget buildEditPitch() {
    return buildNumber(
      () => '$editPitch',
      SoundSet.hasBase(baseIdx + pitch + editPitch)
          ? () => SoundSet.playPitch(baseIdx + pitch + editPitch, 0)
          : null,
      () => editPitch++,
      () => editPitch--,
    );
  }

  Widget buildPlay(Function()? play) {
    return play == null
        ? const SizedBox()
        : IconButton(onPressed: play, icon: const Icon(Icons.play_arrow));
  }

  buildNumber(String Function() text, Function()? play, Function() up,
      Function() down) {
    return Wrap(children: [
      Ink(
        decoration: const ShapeDecoration(
          color: Colors.lightBlue,
          shape: CircleBorder(),
        ),
        child: IconButton(
          splashRadius: 24,
          splashColor: Colors.lightBlueAccent,
          onPressed: () {
            setState(() {
              up();
            });
          },
          icon: const Icon(
            Icons.arrow_upward,
            color: Colors.white70,
          ),
        ),
      ),
      const Padding(padding: EdgeInsets.fromLTRB(6, 0, 6, 0)),
      Container(
        width: 72,
        height: 36,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[100],
            boxShadow: [
              BoxShadow(
                  offset: const Offset(4, 4),
                  blurRadius: 4,
                  color: Colors.grey[600]!)
            ]),
        child: Center(
          child: Text(text()),
        ),
      ),
      const Padding(padding: EdgeInsets.fromLTRB(6, 0, 6, 0)),
      Ink(
        decoration: const ShapeDecoration(
          color: Colors.lightBlue,
          shape: CircleBorder(),
        ),
        child: IconButton(
          splashRadius: 24,
          splashColor: Colors.lightBlueAccent,
          onPressed: () {
            setState(() {
              down();
            });
          },
          icon: const Icon(
            Icons.arrow_downward,
            color: Colors.white70,
          ),
        ),
      ),
      buildPlay(play),
    ]);
  }
}
