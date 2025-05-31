import 'dart:async';
import 'dart:math' as math;

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
  clip,
  coins,
  deny,
  messages,
  petsCleaning,
  petsEat,
  petsPlay,
  pickup,
  resources,
  review,
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
class SoundQueue {
  static final SoundQueue instance = SoundQueue._();
  SoundQueue._();

  final _queue = <_QueuedSound>[];
  bool _isPlaying = false;
  static const _maxConcurrent = 4;
  int _currentPlaying = 0;
  Timer? _processTimer;
  final Map<String, DateTime> _lastPlayTimes = {};

  // Prioritas suara (semakin tinggi semakin prioritas)
  static const _priorityClick = 1;
  static const _priorityDrag = 2;
  static const _priorityNotification = 3;

  // Minimum interval antara suara yang sama (dalam milliseconds)
  static const _minIntervalSameSound = 100;
  static const _minIntervalDifferentSound = 50;

  Future<void> play(String path,
      {double volume = 1.0, SoundType type = SoundType.review}) async {
    final now = DateTime.now();
    final lastPlayTime = _lastPlayTimes[path];

    // Cek interval minimum berdasarkan tipe suara
    if (lastPlayTime != null) {
      final interval = type == SoundType.messages
          ? _minIntervalSameSound
          : _minIntervalDifferentSound;
      if (now.difference(lastPlayTime).inMilliseconds < interval) {
        return; // Skip tanpa log untuk mengurangi overhead
      }
    }

    // Update last play time
    _lastPlayTimes[path] = now;

    // Tentukan prioritas berdasarkan tipe suara
    int priority;
    switch (type) {
      case SoundType.success:
        priority = _priorityNotification;
        break;
      case SoundType.tap:
        priority = _priorityClick;
        break;
      case SoundType.whoosh:
        priority = _priorityDrag;
        break;
      default:
        priority = _priorityNotification;
    }

    // Tambahkan ke antrian
    _queue.add(_QueuedSound(path: path, volume: volume, priority: priority));

    // Sort antrian berdasarkan prioritas
    _queue.sort((a, b) => b.priority.compareTo(a.priority));

    // Mulai proses antrian jika belum berjalan
    if (!_isPlaying) {
      _isPlaying = true;
      _processQueue();
    }
  }

  void _processQueue() {
    if (_queue.isEmpty) {
      _isPlaying = false;
      return;
    }

    if (_currentPlaying >= _maxConcurrent) {
      // Jika masih penuh, coba lagi setelah 50ms
      _processTimer?.cancel();
      _processTimer = Timer(const Duration(milliseconds: 50), _processQueue);
      return;
    }

    final sound = _queue.removeAt(0);
    _currentPlaying++;

    // Play sound tanpa menunggu selesai
    playOneShot(sound.path, volume: sound.volume).then((_) {
      _currentPlaying--;
      // Proses suara berikutnya
      _processQueue();
    }).catchError((_) {
      _currentPlaying--;
      _processQueue();
    });
  }

  void dispose() {
    _processTimer?.cancel();
    _queue.clear();
    _currentPlaying = 0;
    _isPlaying = false;
    _lastPlayTimes.clear();
  }
}

class _QueuedSound {
  final String path;
  final double volume;
  final int priority;

  _QueuedSound({
    required this.path,
    required this.volume,
    required this.priority,
  });
}

Future<void> playOneShot(String absPath, {double volume = 1}) async {
  try {
    BgmManager.instance.duckStart();
    final rel = _relative(absPath);

    try {
      // Set empty prefix to handle package paths correctly
      FlameAudio.audioCache.prefix = '';

      final player = await FlameAudio.play(rel, volume: volume);

      // Setup auto-cleanup
      player.onPlayerComplete.listen((_) {
        BgmManager.instance.duckEnd();
      });

      // Fallback cleanup
      Timer(const Duration(seconds: 3), () {
        BgmManager.instance.duckEnd();
      });
    } catch (e) {
      debugPrint('[SFX] Error playing sound: $e');
      BgmManager.instance.duckEnd();
    }
  } catch (e) {
    debugPrint('[SFX] Unexpected error: $e');
    BgmManager.instance.duckEnd();
  }
}

