import 'sound_enums.dart';

const _assetPrefix = 'packages/studyo_music_library/';

/// Class to manage sound asset paths
class SoundPaths {
  SoundPaths._(); // singleton
  static final instance = SoundPaths._();

  static const _root = '${_assetPrefix}assets/sounds/';

  final SoundBackgroundPaths = <SoundBackground, String>{
    SoundBackground.balance: '${_root}background/balance.m4a',
    SoundBackground.bonus: '${_root}background/bonus.m4a',
    SoundBackground.bubbles: '${_root}background/bubbles.m4a',
    SoundBackground.curious: '${_root}background/curious.m4a',
    SoundBackground.curiousSituation:
        '${_root}background/curious_situation.m4a',
    SoundBackground.journal: '${_root}background/journal.m4a',
    SoundBackground.journal2: '${_root}background/journal2.m4a',
    SoundBackground.menu1: '${_root}background/menu1.m4a',
    SoundBackground.menu2: '${_root}background/menu2.m4a',
    SoundBackground.profile: '${_root}background/profile.m4a',
    SoundBackground.teamup: '${_root}background/teamup.m4a',
    SoundBackground.tetris: '${_root}background/tetris.m4a',
  };

  final balanceSoundPaths = <SoundBalance, String>{
    SoundBalance.hit: '${_root}balance/hit.m4a',
  };

  final bubbleSoundPaths = <SoundBubble, String>{
    SoundBubble.bubblegetout: '${_root}bubble/bubblegetout.m4a',
    SoundBubble.fail: '${_root}bubble/fail.m4a',
    SoundBubble.friction: '${_root}bubble/friction.m4a',
    SoundBubble.move: '${_root}bubble/move.m4a',
    SoundBubble.newbubble: '${_root}bubble/newbubble.m4a',
    SoundBubble.rightanswer: '${_root}bubble/rightanswer.m4a',
  };

  final cheeringSoundPaths = <SoundCheering, String>{
    SoundCheering.applause41CrowdJam:
        '${_root}cheering/applause_41_crowd_jam.m4a',
    SoundCheering.audienceCheeringLoop:
        '${_root}cheering/audience_cheering_loop.m4a',
    SoundCheering.aLoopingCrowdScanding:
        '${_root}cheering/a_looping_crowd_scanding.m4a',
    SoundCheering.cheeringAndClappingSportFans:
        '${_root}cheering/cheering_and_clapping_sport_fans.m4a',
    SoundCheering.childrenCheering: '${_root}cheering/children_cheering.m4a',
    SoundCheering.childrenCheeringApplauding:
        '${_root}cheering/children_cheering_applauding.m4a',
    SoundCheering.childrenCheeringYea:
        '${_root}cheering/children_cheering_yea.m4a',
    SoundCheering.childrenYellingYay:
        '${_root}cheering/children_yelling_yay.m4a',
    SoundCheering.childrenYellingYay2:
        '${_root}cheering/children_yelling_yay_2.m4a',
    SoundCheering.childrenYellingYay3:
        '${_root}cheering/children_yelling_yay_3.m4a',
    SoundCheering.kidsApplauding: '${_root}cheering/kids_applauding.m4a',
    SoundCheering.kidsCheeringYay: '${_root}cheering/kids_cheering_yay.m4a',
    SoundCheering.rhytmicAudienceClappingLoopfull:
        '${_root}cheering/rhytmic_audience_clapping_loopfull.m4a',
    SoundCheering.smallScreamyApplause:
        '${_root}cheering/small_screamy_applause.m4a',
  };

  final clickSoundPaths = <SoundClick, String>{
    SoundClick.interfaceClick: '${_root}click/interface_click.m4a',
    SoundClick.quirkyButton1: '${_root}click/quirky_button_1.m4a',
    SoundClick.quirkyButton2: '${_root}click/quirky_button_2.m4a',
    SoundClick.quirkyButton3: '${_root}click/quirky_button_3.m4a',
  };

