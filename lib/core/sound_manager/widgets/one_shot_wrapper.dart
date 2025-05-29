import 'package:flutter/material.dart';
import '../utils/sound_utils.dart';

class OneShotOnInitWrapper extends StatefulWidget {
  final Widget child;
  final String path;
  final double volume;

  const OneShotOnInitWrapper({
    super.key,
    required this.child,
    required this.path,
    this.volume = 1.0,
  });

  @override
  State<OneShotOnInitWrapper> createState() => _OneShotOnInitWrapperState();
}

class _OneShotOnInitWrapperState extends State<OneShotOnInitWrapper> {
  bool _hasPlayed = false;

  @override
  void initState() {
    super.initState();
    _playSound();
  }

  Future<void> _playSound() async {
    if (_hasPlayed) return;

    try {
      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;

      await playOneShot(widget.path, volume: widget.volume);
      _hasPlayed = true;
    } catch (e) {
      debugPrint('[OneShotOnInitWrapper] Error playing sound: $e');
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
