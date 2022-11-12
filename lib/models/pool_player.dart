import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';
import 'package:synchronized/extension.dart';

class PoolPlayer {
  late Soundpool pool = _createPool();

  Soundpool _createPool() {
    return Soundpool.fromOptions(
        options: const SoundpoolOptions(
      streamType: StreamType.music,
    ));
  }

  Map<String, int> setSoundId = {};
  _loadFile(String filePath, {thenPlay = false}) {
    final currentId = setSoundId[filePath];
    if (currentId == -1) {
      return;
    }
    setSoundId[filePath] = -1;
    rootBundle.load(filePath).then((soundData) async {
      if (thenPlay) {
        setSoundId[filePath] = await pool.loadAndPlay(soundData);
      } else {
        setSoundId[filePath] = await pool.load(soundData);
      }
    }).catchError((error) {
      // no need handle
      log('error when load bundle: $error');
    });
  }

  loadFiles(List<String> filePaths) {
    release();
    for (var element in filePaths) {
      _loadFile(element);
    }
  }

  release() async {
    setSoundId.clear();
    pool.release();
  }

  _play(String filePath) {
    final id = setSoundId[filePath];
    if (id != null && id > -1) {
      pool.play(id);
    } else {
      _loadFile(filePath, thenPlay: true);
    }
  }

  static const poolSize = 8;
  static PoolPlayer get nextPool {
    final idx = playerQueue.removeAt(0);
    playerQueue.add(idx);
    return getPlayer(playerQueue.first);
  }

  static final Map<int, PoolPlayer> _players = {};
  static PoolPlayer getPlayer(int poolIndex) {
    return _players[poolIndex] ??= PoolPlayer();
  }

  static playMusicSound(String filePath, {forceAsync = false}) {
    playByNextPlayer() {
      nextPool._play(filePath);
      _filePathToPlayer[filePath] = playerQueue.first;
      _playerToFilePath[playerQueue.first] = filePath;
    }

    playByPlayer(int playerIdx) {
      getPlayer(playerIdx)._play(filePath);
      playerQueue.remove(playerIdx);
      playerQueue.add(playerIdx);
    }

    playerQueue.synchronized(() {
      if (forceAsync) {
        playByNextPlayer();
        return;
      }
      final playerIdx = _getPlayerByFilePath(filePath);
      playerIdx == null ? playByNextPlayer() : playByPlayer(playerIdx);
    });
  }

  static final Map<int, String> _playerToFilePath = {};
  static final Map<String, int> _filePathToPlayer = {};

  static int? _getPlayerByFilePath(String filePath) {
    final idx = _filePathToPlayer[filePath];
    if (idx != null && _playerToFilePath[idx] == filePath) {
      return idx;
    }
    return null;
  }

  static List<int> playerQueue = List.generate(poolSize, (index) => index);

  static loadSounds(List<String> filePaths) async {
    for (int i = 0; i < poolSize; i++) {
      getPlayer(i).loadFiles(filePaths);
    }
  }

  static realeaseAllSounds() async {
    for (var player in _players.values) {
      await player.release();
    }
  }
}
