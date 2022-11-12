import 'package:flutter/material.dart';

class BounceButton extends StatefulWidget {
  BounceButton(this.child, {required this.onTrigger, Key? key})
      : super(key: key);
  final Widget child;
  final Function() onTrigger;
  final List<Function()> _trigger = [];
  trigger() {
    onTrigger();
    for (var t in _trigger) {
      t();
    }
  }

  @override
  State<BounceButton> createState() => _BounceButtonState();
}

class _BounceButtonState extends State<BounceButton>
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
    widget._trigger.clear();
    widget._trigger.add(trigger);
    _scale = 1 - _controller.value;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Transform.scale(
          scale: _scale,
          child: SizedBox(
            width: constraints.maxWidth * _scale,
            height: constraints.maxHeight * _scale,
            child: widget.child,
          ),
        );
      },
    );
  }
}
