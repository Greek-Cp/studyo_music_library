import 'package:flutter/material.dart';
import '../sound_enums.dart';
import '../sound_paths.dart';
import '../widgets/one_shot_wrapper.dart';
import '../widgets/tap_sound_wrapper.dart';

extension ClickSoundExtension on Widget {
  Widget addClickSound(ClickSound s, {double volume = 1}) => TapSoundWrapper(
      path: SoundPaths.instance.clickSoundPaths[s]!,
      volume: volume,
      child: this);
}

extension SfxAppearExtension on Widget {
  Widget addSfxOnAppear(SFXSound s, {double volume = 1}) =>
      OneShotOnInitWrapper(
          path: SoundPaths.instance.sfxSoundPaths[s]!,
          volume: volume,
          child: this);
}

extension NotificationSoundExtension on Widget {
  Widget addNotificationSound(NotificationSound n, {double volume = 1}) =>
      OneShotOnInitWrapper(
          path: SoundPaths.instance.notificationSoundPaths[n]!,
          volume: volume,
          child: this);
}
