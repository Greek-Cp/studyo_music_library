import 'package:studyo_music_library/core/sound_manager/manager/bgm_manager.dart';
import 'package:studyo_music_library/core/sound_manager/core/sound_enums.dart';
import 'package:studyo_music_library/core/sound_manager/core/sound_paths.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ─────────────────────────────────────────────────────────────────────────────
///  DRAG SOUND TRACK CONTROLLER
class DragSoundTrackController {
  static final DragSoundTrackController instance = DragSoundTrackController._();
  DragSoundTrackController._();

  final Map<String, int> _trackIndexes = {};
  final Map<String, List<dynamic>> _tapSounds = {};
  final Map<String, List<dynamic>> _whooshSounds = {};
  final Map<String, List<dynamic>> _dropSounds = {};
  final Map<String, SoundType> _tapTypes = {};
  final Map<String, SoundType> _whooshTypes = {};
  final Map<String, SoundType> _dropTypes = {};

  /// Set drag sound track for a specific widget/page
  void setDragSoundTrack(
    String trackId,
    List<dynamic> tapSounds,
    List<dynamic> whooshSounds,
    List<dynamic> dropSounds,
    SoundType tapType,
    SoundType whooshType,
    SoundType dropType,
  ) {
    _tapSounds[trackId] = tapSounds;
    _whooshSounds[trackId] = whooshSounds;
    _dropSounds[trackId] = dropSounds;
    _tapTypes[trackId] = tapType;
    _whooshTypes[trackId] = whooshType;
    _dropTypes[trackId] = dropType;
    _loadTrackIndex(trackId);
  }

  /// Get current tap sound for a track
  dynamic getCurrentTapSound(String trackId) {
    if (!_tapSounds.containsKey(trackId) || _tapSounds[trackId]!.isEmpty) {
      return null;
    }
    final index = _trackIndexes[trackId] ?? 0;
    final adjustedIndex = index % _tapSounds[trackId]!.length;
    return _tapSounds[trackId]![adjustedIndex];
  }

  /// Get current whoosh sound for a track
  dynamic getCurrentWhooshSound(String trackId) {
    if (!_whooshSounds.containsKey(trackId) ||
        _whooshSounds[trackId]!.isEmpty) {
      return null;
    }
    final index = _trackIndexes[trackId] ?? 0;
    final adjustedIndex = index % _whooshSounds[trackId]!.length;
    return _whooshSounds[trackId]![adjustedIndex];
  }

  /// Get current drop sound for a track
  dynamic getCurrentDropSound(String trackId) {
    if (!_dropSounds.containsKey(trackId) || _dropSounds[trackId]!.isEmpty) {
      return null;
    }
    final index = _trackIndexes[trackId] ?? 0;
    final adjustedIndex = index % _dropSounds[trackId]!.length;
    return _dropSounds[trackId]![adjustedIndex];
  }

  /// Move to next sound in track (called when leaving page)
  Future<void> nextTrack(String trackId) async {
    if (!_tapSounds.containsKey(trackId)) {
      return;
    }
    final currentIndex = _trackIndexes[trackId] ?? 0;
    // Use the largest list length to determine max index
    final maxLength = [
      _tapSounds[trackId]?.length ?? 0,
      _whooshSounds[trackId]?.length ?? 0,
      _dropSounds[trackId]?.length ?? 0,
    ].reduce((a, b) => a > b ? a : b);

    if (maxLength > 0) {
      final nextIndex = (currentIndex + 1) % maxLength;
      _trackIndexes[trackId] = nextIndex;
      await _saveTrackIndex(trackId, nextIndex);
    }
  }

  /// Move to previous sound in track
  Future<void> previousTrack(String trackId) async {
    if (!_tapSounds.containsKey(trackId)) {
      return;
    }
    final currentIndex = _trackIndexes[trackId] ?? 0;
    // Use the largest list length to determine max index
    final maxLength = [
      _tapSounds[trackId]?.length ?? 0,
      _whooshSounds[trackId]?.length ?? 0,
      _dropSounds[trackId]?.length ?? 0,
    ].reduce((a, b) => a > b ? a : b);

    if (maxLength > 0) {
      final previousIndex =
          currentIndex == 0 ? maxLength - 1 : currentIndex - 1;
      _trackIndexes[trackId] = previousIndex;
      await _saveTrackIndex(trackId, previousIndex);
    }
  }

