import 'dart:async';
import 'package:flame_audio/flame_audio.dart';
import '../manager/bgm_manager.dart';

/// Auto-initialization class for Studyo Music Library
/// This class handles automatic setup when the library is imported
class StudyoMusicLibraryAutoInit {
  static bool _isInitialized = false;
  static Completer<void>? _initCompleter;

  /// Initialize the sound system automatically
  /// This method is called automatically when the library is imported
  static Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    // Prevent multiple simultaneous initializations
    if (_initCompleter != null) {
      return _initCompleter!.future;
    }

    _initCompleter = Completer<void>();

    try {
      // Set the audio cache prefix for package assets
      FlameAudio.audioCache.prefix = 'packages/studyo_music_library/assets/';

      // Preload all sounds in background
      // Using unawaited to not block the main thread
      unawaited(_preloadSoundsInBackground());

      _isInitialized = true;
      _initCompleter!.complete();
    } catch (e) {
      _initCompleter!.completeError(e);
      rethrow;
    } finally {
      _initCompleter = null;
    }
  }

  /// Preload sounds in background without blocking
  static Future<void> _preloadSoundsInBackground() async {
    try {
      await BgmManager.instance.preloadAll();
    } catch (e) {
      // Silent fail for preloading - don't block the app
      // The sounds will be loaded on-demand if preloading fails
    }
  }

  /// Check if the library is initialized
  static bool get isInitialized => _isInitialized;

  /// Force re-initialization (for testing purposes)
  static void reset() {
    _isInitialized = false;
    _initCompleter = null;
  }
}

/// Global initialization - this runs when the library is imported
final _autoInit = StudyoMusicLibraryAutoInit.initialize();
