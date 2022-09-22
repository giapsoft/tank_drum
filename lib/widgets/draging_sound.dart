import 'package:flutter/material.dart';

import 'sound_name_text.dart';

class DragingSound extends StatelessWidget {
  const DragingSound(this.soundName, {Key? key}) : super(key: key);
  final String soundName;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color.fromARGB(76, 255, 193, 7),
          borderRadius: BorderRadius.circular(30)),
      width: 30,
      height: 30,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(0, 255, 193, 100),
        body: Center(
          child: SoundNameText(
            soundName,
            style: const TextStyle(
              color: Color.fromARGB(94, 17, 0, 0),
            ),
          ),
        ),
      ),
    );
  }
}
