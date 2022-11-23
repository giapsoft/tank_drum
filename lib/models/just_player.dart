import 'package:just_audio/just_audio.dart';

class JustPlayer {
  static Map<String, AudioPlayer> players = {};
  static AudioPlayer player(String path) => players[path]!;

  static final _mainPlayer = AudioPlayer();
  static Future<void> playMain(String path) async {
    await _mainPlayer.setAsset(path);
    await _mainPlayer.play();
  }

  static int currentIdx = 0;

  static playLocal(String path) async {
    await player(path).play();
  }

  static Map<String, Uri> assetPaths = {};
  static load(List<String> filePaths) async {
    // assetPaths.clear();
    // for (var player in players.values) {
    //   await player.release();
    // }
    // players.clear();
    for (var path in filePaths) {
      AudioPlayer? player = players[path];
      if (player == null) {
        final player = AudioPlayer();
        players[path] = player;
        await player.setAudioSource(AudioSource.uri(
            Uri.parse('asset:/${path.replaceFirst('assets/', '')}')));
      }
    }
  }

  static Uri getUri(String path) {
    return assetPaths[path]!;
  }
}
