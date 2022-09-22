import 'package:flutter/material.dart';
import 'package:g_pages/pages.dart';
import 'package:get/get.dart';

import '../../models/sound_set.dart';
import '../sound_name_text.dart';

part 'sound_note._.dart';
part 'sound_note.uc.dart';

class SoundNoteUb extends _SoundNote$Ub {
  SoundNoteUb(this.soundName,
      {this.onTouchPlay,
      this.size = 50,
      this.padding = 0.0,
      this.paddingText = 0.0});
  Function()? onTouchPlay;
  final String soundName;
  final double size;
  final double padding;
  final double paddingText;
  final isActive = false.obs;
  final isWaiter = false.obs;

  static Color getColor(bool isActive, bool isWaiter) {
    return (isActive && isWaiter)
        ? const Color.fromARGB(255, 112, 7, 7)
        : isActive
            ? const Color.fromARGB(255, 255, 39, 39)
            : isWaiter
                ? const Color.fromARGB(255, 255, 81, 81)
                : const Color.fromARGB(160, 83, 90, 87);
  }

  Color color() => getColor(isActive.value, isWaiter.value);

  waiter() {
    isWaiter.value = true;
  }

  active() {
    isActive.value = true;
    isWaiter.value = false;
  }

  inactive() {
    if (isActive.isTrue) {
      isActive.value = false;
    }

    if (isWaiter.isTrue) {
      isWaiter.value = false;
    }
  }

  @override
  Widget build() {
    return GestureDetector(
      onTap: ctrl.play,
      child: buildView(),
    );
  }

  Widget buildView() {
    return SizedBox(
      width: size,
      height: size,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: _BouncingButton(
            isActive: isActive,
            Padding(
                padding: EdgeInsets.all(paddingText),
                child: SoundNameText(
                  soundName,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                )),
            size,
            ctrl.setAnimationTrigger,
            color),
      ),
    );
  }
}

class _BouncingButton extends StatefulWidget {
  const _BouncingButton(
      this.soundName, this.size, this.setBouncingTrigger, this.color,
      {Key? key, required this.isActive})
      : super(key: key);
  final RxBool isActive;
  final Widget soundName;
  final double size;
  final Function(Function()) setBouncingTrigger;
  final Color Function() color;

  @override
  State<_BouncingButton> createState() => _BouncingButtonState();
}

class _BouncingButtonState extends State<_BouncingButton>
    with SingleTickerProviderStateMixin {
  double _scale = 0;
  late AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 50,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  trigger() async {
    _controller.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    widget.setBouncingTrigger(trigger);
    return Transform.scale(
      scale: _scale,
      child: SizedBox(
          width: widget.size * _scale,
          height: widget.size * _scale,
          child: _animatedButtonUI),
    );
  }

  Widget get _animatedButtonUI => Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
            border: Border.all(
                color: const Color.fromARGB(80, 110, 110, 110), width: 2)),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(0.05 * widget.size),
            child: Obx(() => Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: widget.color()),
                  child: Center(
                    child: widget.soundName,
                  ),
                )),
          ),
        ),
      );
}