  /// Get current track index
  int getCurrentTrackIndex(String trackId) {
    return _trackIndexes[trackId] ?? 0;
  }

  /// Get info about track lengths
  Map<String, int> getTrackLengths(String trackId) {
    return {
      'tap': _tapSounds[trackId]?.length ?? 0,
      'whoosh': _whooshSounds[trackId]?.length ?? 0,
      'drop': _dropSounds[trackId]?.length ?? 0,
    };
  }

  /// Load track index from storage
  Future<void> _loadTrackIndex(String trackId) async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt('drag_sound_track_$trackId') ?? 0;
    _trackIndexes[trackId] = index;
  }

  /// Save track index to storage
  Future<void> _saveTrackIndex(String trackId, int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('drag_sound_track_$trackId', index);
  }

  /// Reset track to first sound
  Future<void> resetTrack(String trackId) async {
    _trackIndexes[trackId] = 0;
    await _saveTrackIndex(trackId, 0);
  }
}

/// ─────────────────────────────────────────────────────────────────────────────
///  SOUND TRACK CONTROLLER
class SoundTrackController {
  static final SoundTrackController instance = SoundTrackController._();
  SoundTrackController._();

  final Map<String, int> _trackIndexes = {};
  final Map<String, List<dynamic>> _trackSounds = {};
  final Map<String, SoundType> _trackTypes = {};

  /// Set sound track for a specific page/widget
  void setSoundTrack(String trackId, List<dynamic> sounds, SoundType type) {
    _trackSounds[trackId] = sounds;
    _trackTypes[trackId] = type;
    _loadTrackIndex(trackId);
  }

  /// Get current sound for a track
  dynamic getCurrentSound(String trackId) {
    if (!_trackSounds.containsKey(trackId) || _trackSounds[trackId]!.isEmpty) {
      return null;
    }
    final index = _trackIndexes[trackId] ?? 0;
    return _trackSounds[trackId]![index];
  }

  /// Get sound type for a track
  SoundType? getSoundType(String trackId) {
    return _trackTypes[trackId];
  }

  /// Move to next sound in track (called when leaving page)
  Future<void> nextTrack(String trackId) async {
    if (!_trackSounds.containsKey(trackId) || _trackSounds[trackId]!.isEmpty) {
      return;
    }
    final currentIndex = _trackIndexes[trackId] ?? 0;
    final nextIndex = (currentIndex + 1) % _trackSounds[trackId]!.length;
    _trackIndexes[trackId] = nextIndex;
    await _saveTrackIndex(trackId, nextIndex);
  }

  /// Move to previous sound in track
  Future<void> previousTrack(String trackId) async {
    if (!_trackSounds.containsKey(trackId) || _trackSounds[trackId]!.isEmpty) {
      return;
    }
    final currentIndex = _trackIndexes[trackId] ?? 0;
    final previousIndex = currentIndex == 0
        ? _trackSounds[trackId]!.length - 1
        : currentIndex - 1;
    _trackIndexes[trackId] = previousIndex;
    await _saveTrackIndex(trackId, previousIndex);
  }

  /// Get current track index
  int getCurrentTrackIndex(String trackId) {
    return _trackIndexes[trackId] ?? 0;
  }

  /// Get total tracks count
  int getTracksCount(String trackId) {
    return _trackSounds[trackId]?.length ?? 0;
  }

  /// Load track index from storage
  Future<void> _loadTrackIndex(String trackId) async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt('sound_track_$trackId') ?? 0;
    _trackIndexes[trackId] = index;
  }

  /// Save track index to storage
  Future<void> _saveTrackIndex(String trackId, int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('sound_track_$trackId', index);
  }

  /// Reset track to first sound
  Future<void> resetTrack(String trackId) async {
    _trackIndexes[trackId] = 0;
    await _saveTrackIndex(trackId, 0);
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
            SoundPaths.instance.backgroundSoundPaths[sound as SoundBackground]!;
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
      case SoundType.other:
        path = SoundPaths.instance.otherSoundPaths[sound as SoundOther]!;
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
