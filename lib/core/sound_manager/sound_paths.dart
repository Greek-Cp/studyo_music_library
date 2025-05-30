import 'sound_enums.dart';

const _assetPrefix = 'packages/studyo_music_library/';

/// Class to manage sound asset paths
class SoundPaths {
  SoundPaths._(); // singleton
  static final instance = SoundPaths._();

  static const _root = '${_assetPrefix}assets/sounds/';

  final backgroundSoundPaths = <BackgroundSound, String>{
    BackgroundSound.journal: '${_root}background/journal.m4a',
    BackgroundSound.journal2: '${_root}background/journal2.m4a',
    BackgroundSound.bonus: '${_root}background/bonus.m4a',
    BackgroundSound.teamup: '${_root}background/teamup.m4a',
    BackgroundSound.bubbles: '${_root}background/bubbles.m4a',
    BackgroundSound.tetris: '${_root}background/tetris.m4a',
    BackgroundSound.balance: '${_root}background/balance.m4a',
  };

  final coinsSoundPaths = <CoinsSound, String>{
    CoinsSound.coin1: '${_root}coins/coin1.m4a',
    CoinsSound.coin1: '${_root}coins/coin1.m4a',
    CoinsSound.coin1: '${_root}coins/coin1.m4a',
    CoinsSound.coin1: '${_root}coins/coin1.m4a',
    CoinsSound.coin1: '${_root}coins/coin1.m4a',
    CoinsSound.refund: '${_root}coins/refund.m4a',
  };

  final resourcesSoundPaths = <ResourcesSound, String>{
    ResourcesSound.starcollect: '${_root}resources/starcollect.m4a',
    ResourcesSound.food: '${_root}resources/food.m4a',
    ResourcesSound.cleaning: '${_root}resources/cleaning.m4a',
    ResourcesSound.toys: '${_root}resources/toys.m4a',
  };

  final successSoundPaths = <SuccessSound, String>{
    SuccessSound.winning: '${_root}success/winning.m4a',
    SuccessSound.celebration: '${_root}success/celebration.m4a',
    SuccessSound.completed: '${_root}success/completed.m4a',
    SuccessSound.completed: '${_root}success/completed.m4a',
    SuccessSound.completed: '${_root}success/completed.m4a',
    SuccessSound.celebration: '${_root}success/celebration.m4a',
    SuccessSound.fanfare: '${_root}success/fanfare.m4a',
    SuccessSound.bonuswin: '${_root}success/bonuswin.m4a',
    SuccessSound.celebration: '${_root}success/celebration.m4a',
    SuccessSound.winning: '${_root}success/winning.m4a',
    SuccessSound.completed: '${_root}success/completed.m4a',
    SuccessSound.fanfare: '${_root}success/fanfare.m4a',
  };

  final transitionsSoundPaths = <TransitionsSound, String>{
    TransitionsSound.opener: '${_root}transitions/opener.m4a',
    TransitionsSound.expand: '${_root}transitions/expand.m4a',
    TransitionsSound.shrink: '${_root}transitions/shrink.m4a',
  };

  final pets_playSoundPaths = <PetsPlaySound, String>{
    PetsPlaySound.cat: '${_root}pets_play/cat.m4a',
    PetsPlaySound.cat2: '${_root}pets_play/cat2.m4a',
    PetsPlaySound.dog: '${_root}pets_play/dog.m4a',
    PetsPlaySound.dog2: '${_root}pets_play/dog2.m4a',
    PetsPlaySound.squirrel: '${_root}pets_play/squirrel.m4a',
    PetsPlaySound.squirrel2: '${_root}pets_play/squirrel2.m4a',
    PetsPlaySound.rabbit: '${_root}pets_play/rabbit.m4a',
    PetsPlaySound.rabbit2: '${_root}pets_play/rabbit2.m4a',
    PetsPlaySound.owl: '${_root}pets_play/owl.m4a',
    PetsPlaySound.owl2: '${_root}pets_play/owl2.m4a',
  };

  final pets_eatSoundPaths = <PetsEatSound, String>{
    PetsEatSound.cat: '${_root}pets_eat/cat.m4a',
    PetsEatSound.dog: '${_root}pets_eat/dog.m4a',
    PetsEatSound.squirrel: '${_root}pets_eat/squirrel.m4a',
    PetsEatSound.rabbit: '${_root}pets_eat/rabbit.m4a',
    PetsEatSound.owl: '${_root}pets_eat/owl.m4a',
  };

  final pets_cleaningSoundPaths = <PetsCleaningSound, String>{
    PetsCleaningSound.spray: '${_root}pets_cleaning/spray.m4a',
    PetsCleaningSound.towel: '${_root}pets_cleaning/towel.m4a',
    PetsCleaningSound.shower: '${_root}pets_cleaning/shower.m4a',
    PetsCleaningSound.scrubbing: '${_root}pets_cleaning/scrubbing.m4a',
  };

