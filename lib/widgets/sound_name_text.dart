import 'package:flutter/material.dart';

class SoundNameText extends StatelessWidget {
  const SoundNameText(this.soundName, {this.style, Key? key}) : super(key: key);
  final String soundName;
  final TextStyle? style;

  TextStyle get textStyle =>
      style ?? const TextStyle(color: Color.fromARGB(255, 255, 255, 255));
  String get firstLetter => soundName.isNotEmpty ? soundName[0] : "";
  String get remainLetters =>
      soundName.length > 1 ? soundName.substring(1) : "";

  @override
  Widget build(BuildContext context) {
    return soundName.isEmpty
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                    flex: remainLetters.isNotEmpty
                        ? 2 ~/ remainLetters.length
                        : 1,
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
                          offset: const Offset(-2.0, 2.0),
                          child: Text(
                            remainLetters,
                            style: textStyle,
                          ),
                        ))),
              ],
            ),
          );
  }
}