  final clipSoundPaths = <SoundClip, String>{
    SoundClip.awardHappy: '${_root}clip/award_happy.m4a',
    SoundClip.buttonMagicComplete: '${_root}clip/button_magic_complete.m4a',
    SoundClip.cartoonRoughPlop: '${_root}clip/cartoon_rough_plop.m4a',
    SoundClip.connectGamePlop: '${_root}clip/connect_game_plop.m4a',
    SoundClip.containerdrop: '${_root}clip/containerdrop.m4a',
    SoundClip.elasticsnapstretchlowendwhompsmackcordO1ewa01:
        '${_root}clip/elasticsnapstretchlowendwhompsmackcord_o1ewa_01.m4a',
    SoundClip.fastArpPlucksDown: '${_root}clip/fast_arp_plucks_down.m4a',
    SoundClip.itemGetsDropped: '${_root}clip/item_gets_dropped.m4a',
    SoundClip.machantqElectronicAddingMachinePressSingleGenhd100038:
        '${_root}clip/machantq_electronic_adding_machine_press_single_genhd100038.m4a',
    SoundClip.pickup: '${_root}clip/pickup.m4a',
    SoundClip.plopBulbSelect: '${_root}clip/plop_bulb_select.m4a',
    SoundClip.plopPopCartoonHit1: '${_root}clip/plop_pop_cartoon_hit_1.m4a',
    SoundClip.plopPopCartoonHit2: '${_root}clip/plop_pop_cartoon_hit_2.m4a',
    SoundClip.plopPopCartoonHit5: '${_root}clip/plop_pop_cartoon_hit_5.m4a',
    SoundClip.plopPopCartoonHit7: '${_root}clip/plop_pop_cartoon_hit_7.m4a',
    SoundClip.suctionplopBw: '${_root}clip/suctionplop_bw.m4a',
    SoundClip.tieclipsnapwhilebeingpulledoffcuhandleOrplp03:
        '${_root}clip/tieclipsnapwhilebeingpulledoffcuhandle_orplp_03.m4a',
  };

  final coinsSoundPaths = <SoundCoins, String>{
    SoundCoins.casinoWinLoopEnd: '${_root}coins/casino_win_loop_end.m4a',
    SoundCoins.coin1: '${_root}coins/coin1.m4a',
    SoundCoins.collectingCoins2: '${_root}coins/collecting_coins_2.m4a',
    SoundCoins.collectCoin: '${_root}coins/collect_coin.m4a',
    SoundCoins.collectCoins1: '${_root}coins/collect_coins_1.m4a',
    SoundCoins.collectCoins2: '${_root}coins/collect_coins_2.m4a',
    SoundCoins.collectCoins3: '${_root}coins/collect_coins_3.m4a',
    SoundCoins.jackpotWinLoopEnd: '${_root}coins/jackpot_win__loop_end.m4a',
    SoundCoins.pickcoin: '${_root}coins/pickcoin.m4a',
    SoundCoins.refund: '${_root}coins/refund.m4a',
    SoundCoins.winSlotMachineLoopEnd:
        '${_root}coins/win_slot_machine__loop_end.m4a',
  };

  final denySoundPaths = <SoundDeny, String>{
    SoundDeny.buttonScifiDevice: '${_root}deny/button_scifi_device.m4a',
    SoundDeny.cartoonThinJumpPlop: '${_root}deny/cartoon_thin_jump_plop.m4a',
    SoundDeny.confirmDenied: '${_root}deny/confirm_denied.m4a',
    SoundDeny.delete: '${_root}deny/delete.m4a',
    SoundDeny.denyFatLow: '${_root}deny/deny_fat_low.m4a',
    SoundDeny.gentleOkPluckDing: '${_root}deny/gentle_ok_pluck_ding.m4a',
    SoundDeny.interfaceSciFiDenyStabHard:
        '${_root}deny/interface_sci_fi_deny_stab_hard.m4a',
    SoundDeny.woodDiscreteNotifyAccessDeniedfull:
        '${_root}deny/wood_discrete_notify_access_deniedfull.m4a',
  };

  final failSoundPaths = <SoundFail, String>{
    SoundFail.buttonMagicEngage: '${_root}fail/button_magic_engage.m4a',
    SoundFail.cartoonFailUp: '${_root}fail/cartoon_fail_up.m4a',
    SoundFail.cuteCartoonFail: '${_root}fail/cute_cartoon_fail.m4a',
    SoundFail.funtimeCartoonFailure1:
        '${_root}fail/funtime_cartoon_failure_1.m4a',
    SoundFail.funCartoonFail: '${_root}fail/fun_cartoon_fail.m4a',
    SoundFail.funLittleRetroFail: '${_root}fail/fun_little_retro_fail.m4a',
    SoundFail.pleasingGameFail: '${_root}fail/pleasing_game_fail.m4a',
  };

  final levelupSoundPaths = <SoundLevelup, String>{
    SoundLevelup.gameWin1: '${_root}levelup/game_win_1.m4a',
    SoundLevelup.gameWin2: '${_root}levelup/game_win_2.m4a',
    SoundLevelup.gameWin3: '${_root}levelup/game_win_3.m4a',
    SoundLevelup.gameWin4: '${_root}levelup/game_win_4.m4a',
    SoundLevelup.levelUp: '${_root}levelup/level_up.m4a',
    SoundLevelup.levelUp1: '${_root}levelup/level_up_1.m4a',
    SoundLevelup.levelUp4: '${_root}levelup/level_up_4.m4a',
  };

