// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:tankdrum_learning/widgets/bounce_button.dart';

void main(List<String> args) {
  runApp(MaterialApp(home: OverlayTesting()));
}

class OverlayTesting extends StatefulWidget {
  const OverlayTesting({Key? key}) : super(key: key);

  @override
  State<OverlayTesting> createState() => _OverlayTestingState();
}

class _OverlayTestingState extends State<OverlayTesting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ignore: prefer_const_literals_to_create_immutables
      body: Stack(children: [
        Positioned(
            top: 100,
            left: 100,
            width: 50,
            height: 200,
            child: BounceButton(
              NoteBuilder(),
              onTrigger: () {},
            )),
      ]),
    );
  }
}

class NoteBuilder extends StatefulWidget {
  const NoteBuilder({Key? key}) : super(key: key);

  @override
  State<NoteBuilder> createState() => _NoteBuilderState();
}

class _NoteBuilderState extends State<NoteBuilder> {
  late BoxConstraints constraints;
  List<Tut>? _tuts;
  List<Tut> get tuts => _tuts ??= List.generate(10, (_) => Tut(constraints));
  int currentIdx = 0;

  trigger() {
    tuts[currentIdx++].trigger();
    if (currentIdx >= tuts.length - 1) {
      currentIdx = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      this.constraints = constraints;
      return Container(
        clipBehavior: Clip.hardEdge,
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(200),
            bottomRight: Radius.circular(200),
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              height: constraints.maxWidth,
              width: constraints.maxWidth,
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Color.fromARGB(69, 0, 0, 0), width: 3)),
              ),
            ),
            ...tuts,
          ],
        ),
      );
    });
  }
}

class Tut extends StatefulWidget {
  Tut(this.constraint, {Key? key}) : super(key: key);
  final BoxConstraints constraint;
  final List<Function()> _trigger = [];
  trigger() {
    for (var t in _trigger) {
      t();
    }
  }

  @override
  State<Tut> createState() => _TutState();
}

class _TutState extends State<Tut> {
  Duration waitingTime = Duration(seconds: 2);

  trigger() {
    setState(() {
      isRunning = true;
      Future.delayed(waitingTime).then((value) {
        setState(() {
          isRunning = false;
        });
      });
    });
  }

  bool isRunning = false;
  @override
  Widget build(BuildContext context) {
    widget._trigger.clear();
    widget._trigger.add(trigger);
    return AnimatedPositioned(
      duration: isRunning ? waitingTime : Duration(seconds: 0),
      bottom: isRunning ? 0 : widget.constraint.maxHeight,
      height: widget.constraint.maxWidth,
      width: widget.constraint.maxWidth,
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.yellow, width: 3)),
      ),
    );
  }
}
