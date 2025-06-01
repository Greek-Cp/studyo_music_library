import 'dart:async';
import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'sound_enums.dart';
import 'sound_paths.dart';

final RouteObserver<PageRoute<dynamic>> routeObserver =
    RouteObserver<PageRoute<dynamic>>();

/// Type of sound to be played
enum SoundType {
  background,
  balance,
  bubble,
  cheering,
  click,
  clip,
  coins,
  deny,
  fail,
  levelup,
  login,
  messages,
  petsCleaning,
  petsEat,
  petsPlay,
  petsShortReactions,
  pickup,
  reminders,
  resources,
  review,
  send,
  success,
  tap,
  tetris,
  transitions,
  whoosh,
}

/// ─────────────────────────────────────────────────────────────────────────────
///  UTIL
String _relative(String full) =>
    full.replaceFirst('packages/studyo_music_library/assets/', '');

void _logVol(double v) =>
    debugPrint('[BGM] 🔊 volume → ${v.toStringAsFixed(2)}');

/// ─────────────────────────────────────────────────────────────────────────────
///  ONE-SHOT PLAY + DUCKING HOOK
Future<void> playOneShot(String absPath, {double volume = 1}) async {
  try {
    BgmManager.instance.duckStart();
    final rel = _relative(absPath);
    AudioPlayer? player;

    try {
      player = AudioPlayer();

      // Set audioCache dengan prefix untuk package assets
      player.audioCache =
          AudioCache(prefix: 'packages/studyo_music_library/assets/');

      // Preload audio untuk mengurangi delay
      await player.audioCache?.load(rel);

      // Set mode low latency untuk responsivitas maksimal
      await player.setPlayerMode(PlayerMode.lowLatency);

      // Optimize audio context untuk responsivitas
      await player.setAudioContext(
        AudioContext(
          android: AudioContextAndroid(
            isSpeakerphoneOn: false,
            stayAwake: false,
            contentType: AndroidContentType.sonification,
            usageType: AndroidUsageType.game,
            audioFocus: AndroidAudioFocus.gainTransientMayDuck,
          ),
        ),
      );

      // Set source dan volume sebelum resume untuk mengurangi delay
      await player.setSource(AssetSource(rel));
      await player.setVolume(volume);

      // Resume segera setelah setup selesai
      await player.resume();

      // Setup auto-cleanup yang lebih cepat
      player.onPlayerComplete.listen((_) {
        player?.dispose();
        BgmManager.instance.duckEnd();
      });

      // Fallback cleanup yang lebih cepat
      Timer(const Duration(milliseconds: 500), () {
        player?.dispose();
        BgmManager.instance.duckEnd();
      });
    } catch (e) {
      // Fallback ke FlameAudio dengan optimisasi
      try {
        final flamePlayer = await FlameAudio.play(rel, volume: volume);
        flamePlayer.onPlayerComplete.listen((_) {
          BgmManager.instance.duckEnd();
        });
        Timer(const Duration(milliseconds: 500), () {
          BgmManager.instance.duckEnd();
        });
      } catch (e) {
        BgmManager.instance.duckEnd();
      }
    }
  } catch (e) {
    BgmManager.instance.duckEnd();
  }
}

