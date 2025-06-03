// Extension untuk Widget terkait sound
import 'package:flutter/material.dart';
import 'package:studyo_music_library/core/sound_manager/core/sound_enums.dart';
import 'package:studyo_music_library/core/sound_manager/core/sound_paths.dart';
import 'package:studyo_music_library/core/sound_manager/manager/bgm_global_wrapper.dart';
import 'package:studyo_music_library/core/sound_manager/manager/bgm_manager.dart';
import 'package:studyo_music_library/core/sound_manager/manager/bgm_wrapper.dart';
import 'package:studyo_music_library/core/sound_manager/widgets/sound_widgets.dart';

extension SoundExtension on Widget {
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
