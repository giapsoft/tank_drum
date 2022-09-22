import 'package:flutter/material.dart';

class NoteLinkType {
  static get none => NoteLinkType.from(_none);
  static get swipe => NoteLinkType.from(_swipe);
  static get one => NoteLinkType.from(_one);

  static const _none = 'N';
  static const _swipe = 'S';
  static const _one = 'O';

  IconData get iconData {
    if (isSwipe()) {
      return Icons.fingerprint;
    }
    if (isOne()) {
      return Icons.link;
    }
    return Icons.dangerous;
  }

  String type = 'N';
  NoteLinkType();
  NoteLinkType.from(this.type);

  bool isUndefined() {
    return ![_none, _swipe, _one].contains(type);
  }

  bool isNone() {
    return type == _none;
  }

  bool isSwipe() {
    return type == _swipe;
  }

  bool isOne() {
    return type == _one;
  }

  NoteLinkType next() {
    return NoteLinkType.from(getNext());
  }

  String getNext() {
    switch (type) {
      case _none:
        return _one;

      case _one:
        return _swipe;
      case _swipe:
        return _none;
    }
    return _none;
  }

  @override
  String toString() {
    return 'type: $type';
  }
}