  final loginSoundPaths = <SoundLogin, String>{
    SoundLogin.sparklingLoginDing: '${_root}login/sparkling_login_ding.m4a',
  };

  final messagesSoundPaths = <SoundMessages, String>{
    SoundMessages.message: '${_root}messages/message.m4a',
  };

  final pets_cleaningSoundPaths = <SoundPetsCleaning, String>{
    SoundPetsCleaning.scrubbing: '${_root}pets_cleaning/scrubbing.m4a',
    SoundPetsCleaning.shower: '${_root}pets_cleaning/shower.m4a',
    SoundPetsCleaning.spray: '${_root}pets_cleaning/spray.m4a',
    SoundPetsCleaning.towel: '${_root}pets_cleaning/towel.m4a',
  };

  final pets_eatSoundPaths = <SoundPetsEat, String>{
    SoundPetsEat.cat: '${_root}pets_eat/cat.m4a',
    SoundPetsEat.dog: '${_root}pets_eat/dog.m4a',
    SoundPetsEat.owl: '${_root}pets_eat/owl.m4a',
    SoundPetsEat.rabbit: '${_root}pets_eat/rabbit.m4a',
    SoundPetsEat.squirrel: '${_root}pets_eat/squirrel.m4a',
  };

  final pets_playSoundPaths = <SoundPetsPlay, String>{
    SoundPetsPlay.cat: '${_root}pets_play/cat.m4a',
    SoundPetsPlay.cat2: '${_root}pets_play/cat2.m4a',
    SoundPetsPlay.dog: '${_root}pets_play/dog.m4a',
    SoundPetsPlay.dog2: '${_root}pets_play/dog2.m4a',
    SoundPetsPlay.owl: '${_root}pets_play/owl.m4a',
    SoundPetsPlay.owl2: '${_root}pets_play/owl2.m4a',
    SoundPetsPlay.rabbit: '${_root}pets_play/rabbit.m4a',
    SoundPetsPlay.rabbit2: '${_root}pets_play/rabbit2.m4a',
    SoundPetsPlay.squirrel: '${_root}pets_play/squirrel.m4a',
    SoundPetsPlay.squirrel2: '${_root}pets_play/squirrel2.m4a',
  };

  final pets_short_reactionsSoundPaths = <SoundPetsShortReactions, String>{
    SoundPetsShortReactions.birdowlJba0346:
        '${_root}pets_short_reactions/birdowl_jba03_46.m4a',
    SoundPetsShortReactions.cartoonHappyDog1full:
        '${_root}pets_short_reactions/cartoon_happy_dog_1full.m4a',
    SoundPetsShortReactions.cartoonHappyWinTwirlfull:
        '${_root}pets_short_reactions/cartoon_happy_win_twirlfull.m4a',
    SoundPetsShortReactions.cartoonSquirrelLaughfull:
        '${_root}pets_short_reactions/cartoon_squirrel_laughfull.m4a',
    SoundPetsShortReactions.cartoonSquirrelLaughter:
        '${_root}pets_short_reactions/cartoon_squirrel_laughter.m4a',
    SoundPetsShortReactions.cartoonSquirrelVoice02:
        '${_root}pets_short_reactions/cartoon_squirrel_voice_02.m4a',
    SoundPetsShortReactions.cartoonUnglyBirdHappyfull:
        '${_root}pets_short_reactions/cartoon_ungly_bird_happyfull.m4a',
    SoundPetsShortReactions.cuteCreaturePlayfulShoutfull:
        '${_root}pets_short_reactions/cute_creature_playful_shoutfull.m4a',
    SoundPetsShortReactions.femaleCat3:
        '${_root}pets_short_reactions/female_cat_3.m4a',
    SoundPetsShortReactions.squirrelJba02741:
        '${_root}pets_short_reactions/squirrel_jba02_74_1.m4a',
  };

  final pickupSoundPaths = <SoundPickup, String>{
    SoundPickup.button1: '${_root}pickup/button1.m4a',
    SoundPickup.interfaceClick: '${_root}pickup/interface_click.m4a',
    SoundPickup.itemPickUp: '${_root}pickup/item_pick_up.m4a',
    SoundPickup.pickup1: '${_root}pickup/pickup1.m4a',
    SoundPickup.pickupUseItem2: '${_root}pickup/pickup_use_item_2.m4a',
    SoundPickup.pickupUseItem3: '${_root}pickup/pickup_use_item_3.m4a',
    SoundPickup.plop: '${_root}pickup/plop.m4a',
    SoundPickup.plopPack2: '${_root}pickup/plop_pack_2.m4a',
    SoundPickup.plopPack3: '${_root}pickup/plop_pack_3.m4a',
    SoundPickup.plopPack4: '${_root}pickup/plop_pack_4.m4a',
  };

