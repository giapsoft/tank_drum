import 'package:audioplayers/audioplayers.dart';
import 'package:synchronized/extension.dart';

class AuPlayer {
  static List<AudioCache>? _players;
  static List<AudioCache> get players => _players ??= createPlayers();
  static createPlayers() {
    return List.generate(20, (index) => AudioCache());
  }

  static final _mainPlayer = AudioPlayer();
  static final _mainCache = AudioCache();
  static Future<void> playMain(String path) async {
    final uri = await _mainCache.load(path);
    _mainPlayer.play(uri.toString(), isLocal: true);
  }

  static Future<void> play(String path, AudioPlayer? player) async {
    player ??= _mainPlayer;
    final uri = await _mainCache.load(path);
    await player.setUrl(uri.toString(), isLocal: true);
    await player.setVolume(0);
    await player.resume();
    await Future.delayed(const Duration(milliseconds: 200));
    await player.pause();
    await player.seek(Duration.zero);
    await player.setVolume(1);
    await Future.delayed(const Duration(milliseconds: 2000));
    await player.resume();
  }

  static stopMain() {
    _mainPlayer.stop();
  }

  static int currentIdx = 0;

  static playLocal(String path) async {
    path = path.replaceFirst('assets/', '');
    currentIdx.synchronized(() {
      print('idx: $currentIdx, path: $path');
      players[currentIdx++].play(path, mode: PlayerMode.LOW_LATENCY);
      if (currentIdx >= players.length) {
        currentIdx = 0;
      }
    });
  }
}
