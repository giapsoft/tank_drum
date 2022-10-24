import 'package:flutter/cupertino.dart';
import 'package:tankdrum_learning/tank_icon_icons.dart';

class PlayMode {
  const PlayMode() : _mode = 'free';
  const PlayMode._(this._mode);
  static const live = PlayMode._('live');
  static const training = PlayMode._('training');
  static const auto = PlayMode._('auto');
  static const free = PlayMode();
  static const tuning = PlayMode._('tuning');
  final String _mode;

  bool get isLive => _mode == 'live';
  bool get isTraining => _mode == 'training';
  bool get isAuto => _mode == 'auto';
  bool get isTuning => _mode == 'tuning';
  bool get isFree => _mode == 'free';

  static const icons = {
    'free': TankIcon.song_finder,
    'live': TankIcon.playmode_live,
    'training': TankIcon.playmode_training,
    'auto': TankIcon.playmode_auto,
    'tuning': TankIcon.playmode_tuning,
  };

  IconData get iconData => icons[_mode]!;
}