  final remindersSoundPaths = <SoundReminders, String>{
    SoundReminders.mountainAudioWoodBlockRhythm1:
        '${_root}reminders/mountain_audio__wood_block_rhythm_1.m4a',
    SoundReminders.musichanddrumBw25557:
        '${_root}reminders/musichanddrum_bw25557.m4a',
    SoundReminders.scoreTallyLoop02:
        '${_root}reminders/score_tally_loop_02.m4a',
    SoundReminders.timeCountdownLoop:
        '${_root}reminders/time_countdown_loop.m4a',
  };

  final resourcesSoundPaths = <SoundResources, String>{
    SoundResources.cleaning: '${_root}resources/cleaning.m4a',
    SoundResources.food: '${_root}resources/food.m4a',
    SoundResources.starcollect: '${_root}resources/starcollect.m4a',
    SoundResources.toys: '${_root}resources/toys.m4a',
  };

  final reviewSoundPaths = <SoundReview, String>{
    SoundReview.happy: '${_root}review/happy.m4a',
    SoundReview.sad: '${_root}review/sad.m4a',
  };

  final sendSoundPaths = <SoundSend, String>{
    SoundSend.inviteToChatRoom1full:
        '${_root}send/invite_to_chat_room_1full.m4a',
  };

  final successSoundPaths = <SoundSuccess, String>{
    SoundSuccess.bonuswin: '${_root}success/bonuswin.m4a',
    SoundSuccess.celebration: '${_root}success/celebration.m4a',
    SoundSuccess.completed: '${_root}success/completed.m4a',
    SoundSuccess.fanfare: '${_root}success/fanfare.m4a',
    SoundSuccess.gameSuccessWin: '${_root}success/game_success_win.m4a',
    SoundSuccess.gameWin: '${_root}success/game_win.m4a',
    SoundSuccess.happyWinGame: '${_root}success/happy_win_game.m4a',
    SoundSuccess.okButton: '${_root}success/ok_button.m4a',
    SoundSuccess.positiveGameWin: '${_root}success/positive_game_win.m4a',
    SoundSuccess.positiveWin: '${_root}success/positive_win.m4a',
    SoundSuccess.successJoy: '${_root}success/success_joy.m4a',
    SoundSuccess.winning: '${_root}success/winning.m4a',
    SoundSuccess.winGame: '${_root}success/win_game.m4a',
  };

  final tapSoundPaths = <SoundTAP, String>{
    SoundTAP.tap: '${_root}tap/tap.m4a',
  };

  final tetrisSoundPaths = <SoundTetris, String>{
    SoundTetris.allfound: '${_root}tetris/allfound.m4a',
    SoundTetris.fall: '${_root}tetris/fall.m4a',
    SoundTetris.hit: '${_root}tetris/hit.m4a',
    SoundTetris.right: '${_root}tetris/right.m4a',
    SoundTetris.select: '${_root}tetris/select.m4a',
    SoundTetris.unselect: '${_root}tetris/unselect.m4a',
    SoundTetris.wrong: '${_root}tetris/wrong.m4a',
  };

  final transitionsSoundPaths = <SoundTransitions, String>{
    SoundTransitions.expand: '${_root}transitions/expand.m4a',
    SoundTransitions.opener: '${_root}transitions/opener.m4a',
    SoundTransitions.shrink: '${_root}transitions/shrink.m4a',
  };

