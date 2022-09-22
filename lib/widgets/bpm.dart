import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Bpm extends StatelessWidget {
  const Bpm(this.bpm, {Key? key}) : super(key: key);
  final RxInt bpm;

  isOutOfRange() {
    return bpm.value < 60 || bpm.value > 300;
  }

  @override
  Widget build(BuildContext context) {
    if (isOutOfRange()) {
      bpm.value = 120;
    }
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Obx(() => isOutOfRange()
          ? const SizedBox()
          : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('bpm: $bpm'),
              SizedBox(
                width: 100,
                child: Slider(
                    value: bpm.toDouble(),
                    divisions: 241,
                    min: 60,
                    max: 300,
                    onChanged: ((value) => bpm.value = value.toInt())),
              )
            ])),
    );
  }
}
