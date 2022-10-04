import 'dart:math';

import 'package:flutter/material.dart';
import 'package:g_pages/pages.dart';
import 'package:get/get.dart';
import 'package:tankdrum_learning/models/instruments/instrument_note.dart';
import 'package:tankdrum_learning/models/sound_note.dart';

import '../../models/sound_set.dart';
import '../sound_name_text.dart';

part 'sound_note._.dart';
part 'sound_note.uc.dart';

class SoundNoteUb extends _SoundNote$Ub {
  SoundNoteUb(this.soundIdx,
      {this.onTouchPlay,
      this.width = 50,
      this.height = 50,
      this.padding = 0.0,
      this.borderPadding,
      this.borderRadius,
      this.instrumentNote,
      this.paddingText = 0.0});
  final InstrumentNote? instrumentNote;
  Function()? onTouchPlay;
  int soundIdx;
  final double width;
  final double height;
  final double padding;
  final double paddingText;
  final isActive = false.obs;
  final isWaiter = false.obs;
  final EdgeInsets? borderPadding;
  final BorderRadiusGeometry? borderRadius;

  String get soundName => SoundNote.getNoteName(soundIdx);

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
    return Listener(
      onPointerDown: (p) {
        ctrl.play();
      },
      child: buildView(),
    );
  }

  Widget buildView() {
    return SizedBox(
      width: width,
      height: height,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: _BouncingButton(this),
      ),
    );
  }
}

class _BouncingButton extends StatefulWidget {
  const _BouncingButton(this.soundBuilder, {Key? key}) : super(key: key);
  final SoundNoteUb soundBuilder;

  @override
  State<_BouncingButton> createState() => _BouncingButtonState();
}

class _BouncingButtonState extends State<_BouncingButton>
    with SingleTickerProviderStateMixin {
  double _scale = 0;
  late AnimationController _controller;
  SoundNoteUb get soundBuilder => widget.soundBuilder;
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
    soundBuilder.ctrl.setAnimationTrigger(trigger);
    return Transform.scale(
      scale: _scale,
      child: SizedBox(
          width: soundBuilder.width * _scale,
          height: soundBuilder.height * _scale,
          child: _animatedButtonUI),
    );
  }

  get borderRadius =>
      soundBuilder.borderRadius ??
      const BorderRadius.only(
          bottomLeft: Radius.circular(200), bottomRight: Radius.circular(200));

  get padding => 0.05 * min(soundBuilder.width, soundBuilder.height);

  Widget get _animatedButtonUI => Container(
        decoration: BoxDecoration(
            borderRadius: borderRadius,
            border: Border.all(
                color: const Color.fromARGB(80, 110, 110, 110), width: 2)),
        child: Center(
          child: Padding(
            padding: soundBuilder.borderPadding ?? EdgeInsets.all(padding),
            child: Obx(() => Container(
                  width: soundBuilder.width,
                  height: soundBuilder.height,
                  decoration: BoxDecoration(
                      borderRadius: borderRadius, color: soundBuilder.color()),
                  child: soundBuilder.instrumentNote?.nameBuilder() ??
                      Center(
                        child: SoundNameText(soundBuilder.soundName),
                      ),
                )),
          ),
        ),
      );
}
