import 'sound_enums.dart';

const _assetPrefix = '';

/// Class to manage sound asset paths
/// Class to manage sound asset paths
class SoundPaths {
  SoundPaths._();                // singleton
  static final instance = SoundPaths._();

  static const _root = 'assets/sounds/';

  final bgmSoundPaths = <BGMSound, String>{
    BGMSound.birdsSinging : '${_root}bgm/children_learning.m4a',
    BGMSound.fluteMusic   : '${_root}bgm/cozy_lofi_fireside_short_30.m4a',
  };

  final clickSoundPaths = <ClickSound, String>{
    ClickSound.gameClick   : '${_root}click/mixkit-game-click-1114.wav',
    ClickSound.selectClick : '${_root}click/mixkit-select-click-1109.wav',
  };

  final sfxSoundPaths = <SFXSound, String>{
    SFXSound.airWoosh : '${_root}sfx/mixkit-air-woosh-1489.wav',
  };

  final notificationSoundPaths = <NotificationSound, String>{
    NotificationSound.retroArcade : '${_root}notification/mixkit-retro-arcade-casino-notification-211.wav',
    NotificationSound.mysteryAlert: '${_root}notification/mixkit-video-game-mystery-alert-234.wav',
  };

  String? getSoundPath(SoundCategory cat, dynamic sound) {
    switch (cat) {
      case SoundCategory.clickEvent : return clickSoundPaths[sound];
      case SoundCategory.bgm        : return bgmSoundPaths[sound];
      case SoundCategory.sfx        : return sfxSoundPaths[sound];
      case SoundCategory.notification: return notificationSoundPaths[sound];
    }
  }

  /// semua path absolut (assets/…) — untuk preload
  List<String> getAllSoundPaths() => [
    ...bgmSoundPaths.values,
    ...clickSoundPaths.values,
    ...sfxSoundPaths.values,
    ...notificationSoundPaths.values,
  ];
}

