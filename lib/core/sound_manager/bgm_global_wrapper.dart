// Widget wrapper untuk global BGM
import 'package:flutter/material.dart';
import 'sound_enums.dart';
import 'bgm_manager.dart';

class BgmGlobalWrapper extends StatefulWidget {
  const BgmGlobalWrapper({
    required this.child,
    required this.listSound,
  });
  final Widget child;
  final List<SoundBackground> listSound;
  @override
  State<BgmGlobalWrapper> createState() => BgmGlobalWrapperState();
}

class BgmGlobalWrapperState extends State<BgmGlobalWrapper> with RouteAware {
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
    BgmManager.instance.pauseForNavigation();
  }

  @override
  void didPopNext() {
    BgmManager.instance.resumeFromNavigation();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
