import 'package:flutter/services.dart';
import 'package:flutter_ogg_piano/flutter_ogg_piano.dart';
import 'package:synchronized/extension.dart';

class OggPlayer {
  final fop = FlutterOggPiano();
  OggPlayer() {
    fop.init(mode: MODE.LOW_LATENCY);
  }

  static final _current = OggPlayer();

  final Map<String, int> loadedPaths = {};

  static load(List<String> filePaths) async {
    await 'loadPaths'.synchronized(() async {
      int currentLength = _current.loadedPaths.length + 1;
      for (final path in filePaths) {
        final idx = _current.loadedPaths[path] ??= -1;
        if (idx < 0) {
          ByteData data = await rootBundle.load(path);
          _current.loadedPaths[path] = currentLength++;
          final parts = path.split('/');
          final noteName = parts.removeLast();
          final setId = parts.removeLast();
          final name = '$setId-$noteName';
          await _current.fop.load(
              src: data,
              name: name,
              index: _current.loadedPaths[path]!,
              forceLoad: true);
        }
      }
    });
  }

  static play(String filePath, int pitch) async {
    final idx = _current.loadedPaths[filePath];
    if (idx == null || idx < 0) {
      return;
    }
    await _current.fop
        .play(index: _current.loadedPaths[filePath]!, note: pitch);
  }
}
