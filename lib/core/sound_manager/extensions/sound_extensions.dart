// Extension untuk Widget terkait sound
import 'package:flutter/material.dart';
import 'package:studyo_music_library/core/sound_manager/core/sound_enums.dart';
import 'package:studyo_music_library/core/sound_manager/core/sound_paths.dart';
import 'package:studyo_music_library/core/sound_manager/core/sound_controller.dart';
import 'package:studyo_music_library/core/sound_manager/manager/bgm_global_wrapper.dart';
import 'package:studyo_music_library/core/sound_manager/manager/bgm_manager.dart';
import 'package:studyo_music_library/core/sound_manager/manager/bgm_wrapper.dart';
import 'package:studyo_music_library/core/sound_manager/widgets/sound_widgets.dart';

extension SoundExtension on Widget {
  /// Add sound to widget - supports both single sound and list of sounds
  ///
  /// For single sound:
  /// ```dart
  /// widget.addSound(SoundTAP.tap, SoundType.tap)
  /// ```
  ///
  /// For list of sounds with track management:
  /// ```dart
  /// widget.addSound([
  ///   SoundTAP.tap,
  ///   SoundTAP.deepbutton,
  ///   SoundTAP.bubble,
  /// ], SoundType.tap, trackId: 'page_b_containers')
  /// ```
  Widget addSound(
    dynamic sound,
    SoundType type, {
    double volume = 1.0,
    bool isDragWidget = false,
    String? trackId,
  }) {
    // Handle list of sounds with track management
    if (sound is List) {
      if (trackId == null) {
        throw ArgumentError('trackId is required when using list of sounds');
      }

      // Set up the track
      SoundTrackController.instance.setSoundTrack(trackId, sound, type);

      // Get current sound from track
      final currentSound =
          SoundTrackController.instance.getCurrentSound(trackId);
      if (currentSound == null) {
        return this; // Return widget without sound if no sound available
      }

      final path = _getSoundPath(currentSound, type);

      if (isDragWidget) {
        return DragSoundWrapper(
          path: path,
          volume: volume,
          type: type,
          child: this,
        );
      }
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapDown: (_) => playOneShot(path, volume: volume),
        child: this,
      );
    }

    // Handle single sound (original behavior)
    final path = _getSoundPath(sound, type);

    if (isDragWidget) {
      return DragSoundWrapper(
        path: path,
        volume: volume,
        type: type,
        child: this,
      );
    }
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (_) => playOneShot(path, volume: volume),
      child: this,
    );
  }

  /// Helper method to get sound path based on type
  String _getSoundPath(dynamic sound, SoundType type) {
    switch (type) {
      case SoundType.background:
        return SoundPaths
            .instance.backgroundSoundPaths[sound as SoundBackground]!;
      case SoundType.balance:
        return SoundPaths.instance.balanceSoundPaths[sound as SoundBalance]!;
      case SoundType.bubble:
        return SoundPaths.instance.bubbleSoundPaths[sound as SoundBubble]!;
      case SoundType.cheering:
        return SoundPaths.instance.cheeringSoundPaths[sound as SoundCheering]!;
      case SoundType.click:
        return SoundPaths.instance.clickSoundPaths[sound as SoundClick]!;
      case SoundType.clip:
        return SoundPaths.instance.clipSoundPaths[sound as SoundClip]!;
      case SoundType.coins:
        return SoundPaths.instance.coinsSoundPaths[sound as SoundCoins]!;
      case SoundType.deny:
        return SoundPaths.instance.denySoundPaths[sound as SoundDeny]!;
      case SoundType.fail:
        return SoundPaths.instance.failSoundPaths[sound as SoundFail]!;
      case SoundType.levelup:
        return SoundPaths.instance.levelupSoundPaths[sound as SoundLevelup]!;
      case SoundType.login:
        return SoundPaths.instance.loginSoundPaths[sound as SoundLogin]!;
      case SoundType.messages:
        return SoundPaths.instance.messagesSoundPaths[sound as SoundMessages]!;
      case SoundType.other:
        return SoundPaths.instance.otherSoundPaths[sound as SoundOther]!;
      case SoundType.petsCleaning:
        return SoundPaths
            .instance.pets_cleaningSoundPaths[sound as SoundPetsCleaning]!;
      case SoundType.petsEat:
        return SoundPaths.instance.pets_eatSoundPaths[sound as SoundPetsEat]!;
      case SoundType.petsPlay:
        return SoundPaths.instance.pets_playSoundPaths[sound as SoundPetsPlay]!;
      case SoundType.petsShortReactions:
        return SoundPaths.instance
            .pets_short_reactionsSoundPaths[sound as SoundPetsShortReactions]!;
      case SoundType.pickup:
        return SoundPaths.instance.pickupSoundPaths[sound as SoundPickup]!;
      case SoundType.reminders:
        return SoundPaths
            .instance.remindersSoundPaths[sound as SoundReminders]!;
      case SoundType.resources:
        return SoundPaths
            .instance.resourcesSoundPaths[sound as SoundResources]!;
      case SoundType.review:
        return SoundPaths.instance.reviewSoundPaths[sound as SoundReview]!;
      case SoundType.send:
        return SoundPaths.instance.sendSoundPaths[sound as SoundSend]!;
      case SoundType.success:
        return SoundPaths.instance.successSoundPaths[sound as SoundSuccess]!;
      case SoundType.tap:
        return SoundPaths.instance.tapSoundPaths[sound as SoundTAP]!;
      case SoundType.tetris:
        return SoundPaths.instance.tetrisSoundPaths[sound as SoundTetris]!;
      case SoundType.transitions:
        return SoundPaths
            .instance.transitionsSoundPaths[sound as SoundTransitions]!;
      case SoundType.whoosh:
        return SoundPaths.instance.whooshSoundPaths[sound as SoundWhoosh]!;
    }
  }
}

extension BgmExtension on Widget {
  Widget addBGM(SoundBackground bgm) => BgmWrapper(child: this, bgm: bgm);
}

extension BgmGlobalExtension on Widget {
  Widget addBGMGlobal(List<SoundBackground> listSound) => BgmGlobalWrapper(
        child: this,
        listSound: listSound,
      );
}