/// ─────────────────────────────────────────────────────────────────────────────
///  EXTENSIONS
// ─────────────────────────────────────────────────────────────────────────────
//  EXTENSIONS
extension SoundExtension on Widget {
  /// [sound]         → enum sesuai `type`
  /// [type]          → click | sfx | notification
  /// [volume]        → 0.0 – 1.0  (default 1.0)
  /// [isDragWidget]  → true jika widget ini Draggable/sejenis
  Widget addSound(
    dynamic sound,
    SoundType type, {
    double volume = 1.0,
    bool isDragWidget = false,
  }) {
    late final String path;
    switch (type) {
      case SoundType.background:
        path =
            SoundPaths.instance.SoundBackgroundPaths[sound as SoundBackground]!;
        break;
      case SoundType.balance:
        path = SoundPaths.instance.balanceSoundPaths[sound as SoundBalance]!;
        break;
      case SoundType.bubble:
        path = SoundPaths.instance.bubbleSoundPaths[sound as SoundBubble]!;
        break;
      case SoundType.cheering:
        path = SoundPaths.instance.cheeringSoundPaths[sound as SoundCheering]!;
        break;
      case SoundType.click:
        path = SoundPaths.instance.clickSoundPaths[sound as SoundClick]!;
        break;
      case SoundType.clip:
        path = SoundPaths.instance.clipSoundPaths[sound as SoundClip]!;
        break;
      case SoundType.coins:
        path = SoundPaths.instance.coinsSoundPaths[sound as SoundCoins]!;
        break;
      case SoundType.deny:
        path = SoundPaths.instance.denySoundPaths[sound as SoundDeny]!;
        break;
      case SoundType.fail:
        path = SoundPaths.instance.failSoundPaths[sound as SoundFail]!;
        break;
      case SoundType.levelup:
        path = SoundPaths.instance.levelupSoundPaths[sound as SoundLevelup]!;
        break;
      case SoundType.login:
        path = SoundPaths.instance.loginSoundPaths[sound as SoundLogin]!;
        break;
      case SoundType.messages:
        path = SoundPaths.instance.messagesSoundPaths[sound as SoundMessages]!;
        break;
      case SoundType.petsCleaning:
        path = SoundPaths
            .instance.pets_cleaningSoundPaths[sound as SoundPetsCleaning]!;
        break;
      case SoundType.petsEat:
        path = SoundPaths.instance.pets_eatSoundPaths[sound as SoundPetsEat]!;
        break;
      case SoundType.petsPlay:
        path = SoundPaths.instance.pets_playSoundPaths[sound as SoundPetsPlay]!;
        break;
      case SoundType.petsShortReactions:
        path = SoundPaths.instance
            .pets_short_reactionsSoundPaths[sound as SoundPetsShortReactions]!;
        break;
      case SoundType.pickup:
        path = SoundPaths.instance.pickupSoundPaths[sound as SoundPickup]!;
        break;
      case SoundType.reminders:
        path =
            SoundPaths.instance.remindersSoundPaths[sound as SoundReminders]!;
        break;
      case SoundType.resources:
        path =
            SoundPaths.instance.resourcesSoundPaths[sound as SoundResources]!;
        break;
      case SoundType.review:
        path = SoundPaths.instance.reviewSoundPaths[sound as SoundReview]!;
        break;
      case SoundType.send:
        path = SoundPaths.instance.sendSoundPaths[sound as SoundSend]!;
        break;
      case SoundType.success:
        path = SoundPaths.instance.successSoundPaths[sound as SoundSuccess]!;
        break;
      case SoundType.tap:
        path = SoundPaths.instance.tapSoundPaths[sound as SoundTAP]!;
        break;
      case SoundType.tetris:
        path = SoundPaths.instance.tetrisSoundPaths[sound as SoundTetris]!;
        break;
      case SoundType.transitions:
        path = SoundPaths
            .instance.transitionsSoundPaths[sound as SoundTransitions]!;
        break;
      case SoundType.whoosh:
        path = SoundPaths.instance.whooshSoundPaths[sound as SoundWhoosh]!;
        break;
    }

    if (isDragWidget) {
      return _DragSoundWrapper(
        path: path,
        volume: volume,
        type: type,
        child: this,
      );
    }

    // Draggable → Listener (tidak mengganggu gesture internal)
    if (isDragWidget) {
      return _DragSoundWrapper(
        path: path,
        volume: volume,
        type: type,
        child: this,
      );
    }

    // Default (tap)
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (_) => playOneShot(path, volume: volume),
      child: this,
    );
  }
}

class _DragSoundWrapper extends StatefulWidget {
  final Widget child;
  final String path;
  final double volume;
  final SoundType type;

  const _DragSoundWrapper({
    required this.child,
    required this.path,
    required this.volume,
    required this.type,
  });

  @override
  State<_DragSoundWrapper> createState() => _DragSoundWrapperState();
}

class _DragSoundWrapperState extends State<_DragSoundWrapper> {
  DateTime? _lastPlayTime;
  static const _minInterval = Duration(milliseconds: 50);
  Offset? _lastPosition;
  bool _isDragging = false;
  double _lastVelocity = 0;
  static const _minVelocityThreshold =
      300.0; // Minimum velocity untuk memainkan whoosh
  static const _maxVelocityThreshold =
      2000.0; // Maximum velocity untuk scaling volume
  bool _hasPlayedWhooshInCurrentDrag =
      false; // Flag untuk memastikan whoosh hanya dimainkan sekali per drag

  void _onPointerDown(PointerDownEvent event) {
    final now = DateTime.now();
    if (_lastPlayTime == null ||
        now.difference(_lastPlayTime!) > _minInterval) {
      _lastPlayTime = now;
      _lastPosition = event.position;
      playOneShot(widget.path, volume: widget.volume);
    }
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (!_isDragging) {
      _isDragging = true;
      return;
    }

    if (_lastPosition != null) {
      final now = DateTime.now();
      final deltaTime =
          now.difference(_lastPlayTime ?? now).inMilliseconds / 1000.0;
      if (deltaTime > 0) {
        final deltaPosition = event.position - _lastPosition!;
        final velocity = deltaPosition.distance / deltaTime;
        _lastVelocity = velocity;

        // Mainkan whoosh hanya saat drag dengan kecepatan tinggi
        if (!_hasPlayedWhooshInCurrentDrag &&
            velocity > _minVelocityThreshold &&
            deltaPosition.distance > 5) {
          // Minimal jarak pergerakan
          final volumeScale = math.min(
              (velocity - _minVelocityThreshold) /
                  (_maxVelocityThreshold - _minVelocityThreshold),
              1.0);
          final whooshVolume = 0.3 + (volumeScale * 0.4);

          // Hanya mainkan whoosh jika kecepatan cukup tinggi
          if (velocity > 10) {
            // Threshold kecepatan yang lebih tinggi
            playOneShot(
              SoundPaths
                  .instance.whooshSoundPaths[SoundWhoosh.whooshAccelerate]!,
              volume: widget.volume * whooshVolume,
            );

            _hasPlayedWhooshInCurrentDrag = true;
          }
        }
      }
      _lastPosition = event.position;
      _lastPlayTime = now;
    }
  }