  final bubbleSoundPaths = <BubbleSound, String>{
    BubbleSound.newbubble: '${_root}bubble/newbubble.m4a',
    BubbleSound.move: '${_root}bubble/move.m4a',
    BubbleSound.bubblegetout: '${_root}bubble/bubblegetout.m4a',
    BubbleSound.friction: '${_root}bubble/friction.m4a',
    BubbleSound.rightanswer: '${_root}bubble/rightanswer.m4a',
    BubbleSound.fail: '${_root}bubble/fail.m4a',
  };

  final tetrisSoundPaths = <TetrisSound, String>{
    TetrisSound.select: '${_root}tetris/select.m4a',
    TetrisSound.unselect: '${_root}tetris/unselect.m4a',
    TetrisSound.right: '${_root}tetris/right.m4a',
    TetrisSound.wrong: '${_root}tetris/wrong.m4a',
    TetrisSound.allfound: '${_root}tetris/allfound.m4a',
    TetrisSound.fall: '${_root}tetris/fall.m4a',
    TetrisSound.hit: '${_root}tetris/hit.m4a',
  };

  final whooshSoundPaths = <WhooshSound, String>{
    WhooshSound.longwhoosh: '${_root}whoosh/longwhoosh.m4a',
    WhooshSound.longwhoosh: '${_root}whoosh/longwhoosh.m4a',
    WhooshSound.whooshmove: '${_root}whoosh/whooshmove.m4a',
    WhooshSound.turn: '${_root}whoosh/turn.m4a',
  };

  final balanceSoundPaths = <BalanceSound, String>{
    BalanceSound.hit: '${_root}balance/hit.m4a',
  };

  final tapSoundPaths = <TAPSound, String>{
    TAPSound.tap: '${_root}tap/tap.m4a',
    TAPSound.tap: '${_root}tap/tap.m4a',
    TAPSound.tap: '${_root}tap/tap.m4a',
    TAPSound.tap: '${_root}tap/tap.m4a',
  };

  final reviewSoundPaths = <ReviewSound, String>{
    ReviewSound.happy: '${_root}review/happy.m4a',
    ReviewSound.sad: '${_root}review/sad.m4a',
  };

  final messagesSoundPaths = <MessagesSound, String>{
    MessagesSound.message: '${_root}messages/message.m4a',
  };

  final clipSoundPaths = <ClipSound, String>{
    ClipSound.containerdrop: '${_root}clip/containerdrop.m4a',
  };

  final denySoundPaths = <DenySound, String>{
    DenySound.delete: '${_root}deny/delete.m4a',
  };

  final pickupSoundPaths = <PickupSound, String>{
    PickupSound.plop: '${_root}pickup/plop.m4a',
  };

  String? getSoundPath(SoundCategory cat, dynamic sound) {
    switch (cat) {
      case SoundCategory.background:
        return backgroundSoundPaths[sound];
      case SoundCategory.coins:
        return coinsSoundPaths[sound];
      case SoundCategory.resources:
        return resourcesSoundPaths[sound];
      case SoundCategory.success:
        return successSoundPaths[sound];
      case SoundCategory.transitions:
        return transitionsSoundPaths[sound];
      case SoundCategory.petsPlay:
        return pets_playSoundPaths[sound];
      case SoundCategory.petsEat:
        return pets_eatSoundPaths[sound];
      case SoundCategory.petsCleaning:
        return pets_cleaningSoundPaths[sound];
      case SoundCategory.bubble:
        return bubbleSoundPaths[sound];
      case SoundCategory.tetris:
        return tetrisSoundPaths[sound];
      case SoundCategory.whoosh:
        return whooshSoundPaths[sound];
      case SoundCategory.balance:
        return balanceSoundPaths[sound];
      case SoundCategory.tap:
        return tapSoundPaths[sound];
      case SoundCategory.review:
        return reviewSoundPaths[sound];
      case SoundCategory.messages:
        return messagesSoundPaths[sound];
      case SoundCategory.clip:
        return clipSoundPaths[sound];
      case SoundCategory.deny:
        return denySoundPaths[sound];
      case SoundCategory.pickup:
        return pickupSoundPaths[sound];
    }
  }

  /// semua path absolut (assets/…) — untuk preload
  List<String> getAllSoundPaths() => [
        ...backgroundSoundPaths.values,
        ...coinsSoundPaths.values,
        ...resourcesSoundPaths.values,
        ...successSoundPaths.values,
        ...transitionsSoundPaths.values,
        // ...pets_playSoundPaths.values,
        // ...pets_eatSoundPaths.values,
        // ...pets_cleaningSoundPaths.values,
        ...bubbleSoundPaths.values,
        ...tetrisSoundPaths.values,
        ...whooshSoundPaths.values,
        ...balanceSoundPaths.values,
        ...tapSoundPaths.values,
        ...reviewSoundPaths.values,
        ...messagesSoundPaths.values,
        ...clipSoundPaths.values,
        ...denySoundPaths.values,
        ...pickupSoundPaths.values,
      ];
}
