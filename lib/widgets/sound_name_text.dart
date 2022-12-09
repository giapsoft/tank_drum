import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tekartik_midi/midi.dart';
import 'package:tekartik_midi/midi_parser.dart';

class SoundNameText extends StatelessWidget {
  const SoundNameText(this.soundName,
      {this.style, this.isVertical, this.showIdx = true, Key? key})
      : super(key: key);
  final String soundName;
  final bool showIdx;
  final TextStyle? style;
  final bool? isVertical;

  TextStyle get textStyle =>
      style ?? const TextStyle(color: Color.fromARGB(255, 255, 255, 255));
  String get firstLetter => soundName.isNotEmpty ? soundName[0] : "";
  String get remainLetters => showIdx
      ? soundName.substring(1)
      : soundName.substring(1, soundName.length - 1);

  @override
  Widget build(BuildContext context) {
    return soundName.isEmpty ? const SizedBox() : buildSoundName();
  }

  buildSoundName() {
    return (isVertical ?? false) ? buildVertical() : buildNormal();
  }

  buildVertical() {
    return FittedBox(
      fit: BoxFit.contain,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(firstLetter),
          ...remainLetters.split("").map((e) => Text(e)).toList()
        ],
      ),
    );
  }

  buildNormal() => Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
              flex: remainLetters.isNotEmpty ? 2 ~/ remainLetters.length : 1,
              child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Text(
                    firstLetter,
                    style: textStyle,
                  ))),
          Expanded(
              flex: 1,
              child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Transform.translate(
                    offset: const Offset(-4.0, 2.0),
                    child: Text(
                      remainLetters,
                      style: textStyle,
                    ),
                  ))),
        ],
      ));
}