  final whooshSoundPaths = <SoundWhoosh, String>{
    SoundWhoosh.abstractPositiveGameWin1:
        '${_root}whoosh/abstract_positive_game_win_1.m4a',
    SoundWhoosh.airyWhoosh: '${_root}whoosh/airy_whoosh.m4a',
    SoundWhoosh.bladeWhoosh: '${_root}whoosh/blade_whoosh.m4a',
    SoundWhoosh.cartoonwhooshBw3973: '${_root}whoosh/cartoonwhoosh_bw3973.m4a',
    SoundWhoosh.cartoonDeployWhooshfull:
        '${_root}whoosh/cartoon_deploy_whooshfull.m4a',
    SoundWhoosh.heavySwordWhoosh: '${_root}whoosh/heavy_sword_whoosh.m4a',
    SoundWhoosh.heavyWhoosh: '${_root}whoosh/heavy_whoosh.m4a',
    SoundWhoosh.longwhoosh: '${_root}whoosh/longwhoosh.m4a',
    SoundWhoosh.mountainAudioDeepWhoosh:
        '${_root}whoosh/mountain_audio__deep_whoosh.m4a',
    SoundWhoosh.ninjaPunchWhoosh: '${_root}whoosh/ninja_punch_whoosh.m4a',
    SoundWhoosh.sharpSwordWhoosh: '${_root}whoosh/sharp_sword_whoosh.m4a',
    SoundWhoosh.sharpWhoosh: '${_root}whoosh/sharp_whoosh.m4a',
    SoundWhoosh.swordWhoosh3: '${_root}whoosh/sword_whoosh_3.m4a',
    SoundWhoosh.swordWhoosh5: '${_root}whoosh/sword_whoosh_5.m4a',
    SoundWhoosh.turn: '${_root}whoosh/turn.m4a',
    SoundWhoosh.whooshmove: '${_root}whoosh/whooshmove.m4a',
    SoundWhoosh.whoosh2: '${_root}whoosh/whoosh_2.m4a',
    SoundWhoosh.whooshAccelerate: '${_root}whoosh/whoosh_accelerate.m4a',
    SoundWhoosh.whooshSingle: '${_root}whoosh/whoosh_single.m4a',
  };

  String? getSoundPath(SoundCategory cat, dynamic sound) {
    switch (cat) {
      case SoundCategory.background:
        return SoundBackgroundPaths[sound];
      case SoundCategory.balance:
        return balanceSoundPaths[sound];
      case SoundCategory.bubble:
        return bubbleSoundPaths[sound];
      case SoundCategory.cheering:
        return cheeringSoundPaths[sound];
      case SoundCategory.click:
        return clickSoundPaths[sound];
      case SoundCategory.clip:
        return clipSoundPaths[sound];
      case SoundCategory.coins:
        return coinsSoundPaths[sound];
      case SoundCategory.deny:
        return denySoundPaths[sound];
      case SoundCategory.fail:
        return failSoundPaths[sound];
      case SoundCategory.levelup:
        return levelupSoundPaths[sound];
      case SoundCategory.login:
        return loginSoundPaths[sound];
      case SoundCategory.messages:
        return messagesSoundPaths[sound];
      case SoundCategory.petsCleaning:
        return pets_cleaningSoundPaths[sound];
      case SoundCategory.petsEat:
        return pets_eatSoundPaths[sound];
      case SoundCategory.petsPlay:
        return pets_playSoundPaths[sound];
      case SoundCategory.petsShortReactions:
        return pets_short_reactionsSoundPaths[sound];
      case SoundCategory.pickup:
        return pickupSoundPaths[sound];
      case SoundCategory.reminders:
        return remindersSoundPaths[sound];
      case SoundCategory.resources:
        return resourcesSoundPaths[sound];
      case SoundCategory.review:
        return reviewSoundPaths[sound];
      case SoundCategory.send:
        return sendSoundPaths[sound];
      case SoundCategory.success:
        return successSoundPaths[sound];
      case SoundCategory.tap:
        return tapSoundPaths[sound];
      case SoundCategory.tetris:
        return tetrisSoundPaths[sound];
      case SoundCategory.transitions:
        return transitionsSoundPaths[sound];
      case SoundCategory.whoosh:
        return whooshSoundPaths[sound];
    }
  }

  /// semua path absolut (assets/…) — untuk preload
  List<String> getAllSoundPaths() => [
        ...SoundBackgroundPaths.values,
        ...balanceSoundPaths.values,
        ...bubbleSoundPaths.values,
        ...cheeringSoundPaths.values,
        ...clickSoundPaths.values,
        ...clipSoundPaths.values,
        ...coinsSoundPaths.values,
        ...denySoundPaths.values,
        ...failSoundPaths.values,
        ...levelupSoundPaths.values,
        ...loginSoundPaths.values,
        ...messagesSoundPaths.values,
        ...pets_cleaningSoundPaths.values,
        ...pets_eatSoundPaths.values,
        ...pets_playSoundPaths.values,
        ...pets_short_reactionsSoundPaths.values,
        ...pickupSoundPaths.values,
        ...remindersSoundPaths.values,
        ...resourcesSoundPaths.values,
        ...reviewSoundPaths.values,
        ...sendSoundPaths.values,
        ...successSoundPaths.values,
        ...tapSoundPaths.values,
        ...tetrisSoundPaths.values,
        ...transitionsSoundPaths.values,
        ...whooshSoundPaths.values,
      ];
}
