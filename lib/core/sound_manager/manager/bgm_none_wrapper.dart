// Widget wrapper untuk halaman tanpa BGM (silent)
import 'package:flutter/material.dart';
import 'bgm_manager.dart';

class BgmNoneWrapper extends StatefulWidget {
  const BgmNoneWrapper({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<BgmNoneWrapper> createState() => BgmNoneWrapperState();
}

class BgmNoneWrapperState extends State<BgmNoneWrapper> with RouteAware {
  @override
  void initState() {
    super.initState();
    BgmManager.instance.pushNone();
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
    BgmManager.instance.popNone();
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