/// ─────────────────────────────────────────────────────────────────────────────
///  EXTENSIONS
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
    // Ambil path sesuai tipe
    String path;
    switch (type) {
      case SoundType.background:
        path =
            SoundPaths.instance.backgroundSoundPaths[sound as BackgroundSound]!;
        break;
      case SoundType.balance:
        path = SoundPaths.instance.balanceSoundPaths[sound as BalanceSound]!;
        break;
      case SoundType.bubble:
        path = SoundPaths.instance.bubbleSoundPaths[sound as BubbleSound]!;
        break;
      case SoundType.clip:
        path = SoundPaths.instance.clipSoundPaths[sound as ClipSound]!;
        break;
      case SoundType.coins:
        path = SoundPaths.instance.coinsSoundPaths[sound as CoinsSound]!;
        break;
      case SoundType.deny:
        path = SoundPaths.instance.denySoundPaths[sound as DenySound]!;
        break;
      case SoundType.messages:
        path = SoundPaths.instance.messagesSoundPaths[sound as MessagesSound]!;
        break;
      case SoundType.petsCleaning:
        path = SoundPaths
            .instance.pets_cleaningSoundPaths[sound as PetsCleaningSound]!;
        break;
      case SoundType.petsEat:
        path = SoundPaths.instance.pets_eatSoundPaths[sound as PetsEatSound]!;
        break;
      case SoundType.petsPlay:
        path = SoundPaths.instance.pets_playSoundPaths[sound as PetsPlaySound]!;
        break;
      case SoundType.pickup:
        path = SoundPaths.instance.pickupSoundPaths[sound as PickupSound]!;
        break;
      case SoundType.resources:
        path =
            SoundPaths.instance.resourcesSoundPaths[sound as ResourcesSound]!;
        break;
      case SoundType.review:
        path = SoundPaths.instance.reviewSoundPaths[sound as ReviewSound]!;
        break;
      case SoundType.success:
        path = SoundPaths.instance.successSoundPaths[sound as SuccessSound]!;
        break;
      case SoundType.tap:
        path = SoundPaths.instance.tapSoundPaths[sound as TAPSound]!;
        break;
      case SoundType.tetris:
        path = SoundPaths.instance.tetrisSoundPaths[sound as TetrisSound]!;
        break;
      case SoundType.transitions:
        path = SoundPaths
            .instance.transitionsSoundPaths[sound as TransitionsSound]!;
        break;
      case SoundType.whoosh:
        path = SoundPaths.instance.whooshSoundPaths[sound as WhooshSound]!;
        break;
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
      onTapDown: (_) =>
          SoundQueue.instance.play(path, volume: volume, type: type),
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
  static const _whooshCooldown =
      Duration(milliseconds: 150); // Cooldown antara whoosh sounds
  DateTime? _lastWhooshTime;

  void _onPointerDown(PointerDownEvent event) {
    final now = DateTime.now();
    if (_lastPlayTime == null ||
        now.difference(_lastPlayTime!) > _minInterval) {
      _lastPlayTime = now;
      _lastPosition = event.position;
      SoundQueue.instance
          .play(widget.path, volume: widget.volume, type: widget.type);
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

        // Cek apakah sudah waktunya memainkan whoosh sound
        if (_lastWhooshTime == null ||
            now.difference(_lastWhooshTime!) > _whooshCooldown) {
          // Hanya mainkan whoosh jika kecepatan cukup tinggi
          if (velocity > _minVelocityThreshold) {
            // Scale volume berdasarkan kecepatan
            final volumeScale = math.min(
                (velocity - _minVelocityThreshold) /
                    (_maxVelocityThreshold - _minVelocityThreshold),
                1.0);

            // Volume minimum 0.3, maximum 0.7
            final whooshVolume = 0.3 + (volumeScale * 0.4);

            SoundQueue.instance.play(
              SoundPaths.instance.whooshSoundPaths[WhooshSound.longwhoosh]!,
              volume: widget.volume * whooshVolume,
              type: SoundType.whoosh,
            );

            _lastWhooshTime = now;
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

      SoundQueue.instance.play(
        SoundPaths.instance.clipSoundPaths[ClipSound.containerdrop]!,
        volume: widget.volume * clickVolume,
        type: SoundType.clip,
      );
    }

    _isDragging = false;
    _lastPosition = null;
    _lastVelocity = 0;
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
  Widget addBGM(BackgroundSound bgm) => _BgmWrapper(child: this, bgm: bgm);
}

/// ─────────────────────────────────────────────────────────────────────────────
///  BGM GLOBAL EXTENSION
extension BgmGlobalExtension on Widget {
  Widget addBGMGlobal(List<BackgroundSound> listSound) => _BgmGlobalWrapper(
        child: this,
        listSound: listSound,
      );
}

class _BgmWrapper extends StatefulWidget {
  const _BgmWrapper({required this.child, required this.bgm});
  final Widget child;
  final BackgroundSound bgm;
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
  final List<BackgroundSound> listSound;
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
  BgmManager._() {
    // Set empty prefix for flame_audio to handle package paths correctly
    FlameAudio.audioCache.prefix = '';
  }
  static final BgmManager instance = BgmManager._();

  final _stack = <BackgroundSound>[];
  BackgroundSound? _currentSound;

  // Global BGM state
  List<BackgroundSound> _globalBGMList = [];
  int _globalCounterSound = 0;
  int _currentTrackIndex = 0;
  bool _isGlobalBGMActive = false;
  BackgroundSound? _globalCurrentSound;

  /* cross-fade antar-halaman */
  final _xFade = const Duration(milliseconds: 600);

  /* ducking untuk SFX - IMPROVED */
  int _duckCounter = 0;
  double _baseVolume = 1.0; // Volume dasar BGM
  double _currentVol = 1.0; // Volume aktual saat ini
  double _duckVolume =
      0.6; // Volume saat di-duck (60% - lebih tinggi dari sebelumnya)

  /* navigation state */
  bool _isPausedForNavigation = false;

  /* volume animation state */
  Timer? _volumeAnimationTimer;

  // SharedPreferences keys
  static const String _currentTrackKey = 'bgm_current_track_index';
  static const String _counterSoundKey = 'bgm_counter_sound';

  /* ── GLOBAL BGM API ── */
  Future<void> setGlobalBGM(List<BackgroundSound> listSound) async {
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
    if (_globalCurrentSound != null) {
      debugPrint('[BGM] 🌍 Stopping global BGM');
      _volumeAnimationTimer?.cancel();
      await FlameAudio.bgm.stop();
      _globalCurrentSound = null;
    }
  }

  Future<void> _switchToGlobalBgm(BackgroundSound newBgm) async {
    try {
      debugPrint('[BGM] 🌍 Switching to global BGM: $newBgm');
      await _stopGlobalBGM();

      // Get the path for the new BGM
      final path = SoundPaths.instance.backgroundSoundPaths[newBgm];
      if (path == null) {
        debugPrint('[BGM] 🌍 ❌ Path not found for BGM: $newBgm');
        return;
      }

      final rel = _relative(path);

      try {
        // Set empty prefix and play BGM with looping
        FlameAudio.audioCache.prefix = '';
        await FlameAudio.bgm.play(rel, volume: _currentVol);

        _globalCurrentSound = newBgm;
        debugPrint('[BGM] 🌍 ✅ Global BGM started: $newBgm');

        // Setup completion listener for track progression
        FlameAudio.bgm.audioPlayer.onPlayerComplete.listen((_) {
          _onGlobalTrackComplete();
        });
      } catch (e) {
        debugPrint('[BGM] 🌍 ❌ Error playing global BGM: $e');
      }
    } catch (e) {
      debugPrint('[BGM] 🌍 ❌ Error in _switchToGlobalBgm: $e');
    }
  }

  void _onGlobalTrackComplete() {
    debugPrint('[BGM] 🌍 Track completed, moving to next track');
    _incrementCounter();
    _startGlobalBGM();
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
  void push(BackgroundSound s) {
    debugPrint('[BGM] Push: $s');
    _stack.add(s);

    // Increment counter when entering page with specific BGM
    if (_isGlobalBGMActive) {
      _incrementCounter();
    }

    _queueRefresh();
  }

  void pop(BackgroundSound s) {
    debugPrint('[BGM] Pop: $s');
    _stack.remove(s);
    _queueRefresh();
  }

  /* ── NAVIGATION CONTROL ── */
  void pauseForNavigation() {
    if (!_isPausedForNavigation) {
      _isPausedForNavigation = true;
      debugPrint('[BGM] ⏸️ Pausing for navigation');

      FlameAudio.bgm.pause();
    }
  }

  void resumeFromNavigation() {
    if (_isPausedForNavigation) {
      _isPausedForNavigation = false;
      debugPrint('[BGM] ▶️ Resuming from navigation');

      FlameAudio.bgm.resume();
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
      debugPrint('[BGM] 🦆 Starting duck...');
      _setVolumeSmooth(_duckVolume, fast: true);

      // Pastikan BGM tidak di-pause oleh sistem
      if (!_isPausedForNavigation) {
        FlameAudio.bgm.resume(); // Force resume jika terpause
        debugPrint('[BGM] 🦆 Force resumed BGM player');
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
        debugPrint('[BGM] 🦆 Restoring volume...');

        // Delay sedikit sebelum restore untuk memastikan SFX benar-benar selesai
        Timer(const Duration(milliseconds: 50), () {
          // Kembali ke volume normal
          _setVolumeSmooth(_baseVolume, fast: false);

          // Pastikan BGM masih playing
          if (!_isPausedForNavigation) {
            FlameAudio.bgm.resume();
            debugPrint('[BGM] 🦆 Force resumed BGM after restore');
          }
        });
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

    // Jika volume sudah sama, skip animation
    if ((_currentVol - targetVol).abs() < 0.01) {
      debugPrint('[BGM] 🔊 ✅ Volume already at target, skipping animation');
      return;
    }

    // Try direct volume set first as fallback mechanism
    try {
      FlameAudio.bgm.audioPlayer.setVolume(targetVol);
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
      currentStep++;
      final progress = currentStep / steps;

      if (progress >= 1.0) {
        // Animasi selesai - ensure final volume is set
        _currentVol = targetVol;
        try {
          FlameAudio.bgm.audioPlayer.setVolume(_currentVol);
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
        FlameAudio.bgm.audioPlayer.setVolume(newVol);
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
      if (_globalCurrentSound != null) {
        await _stopGlobalBGM();
      }

      await _switchToBgm(top);
    } catch (e) {
      debugPrint('[BGM] Error in refresh: $e');
    }
  }

  Future<void> _stopCurrent() async {
    if (_currentSound != null) {
      _volumeAnimationTimer?.cancel();
      await FlameAudio.bgm.stop();
      _currentSound = null;
      _currentVol = _baseVolume;
    }
  }

  Future<void> _switchToBgm(BackgroundSound newBgm) async {
    try {
      debugPrint('[BGM] 🎵 Switching to: $newBgm');

      // Stop current BGM
      await FlameAudio.bgm.stop();
      _currentSound = null;

      // Stop global BGM if it's playing
      if (_isGlobalBGMActive && _globalCurrentSound != null) {
        await _stopGlobalBGM();
      }

      // Get the path for the new BGM
      final path = SoundPaths.instance.backgroundSoundPaths[newBgm];
      if (path == null) {
        debugPrint('[BGM] ❌ Path not found for BGM: $newBgm');
        return;
      }

      final rel = _relative(path);

      try {
        // Set empty prefix and play BGM with looping
        FlameAudio.audioCache.prefix = '';

        // Start with fade in effect
        await FlameAudio.bgm.play(rel, volume: 0.0);
        _currentSound = newBgm;

        // Fade in to current volume
        await _fadeIn();

        debugPrint('[BGM] ✅ BGM started: $newBgm');
      } catch (e) {
        debugPrint('[BGM] ❌ Error playing BGM: $e');
      }
    } catch (e) {
      debugPrint('[BGM] ❌ Error in _switchToBgm: $e');
    }
  }

  Future<void> _fadeIn() async {
    const steps = 10;
    const stepDuration = Duration(milliseconds: 30);

    // Apply current duck state
    final targetVol = _duckCounter > 0 ? _duckVolume : _baseVolume;

    for (int i = 0; i <= steps; i++) {
      final progress = i / steps;
      final vol = progress * targetVol;

      try {
        FlameAudio.bgm.audioPlayer.setVolume(vol);
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
      // Set empty prefix first
      FlameAudio.audioCache.prefix = '';

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
    FlameAudio.bgm.pause();
  }

  void resume() {
    if (!_isPausedForNavigation) {
      FlameAudio.bgm.resume();
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
      debugPrint('[BGM] Force resume BGM');
      FlameAudio.bgm.resume();
    }
  }

  /// Get current player state for debugging
  Future<void> checkPlayerState() async {
    try {
      final state = FlameAudio.bgm.audioPlayer.state;
      final position = await FlameAudio.bgm.audioPlayer.getCurrentPosition();
      final duration = await FlameAudio.bgm.audioPlayer.getDuration();
      debugPrint('[BGM] 🎮 Player state: $state');
      debugPrint(
          '[BGM] 🎮 Position: ${position?.inMilliseconds}ms / ${duration?.inMilliseconds}ms');
      debugPrint('[BGM] 🎮 Current volume in manager: $_currentVol');
      debugPrint('[BGM] 🎮 Base volume: $_baseVolume');
      debugPrint('[BGM] 🎮 Duck counter: $_duckCounter');
      debugPrint('[BGM] 🎮 Is global: ${_currentSound == null ? 'YES' : 'NO'}');
    } catch (e) {
      debugPrint('[BGM] 🎮 ❌ Error checking player state: $e');
    }
  }

  /// Test volume setting directly
  Future<void> testVolume(double vol) async {
    try {
      debugPrint('[BGM] 🧪 Testing direct volume set: $vol');
      await FlameAudio.bgm.audioPlayer.setVolume(vol);
      _currentVol = vol;
      debugPrint('[BGM] 🧪 ✅ Direct volume set successful');
    } catch (e) {
      debugPrint('[BGM] 🧪 ❌ Direct volume set failed: $e');
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
      if (_stack.isEmpty && _globalCurrentSound != null) {
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
      if (_stack.isEmpty && _globalCurrentSound != null) {
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
      'isPlaying': _globalCurrentSound != null && _stack.isEmpty,
    };
  }

  void dispose() {
    debugPrint('[BGM] 🗑️ Disposing BGM Manager');
    _volumeAnimationTimer?.cancel();
    _stopCurrent();
    _stopGlobalBGM();
    _stack.clear();
    _globalBGMList.clear();
    _isGlobalBGMActive = false;
    _isPausedForNavigation = false;

    // Clear flame audio cache
    FlameAudio.audioCache.clearAll();
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
  ///   BackgroundSound.yourBGM,
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
            SoundPaths.instance.backgroundSoundPaths[sound as BackgroundSound]!;
        break;
      case SoundType.balance:
        path = SoundPaths.instance.balanceSoundPaths[sound as BalanceSound]!;
        break;
      case SoundType.bubble:
        path = SoundPaths.instance.bubbleSoundPaths[sound as BubbleSound]!;
        break;
      case SoundType.clip:
        path = SoundPaths.instance.clipSoundPaths[sound as ClipSound]!;
        break;
      case SoundType.coins:
        path = SoundPaths.instance.coinsSoundPaths[sound as CoinsSound]!;
        break;
      case SoundType.deny:
        path = SoundPaths.instance.denySoundPaths[sound as DenySound]!;
        break;
      case SoundType.messages:
        path = SoundPaths.instance.messagesSoundPaths[sound as MessagesSound]!;
        break;
      case SoundType.petsCleaning:
        path = SoundPaths
            .instance.pets_cleaningSoundPaths[sound as PetsCleaningSound]!;
        break;
      case SoundType.petsEat:
        path = SoundPaths.instance.pets_eatSoundPaths[sound as PetsEatSound]!;
        break;
      case SoundType.petsPlay:
        path = SoundPaths.instance.pets_playSoundPaths[sound as PetsPlaySound]!;
        break;
      case SoundType.pickup:
        path = SoundPaths.instance.pickupSoundPaths[sound as PickupSound]!;
        break;
      case SoundType.resources:
        path =
            SoundPaths.instance.resourcesSoundPaths[sound as ResourcesSound]!;
        break;
      case SoundType.review:
        path = SoundPaths.instance.reviewSoundPaths[sound as ReviewSound]!;
        break;
      case SoundType.success:
        path = SoundPaths.instance.successSoundPaths[sound as SuccessSound]!;
        break;
      case SoundType.tap:
        path = SoundPaths.instance.tapSoundPaths[sound as TAPSound]!;
        break;
      case SoundType.tetris:
        path = SoundPaths.instance.tetrisSoundPaths[sound as TetrisSound]!;
        break;
      case SoundType.transitions:
        path = SoundPaths
            .instance.transitionsSoundPaths[sound as TransitionsSound]!;
        break;
      case SoundType.whoosh:
        path = SoundPaths.instance.whooshSoundPaths[sound as WhooshSound]!;
        break;
    }

    await SoundQueue.instance.play(path, volume: volume, type: type);
  }

  /// Set global BGM list
  Future<void> setGlobalBGM(List<BackgroundSound> listSound) async {
    BgmManager.instance.setGlobalBGM(listSound);
  }

  /// Stop all BGM
  Future<void> stopBGM() async {
    BgmManager.instance.clearGlobalBGM();
  }
}