  void _onPointerUp(PointerUpEvent event) {
    if (_isDragging) {
      // Mainkan suara click saat drop dengan volume yang menyesuaikan kecepatan
      final dropVolume = math.min(_lastVelocity / _maxVelocityThreshold, 1.0);
      final clickVolume = 0.4 + (dropVolume * 0.3); // Volume antara 0.4 - 0.7

      playOneShot(
        SoundPaths.instance.clipSoundPaths[SoundClip.itemGetsDropped]!,
        volume: widget.volume * clickVolume,
      );
    }

    _isDragging = false;
    _lastPosition = null;
    _lastVelocity = 0;
    _hasPlayedWhooshInCurrentDrag = false; // Reset flag untuk drag berikutnya
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: _onPointerDown,
      onPointerMove: _onPointerMove,
      onPointerUp: _onPointerUp,
      child: widget.child,
    );
  }
}

/// ─────────────────────────────────────────────────────────────────────────────
///  BGM EXTENSION
extension BgmExtension on Widget {
  Widget addBGM(SoundBackground bgm) => _BgmWrapper(child: this, bgm: bgm);
}

/// ─────────────────────────────────────────────────────────────────────────────
///  BGM GLOBAL EXTENSION
extension BgmGlobalExtension on Widget {
  Widget addBGMGlobal(List<SoundBackground> listSound) => _BgmGlobalWrapper(
        child: this,
        listSound: listSound,
      );
}

class _BgmWrapper extends StatefulWidget {
  const _BgmWrapper({required this.child, required this.bgm});
  final Widget child;
  final SoundBackground bgm;
  @override
  State<_BgmWrapper> createState() => _BgmWrapperState();
}

class _BgmWrapperState extends State<_BgmWrapper> with RouteAware {
  @override
  void initState() {
    super.initState();
    BgmManager.instance.push(widget.bgm);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    BgmManager.instance.pop(widget.bgm);
    super.dispose();
  }

  @override
  void didPushNext() {
    // Ketika page ini di-push oleh page lain, pause BGM
    BgmManager.instance.pauseForNavigation();
  }

