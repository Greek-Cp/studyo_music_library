// Widget wrapper untuk BGM per halaman
import 'package:flutter/material.dart';
import '../core/sound_enums.dart';
import 'bgm_manager.dart';

class BgmWrapper extends StatefulWidget {
  const BgmWrapper({required this.child, required this.bgm});
  final Widget child;
  final SoundBackground bgm;
  @override
  State<BgmWrapper> createState() => BgmWrapperState();
}

class BgmWrapperState extends State<BgmWrapper> with RouteAware {
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
    BgmManager.instance.pauseForNavigation();
  }

  @override
  void didPopNext() {
    BgmManager.instance.resumeFromNavigation();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