  @override
  void didPopNext() {
    // Ketika kembali ke page ini, resume BGM
    BgmManager.instance.resumeFromNavigation();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class _BgmGlobalWrapper extends StatefulWidget {
  const _BgmGlobalWrapper({
    required this.child,
    required this.listSound,
  });
  final Widget child;
  final List<SoundBackground> listSound;
  @override
  State<_BgmGlobalWrapper> createState() => _BgmGlobalWrapperState();
}

class _BgmGlobalWrapperState extends State<_BgmGlobalWrapper> with RouteAware {
  @override
  void initState() {
    super.initState();
    BgmManager.instance.setGlobalBGM(widget.listSound);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    BgmManager.instance.clearGlobalBGM();
    super.dispose();
  }

  @override
  void didPushNext() {
    // Ketika page ini di-push oleh page lain, pause global BGM
    BgmManager.instance.pauseForNavigation();
  }

  @override
  void didPopNext() {
    // Ketika kembali ke page ini, resume global BGM
    BgmManager.instance.resumeFromNavigation();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// ─────────────────────────────────────────────────────────────────────────────
///  BGM MANAGER  (stack-aware + ducking + global BGM)
class BgmManager {
  BgmManager._();
  static final BgmManager instance = BgmManager._();

  final _stack = <SoundBackground>[];
  AudioPlayer? _current;
  SoundBackground? _currentSound;

  // Global BGM state
  List<SoundBackground> _globalBGMList = [];
  int _globalCounterSound = 0;
  int _currentTrackIndex = 0;
  bool _isGlobalBGMActive = false;
  AudioPlayer? _globalPlayer;
  SoundBackground? _globalCurrentSound;

  /* cross-fade antar-halaman */
  final _xFade = const Duration(milliseconds: 600);

  /* ducking untuk SFX - IMPROVED */
  int _duckCounter = 0;
  double _baseVolume = 1.0; // Volume dasar BGM
  double _currentVol = 1.0; // Volume aktual saat ini
  double _duckVolume =
      0.1; // Volume saat di-duck (60% - lebih tinggi dari sebelumnya)

  /* navigation state */
  bool _isPausedForNavigation = false;

  /* volume animation state */
  Timer? _volumeAnimationTimer;

  // SharedPreferences keys
  static const String _currentTrackKey = 'bgm_current_track_index';
  static const String _counterSoundKey = 'bgm_counter_sound';

  /* ── GLOBAL BGM API ── */
  Future<void> setGlobalBGM(List<SoundBackground> listSound) async {
    debugPrint('[BGM] 🌍 Setting global BGM with ${listSound.length} tracks');
    _globalBGMList = listSound;

    if (listSound.isNotEmpty) {
      // Load saved state
      await _loadGlobalBGMState();
      _isGlobalBGMActive = true;

      // Start global BGM if no specific BGM is playing
      if (_stack.isEmpty) {
        await _startGlobalBGM();
      }
    }
  }

  void clearGlobalBGM() {
    debugPrint('[BGM] 🌍 Clearing global BGM');
    _isGlobalBGMActive = false;
    _stopGlobalBGM();
    _globalBGMList.clear();
  }

  Future<void> _loadGlobalBGMState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _currentTrackIndex = prefs.getInt(_currentTrackKey) ?? 0;
      _globalCounterSound = prefs.getInt(_counterSoundKey) ?? 0;

      // Ensure indices are valid
      if (_currentTrackIndex >= _globalBGMList.length) {
        _currentTrackIndex = 0;
      }

      debugPrint(
          '[BGM] 🌍 Loaded state - Track: $_currentTrackIndex, Counter: $_globalCounterSound');
    } catch (e) {
      debugPrint('[BGM] 🌍 Error loading global BGM state: $e');
      _currentTrackIndex = 0;
      _globalCounterSound = 0;
    }
  }

  Future<void> _saveGlobalBGMState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_currentTrackKey, _currentTrackIndex);
      await prefs.setInt(_counterSoundKey, _globalCounterSound);
      debugPrint(
          '[BGM] 🌍 Saved state - Track: $_currentTrackIndex, Counter: $_globalCounterSound');
    } catch (e) {
      debugPrint('[BGM] 🌍 Error saving global BGM state: $e');
    }
  }

  Future<void> _startGlobalBGM() async {
    if (!_isGlobalBGMActive || _globalBGMList.isEmpty) {
      debugPrint(
          '[BGM] 🌍 Cannot start global BGM: Active=$_isGlobalBGMActive, List=${_globalBGMList.length}');
      return;
    }

    try {
      debugPrint('[BGM] 🌍 Starting global BGM - Track $_currentTrackIndex');

      if (_currentTrackIndex >= _globalBGMList.length) {
        debugPrint(
            '[BGM] 🌍 ❌ Invalid track index: $_currentTrackIndex (max: ${_globalBGMList.length - 1})');
        _currentTrackIndex = 0;
      }

      final newSound = _globalBGMList[_currentTrackIndex];
      debugPrint('[BGM] 🌍 Loading track: $newSound');
      await _switchToGlobalBgm(newSound);
    } catch (e) {
      debugPrint('[BGM] 🌍 ❌ Error starting global BGM: $e');
      debugPrint('[BGM] 🌍 Stack trace: ${StackTrace.current}');
    }
  }

  Future<void> _stopGlobalBGM() async {
    if (_globalPlayer != null) {
      debugPrint('[BGM] 🌍 Stopping global BGM');
      _volumeAnimationTimer?.cancel();
      await _globalPlayer!.stop();
      await _globalPlayer!.dispose();
      _globalPlayer = null;
      _globalCurrentSound = null;
    }
  }

  Future<void> _switchToGlobalBgm(SoundBackground newBgm) async {
    try {
      debugPrint('[BGM] 🌍 Switching to global BGM: $newBgm');
      await _stopGlobalBGM();

      final newPlayer = AudioPlayer();

      // Set audioCache dengan prefix untuk package assets
      newPlayer.audioCache =
          AudioCache(prefix: 'packages/studyo_music_library/assets/');

      // Try to set audio context untuk BGM - keep audio focus
      try {
        await newPlayer.setAudioContext(
          AudioContext(
            android: AudioContextAndroid(
              isSpeakerphoneOn: false,
              stayAwake: true,
              contentType: AndroidContentType.music,
              usageType: AndroidUsageType.game,
              audioFocus: AndroidAudioFocus.gain,
            ),
          ),
        );
      } catch (e) {
        debugPrint('[BGM] 🌍 Audio context not supported: $e');
      }

      // Hapus ReleaseMode.loop agar tidak loop
      await newPlayer.setReleaseMode(ReleaseMode.stop);

      final absPath = SoundPaths.instance.SoundBackgroundPaths[newBgm];
      if (absPath == null) {
        debugPrint('[BGM] 🌍 ❌ Error: BGM path not found for $newBgm');
        return;
      }
      final relPath = _relative(absPath);
      debugPrint('[BGM] 🌍 Loading BGM from path: $relPath');

      await newPlayer.setSource(AssetSource(relPath));

      // Setup completion listener untuk auto-increment track
      newPlayer.onPlayerComplete.listen((_) {
        debugPrint('[BGM] 🌍 Track completed, moving to next track');
        _incrementCounter();
        _startGlobalBGM();
      });

      // Apply current duck state
      final initialVolume = _duckCounter > 0 ? _duckVolume : _baseVolume;
      await newPlayer.setVolume(initialVolume);
      await newPlayer.resume();

      _globalPlayer = newPlayer;
      _globalCurrentSound = newBgm;
      _currentVol = initialVolume;

      debugPrint('[BGM] 🌍 Global BGM switched to: $newBgm');
    } catch (e) {
      debugPrint('[BGM] 🌍 ❌ Error switching global BGM: $e');
      debugPrint('[BGM] 🌍 Stack trace: ${StackTrace.current}');
    }
  }

  void _incrementCounter() {
    _globalCounterSound++;
    if (_globalBGMList.isNotEmpty) {
      _currentTrackIndex = _globalCounterSound % _globalBGMList.length;
      debugPrint(
          '[BGM] 🌍 Counter incremented: $_globalCounterSound, Track: $_currentTrackIndex');
      _saveGlobalBGMState();
    }
  }

  /* ── PUBLIC API untuk wrapper ── */
  void push(SoundBackground s) {
    debugPrint('[BGM] Push: $s');
    _stack.add(s);

    // Increment counter when entering page with specific BGM
    if (_isGlobalBGMActive) {
      _incrementCounter();
    }

    _queueRefresh();
  }

  void pop(SoundBackground s) {
    debugPrint('[BGM] Pop: $s');
    _stack.remove(s);
    _queueRefresh();
  }

  /* ── NAVIGATION CONTROL ── */
  void pauseForNavigation() {
    debugPrint('[BGM] Pause for navigation');
    _isPausedForNavigation = true;
    _current?.pause();
    _globalPlayer?.pause();
  }

  void resumeFromNavigation() {
    debugPrint('[BGM] Resume from navigation');
    _isPausedForNavigation = false;
    if (_current != null && _currentSound != null) {
      _current!.resume();
    } else if (_globalPlayer != null && _globalCurrentSound != null) {
      _globalPlayer!.resume();
    }
  }

  /* ── IMPROVED DUCK API (untuk SFX) ── */
  void duckStart() {
    _duckCounter++;
    debugPrint('[BGM] 🦆 Duck start (counter: $_duckCounter)');
    debugPrint('[BGM] 🦆 Current volume before duck: $_currentVol');
    debugPrint('[BGM] 🦆 Target duck volume: $_duckVolume');

    if (_duckCounter == 1) {
      // Pertama kali di-duck, turunkan volume tapi pastikan tetap playing
      final activePlayer = _current ?? _globalPlayer;
      if (activePlayer != null) {
        debugPrint('[BGM] 🦆 Player exists, starting duck...');
        _setVolumeSmooth(_duckVolume, fast: true);

        // Pastikan BGM tidak di-pause oleh sistem
        if (!_isPausedForNavigation) {
          activePlayer.resume(); // Force resume jika terpause
          debugPrint('[BGM] 🦆 Force resumed BGM player');
        }
      } else {
        debugPrint('[BGM] 🦆 ❌ No current player to duck!');
      }
    } else {
      debugPrint('[BGM] 🦆 Already ducked, counter: $_duckCounter');
    }
  }

  void duckEnd() {
    if (_duckCounter > 0) {
      _duckCounter--;
      debugPrint('[BGM] 🦆 Duck end (counter: $_duckCounter)');
      debugPrint('[BGM] 🦆 Current volume before restore: $_currentVol');
      debugPrint('[BGM] 🦆 Target restore volume: $_baseVolume');

      if (_duckCounter == 0) {
        final activePlayer = _current ?? _globalPlayer;
        if (activePlayer != null) {
          debugPrint('[BGM] 🦆 Player exists, restoring volume...');

          // Delay sedikit sebelum restore untuk memastikan SFX benar-benar selesai
          Timer(const Duration(milliseconds: 50), () {
            // Kembali ke volume normal
            _setVolumeSmooth(_baseVolume, fast: false);

            // Pastikan BGM masih playing
            if (!_isPausedForNavigation && activePlayer != null) {
              activePlayer.resume();
              debugPrint('[BGM] 🦆 Force resumed BGM after restore');
            }
          });
        } else {
          debugPrint('[BGM] 🦆 ❌ No current player to restore!');
        }
      } else {
        debugPrint('[BGM] 🦆 Still ducked, counter: $_duckCounter');
      }
    } else {
      debugPrint('[BGM] 🦆 ❌ Duck end called but counter is 0!');
    }
  }

  /* ── IMPROVED Volume animation helper ── */
  void _setVolumeSmooth(double targetVol, {bool fast = false}) {
    debugPrint(
        '[BGM] 🔊 Volume smooth: ${_currentVol.toStringAsFixed(2)} → ${targetVol.toStringAsFixed(2)} (fast: $fast)');

    // Cancel existing animation
    _volumeAnimationTimer?.cancel();

    // Get active player (specific BGM takes priority over global)
    final activePlayer = _current ?? _globalPlayer;

    // Kalau belum ada BGM, simpan target saja
    if (activePlayer == null) {
      debugPrint('[BGM] 🔊 ❌ No current player for volume change');
      _currentVol = targetVol;
      _baseVolume = targetVol;
      return;
    }

    // Jika volume sudah sama, skip animation
    if ((_currentVol - targetVol).abs() < 0.01) {
      debugPrint('[BGM] 🔊 ✅ Volume already at target, skipping animation');
      return;
    }

    // Try direct volume set first as fallback mechanism
    try {
      activePlayer.setVolume(targetVol);
      _currentVol = targetVol;
      debugPrint(
          '[BGM] 🔊 ⚡ Direct volume set successful: ${targetVol.toStringAsFixed(2)}');
      _logVol(_currentVol);

      // Still do animation for smooth effect, but we have direct set as backup
    } catch (e) {
      debugPrint('[BGM] 🔊 ❌ Direct volume set failed: $e');
      return; // If direct set fails, don't bother with animation
    }

    // Untuk ducking yang cepat, gunakan less steps
    final steps = fast ? 4 : 8;
    final stepDuration = Duration(milliseconds: fast ? 8 : 12);

    final startVol = _currentVol;
    int currentStep = 0;

    debugPrint(
        '[BGM] 🔊 Starting volume animation: $steps steps, ${stepDuration.inMilliseconds}ms each');

    void animate() {
      final currentActivePlayer = _current ?? _globalPlayer;
      if (currentActivePlayer == null) {
        debugPrint('[BGM] 🔊 ❌ Player disappeared during animation');
        return;
      }

      currentStep++;
      final progress = currentStep / steps;

      if (progress >= 1.0) {
        // Animasi selesai - ensure final volume is set
        _currentVol = targetVol;
        try {
          currentActivePlayer.setVolume(_currentVol);
          debugPrint(
              '[BGM] 🔊 ✅ Animation complete: ${_currentVol.toStringAsFixed(2)}');
          _logVol(_currentVol);
        } catch (e) {
          debugPrint('[BGM] 🔊 ❌ Error setting final volume: $e');
        }
        return;
      }

      // Smooth curve untuk transisi yang lebih natural
      final easedProgress = _easeInOutCubic(progress);
      final newVol = startVol + (targetVol - startVol) * easedProgress;

      try {
        currentActivePlayer.setVolume(newVol);
        _currentVol = newVol;
        debugPrint(
            '[BGM] 🔊 Step $currentStep/$steps: ${_currentVol.toStringAsFixed(2)}');
        _logVol(_currentVol);
      } catch (e) {
        debugPrint('[BGM] 🔊 ❌ Error setting volume step $currentStep: $e');
        // Animation failed, but direct set already worked, so we're good
        return;
      }

      _volumeAnimationTimer = Timer(stepDuration, animate);
    }

    // Only animate if direct set worked
    animate();
  }

  // Easing function untuk transisi volume yang lebih smooth
  double _easeInOutCubic(double t) {
    return t < 0.5 ? 4 * t * t * t : 1 - math.pow(-2 * t + 2, 3) / 2;
  }

  /* ── REFRESH stack (cross-fade) ── */
  bool _refreshQueued = false;
  void _queueRefresh() {
    if (!_refreshQueued) {
      _refreshQueued = true;
      scheduleMicrotask(() {
        _refreshQueued = false;
        _refresh();
      });
    }
  }

  Future<void> _refresh() async {
    try {
      if (_stack.isEmpty) {
        debugPrint('[BGM] Stack empty, checking for global BGM');
        await _stopCurrent();

        // Start global BGM if available and no specific BGM
        if (_isGlobalBGMActive && _globalBGMList.isNotEmpty) {
          await _startGlobalBGM();
        }
        return;
      }

      final top = _stack.last;
      if (top == _currentSound) {
        debugPrint('[BGM] Same BGM already playing: $top');
        return;
      }

      debugPrint('[BGM] Switching to: $top');

      // Stop global BGM when specific BGM starts
      if (_globalPlayer != null) {
        await _stopGlobalBGM();
      }

      await _switchToBgm(top);
    } catch (e) {
      debugPrint('[BGM] Error in refresh: $e');
    }
  }

  Future<void> _stopCurrent() async {
    if (_current != null) {
      _volumeAnimationTimer?.cancel();
      await _current!.stop();
      await _current!.dispose();
      _current = null;
      _currentSound = null;
      _currentVol = _baseVolume;
    }
  }

  Future<void> _switchToBgm(SoundBackground newBgm) async {
    try {
      final newPlayer = AudioPlayer();

      // Set audioCache dengan prefix untuk package assets
      newPlayer.audioCache =
          AudioCache(prefix: 'packages/studyo_music_library/assets/');

      // Try to set audio context untuk BGM - keep audio focus
      try {
        await newPlayer.setAudioContext(
          AudioContext(
            android: AudioContextAndroid(
              isSpeakerphoneOn: false,
              stayAwake: true,
              contentType: AndroidContentType.music,
              usageType: AndroidUsageType.game,
              audioFocus: AndroidAudioFocus.gain, // Keep audio focus untuk BGM
            ),
          ),
        );
      } catch (e) {
        debugPrint('[BGM] Audio context not supported: $e');
        // Continue without audio context if not supported
      }

      await newPlayer.setReleaseMode(ReleaseMode.loop);

      final absPath = SoundPaths.instance.SoundBackgroundPaths[newBgm]!;
      final relPath = _relative(absPath);

      await newPlayer.setSource(AssetSource(relPath));
      await newPlayer.setVolume(0); // Start dengan volume 0
      await newPlayer.resume();

      // Cross-fade dengan timing yang lebih presisi
      final oldPlayer = _current;
      _current = newPlayer;
      _currentSound = newBgm;

      if (oldPlayer != null) {
        // Cross-fade
        await _crossFade(oldPlayer, newPlayer);
      } else {
        // Fade in tanpa cross-fade
        await _fadeIn(newPlayer);
      }
    } catch (e) {
      debugPrint('[BGM] Error switching BGM: $e');
    }
  }

  Future<void> _crossFade(AudioPlayer oldPlayer, AudioPlayer newPlayer) async {
    const steps = 15;
    final stepDuration = Duration(milliseconds: _xFade.inMilliseconds ~/ steps);

    for (int i = 0; i <= steps; i++) {
      final progress = i / steps;
      final oldVol = (1 - progress) * _currentVol;

      // Apply current duck state to new volume
      final targetNewVol = _duckCounter > 0 ? _duckVolume : _baseVolume;
      final newVol = progress * targetNewVol;

      try {
        await oldPlayer.setVolume(oldVol);
        await newPlayer.setVolume(newVol);

        if (i == steps) {
          // Cross-fade selesai
          _currentVol = targetNewVol;
          await oldPlayer.stop();
          await oldPlayer.dispose();
          debugPrint('[BGM] Cross-fade completed');
        } else {
          await Future.delayed(stepDuration);
        }
      } catch (e) {
        debugPrint('[BGM] Error during cross-fade step $i: $e');
        break;
      }
    }
  }

  Future<void> _fadeIn(AudioPlayer player) async {
    const steps = 10;
    const stepDuration = Duration(milliseconds: 30);

    // Apply current duck state
    final targetVol = _duckCounter > 0 ? _duckVolume : _baseVolume;

    for (int i = 0; i <= steps; i++) {
      final progress = i / steps;
      final vol = progress * targetVol;

      try {
        await player.setVolume(vol);
        if (i < steps) {
          await Future.delayed(stepDuration);
        }
      } catch (e) {
        debugPrint('[BGM] Error during fade-in step $i: $e');
        break;
      }
    }

    _currentVol = targetVol;
    debugPrint('[BGM] Fade-in completed');
  }

  /* ── PRELOAD ── */
  Future<void> preloadAll() async {
    try {
      final allPaths =
          SoundPaths.instance.getAllSoundPaths().map(_relative).toList();

      debugPrint('[BGM] Preloading ${allPaths.length} sound files...');
      await FlameAudio.audioCache.loadAll(allPaths);
      debugPrint('[BGM] Preload completed');
    } catch (e) {
      debugPrint('[BGM] Error during preload: $e');
    }
  }

  /// Manual control untuk debugging
  void setBaseVolume(double volume) {
    _baseVolume = volume.clamp(0.0, 1.0);
    if (_duckCounter == 0) {
      _setVolumeSmooth(_baseVolume);
    }
  }

  void pause() {
    _current?.pause();
    _globalPlayer?.pause();
  }

  void resume() {
    if (!_isPausedForNavigation) {
      _current?.resume();
      _globalPlayer?.resume();
    }
  }

  /// Debug method untuk check current state
  void debugState() {
    debugPrint('[BGM] Current state:');
    debugPrint('  - Stack: $_stack');
    debugPrint('  - Current sound: $_currentSound');
    debugPrint('  - Duck counter: $_duckCounter');
    debugPrint('  - Current volume: $_currentVol');
    debugPrint('  - Base volume: $_baseVolume');
    debugPrint('  - Is paused for navigation: $_isPausedForNavigation');
    debugPrint('  - Global BGM active: $_isGlobalBGMActive');
    debugPrint('  - Global BGM list: $_globalBGMList');
    debugPrint('  - Global current sound: $_globalCurrentSound');
    debugPrint('  - Global counter: $_globalCounterSound');
    debugPrint('  - Current track index: $_currentTrackIndex');
  }

  /// Force BGM to resume if it gets paused unexpectedly
  void forceResume() {
    if (!_isPausedForNavigation) {
      if (_current != null) {
        debugPrint('[BGM] Force resume specific BGM');
        _current!.resume();
      } else if (_globalPlayer != null) {
        debugPrint('[BGM] Force resume global BGM');
        _globalPlayer!.resume();
      }
    }
  }

  /// Get current player state for debugging
  Future<void> checkPlayerState() async {
    final activePlayer = _current ?? _globalPlayer;
    if (activePlayer != null) {
      try {
        final state = activePlayer.state;
        final position = await activePlayer.getCurrentPosition();
        final duration = await activePlayer.getDuration();
        debugPrint('[BGM] 🎮 Player state: $state');
        debugPrint(
            '[BGM] 🎮 Position: ${position?.inMilliseconds}ms / ${duration?.inMilliseconds}ms');
        debugPrint('[BGM] 🎮 Current volume in manager: $_currentVol');
        debugPrint('[BGM] 🎮 Base volume: $_baseVolume');
        debugPrint('[BGM] 🎮 Duck counter: $_duckCounter');
        debugPrint('[BGM] 🎮 Is global: ${_current == null ? 'YES' : 'NO'}');
      } catch (e) {
        debugPrint('[BGM] 🎮 ❌ Error checking player state: $e');
      }
    } else {
      debugPrint('[BGM] 🎮 ❌ No current player');
    }
  }

  /// Test volume setting directly
  Future<void> testVolume(double vol) async {
    final activePlayer = _current ?? _globalPlayer;
    if (activePlayer != null) {
      try {
        debugPrint('[BGM] 🧪 Testing direct volume set: $vol');
        await activePlayer.setVolume(vol);
        _currentVol = vol;
        debugPrint('[BGM] 🧪 ✅ Direct volume set successful');
      } catch (e) {
        debugPrint('[BGM] 🧪 ❌ Direct volume set failed: $e');
      }
    } else {
      debugPrint('[BGM] 🧪 ❌ No player to test volume');
    }
  }

  /// Manual duck test
  void testDuck() {
    debugPrint('[BGM] 🧪 Manual duck test');
    duckStart();
    Timer(const Duration(seconds: 2), () {
      debugPrint('[BGM] 🧪 Manual duck restore');
      duckEnd();
    });
  }

  /// Manual control untuk global BGM track
  Future<void> nextGlobalTrack() async {
    if (_globalBGMList.isNotEmpty && _isGlobalBGMActive) {
      _currentTrackIndex = (_currentTrackIndex + 1) % _globalBGMList.length;
      await _saveGlobalBGMState();

      // If currently playing global BGM, switch to new track
      if (_stack.isEmpty && _globalPlayer != null) {
        await _startGlobalBGM();
      }
      debugPrint('[BGM] 🌍 Manually switched to track: $_currentTrackIndex');
    }
  }

  Future<void> previousGlobalTrack() async {
    if (_globalBGMList.isNotEmpty && _isGlobalBGMActive) {
      _currentTrackIndex = (_currentTrackIndex - 1 + _globalBGMList.length) %
          _globalBGMList.length;
      await _saveGlobalBGMState();

      // If currently playing global BGM, switch to new track
      if (_stack.isEmpty && _globalPlayer != null) {
        await _startGlobalBGM();
      }
      debugPrint('[BGM] 🌍 Manually switched to track: $_currentTrackIndex');
    }
  }

  /// Get current global track info
  Map<String, dynamic> getGlobalTrackInfo() {
    return {
      'isActive': _isGlobalBGMActive,
      'currentTrackIndex': _currentTrackIndex,
      'totalTracks': _globalBGMList.length,
      'currentSound': _currentTrackIndex < _globalBGMList.length
          ? _globalBGMList[_currentTrackIndex]
          : null,
      'counterSound': _globalCounterSound,
      'isPlaying': _globalPlayer != null && _stack.isEmpty,
    };
  }
}

/// ─────────────────────────────────────────────────────────────────────────────
///  SOUND CONTROLLER
class SoundController {
  static final SoundController instance = SoundController._();
  SoundController._();

  /// Play any sound with specified type and volume
  ///
  /// Example usage:
  /// ```dart
  /// // Play whoosh sound
  /// await SoundController.instance.playSound(
  ///   WhooshSound.longwhoosh,
  ///   SoundType.whoosh,
  ///   volume: 1.0
  /// );
  ///
  /// // Play BGM
  /// await SoundController.instance.playSound(
  ///   SoundBackground.yourBGM,
  ///   SoundType.background,
  ///   volume: 1.0
  /// );
  /// ```
  Future<void> playSound(
    dynamic sound,
    SoundType type, {
    double volume = 1.0,
  }) async {
    String path;
    switch (type) {
      case SoundType.background:
        path =
            SoundPaths.instance.SoundBackgroundPaths[sound as SoundBackground]!;
        break;
      case SoundType.balance:
        path = SoundPaths.instance.balanceSoundPaths[sound as SoundBalance]!;
        break;
      case SoundType.bubble:
        path = SoundPaths.instance.bubbleSoundPaths[sound as SoundBubble]!;
        break;
      case SoundType.cheering:
        path = SoundPaths.instance.cheeringSoundPaths[sound as SoundCheering]!;
        break;
      case SoundType.click:
        path = SoundPaths.instance.clickSoundPaths[sound as SoundClick]!;
        break;
      case SoundType.clip:
        path = SoundPaths.instance.clipSoundPaths[sound as SoundClip]!;
        break;
      case SoundType.coins:
        path = SoundPaths.instance.coinsSoundPaths[sound as SoundCoins]!;
        break;
      case SoundType.deny:
        path = SoundPaths.instance.denySoundPaths[sound as SoundDeny]!;
        break;
      case SoundType.fail:
        path = SoundPaths.instance.failSoundPaths[sound as SoundFail]!;
        break;
      case SoundType.levelup:
        path = SoundPaths.instance.levelupSoundPaths[sound as SoundLevelup]!;
        break;
      case SoundType.login:
        path = SoundPaths.instance.loginSoundPaths[sound as SoundLogin]!;
        break;
      case SoundType.messages:
        path = SoundPaths.instance.messagesSoundPaths[sound as SoundMessages]!;
        break;
      case SoundType.petsCleaning:
        path = SoundPaths
            .instance.pets_cleaningSoundPaths[sound as SoundPetsCleaning]!;
        break;
      case SoundType.petsEat:
        path = SoundPaths.instance.pets_eatSoundPaths[sound as SoundPetsEat]!;
        break;
      case SoundType.petsPlay:
        path = SoundPaths.instance.pets_playSoundPaths[sound as SoundPetsPlay]!;
        break;
      case SoundType.petsShortReactions:
        path = SoundPaths.instance
            .pets_short_reactionsSoundPaths[sound as SoundPetsShortReactions]!;
        break;
      case SoundType.pickup:
        path = SoundPaths.instance.pickupSoundPaths[sound as SoundPickup]!;
        break;
      case SoundType.reminders:
        path =
            SoundPaths.instance.remindersSoundPaths[sound as SoundReminders]!;
        break;
      case SoundType.resources:
        path =
            SoundPaths.instance.resourcesSoundPaths[sound as SoundResources]!;
        break;
      case SoundType.review:
        path = SoundPaths.instance.reviewSoundPaths[sound as SoundReview]!;
        break;
      case SoundType.send:
        path = SoundPaths.instance.sendSoundPaths[sound as SoundSend]!;
        break;
      case SoundType.success:
        path = SoundPaths.instance.successSoundPaths[sound as SoundSuccess]!;
        break;
      case SoundType.tap:
        path = SoundPaths.instance.tapSoundPaths[sound as SoundTAP]!;
        break;
      case SoundType.tetris:
        path = SoundPaths.instance.tetrisSoundPaths[sound as SoundTetris]!;
        break;
      case SoundType.transitions:
        path = SoundPaths
            .instance.transitionsSoundPaths[sound as SoundTransitions]!;
        break;
      case SoundType.whoosh:
        path = SoundPaths.instance.whooshSoundPaths[sound as SoundWhoosh]!;
        break;
    }

    await playOneShot(path, volume: volume);
  }

  /// Set global BGM list
  Future<void> setGlobalBGM(List<SoundBackground> listSound) async {
    BgmManager.instance.setGlobalBGM(listSound);
  }

  /// Stop all BGM
  Future<void> stopBGM() async {
    BgmManager.instance.clearGlobalBGM();
  }
}
