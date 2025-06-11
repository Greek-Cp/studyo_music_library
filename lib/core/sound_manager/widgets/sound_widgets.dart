// Widget wrapper untuk sound effect pada drag/tap
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../core/sound_enums.dart';
import '../core/sound_paths.dart';
import '../core/sound_controller.dart';
import '../manager/bgm_manager.dart';

class DragSoundWrapper extends StatefulWidget {
  final Widget child;
  final String path;
  final double volume;
  final SoundType type;

  const DragSoundWrapper({
    required this.child,
    required this.path,
    required this.volume,
    required this.type,
  });

  @override
  State<DragSoundWrapper> createState() => DragSoundWrapperState();
}

class DragSoundWrapperState extends State<DragSoundWrapper> {
  DateTime? _lastPlayTime;
  static const _minInterval = Duration(milliseconds: 50);
  Offset? _lastPosition;
  bool _isDragging = false;
  double _lastVelocity = 0;
  static const _minVelocityThreshold = 300.0;
  static const _maxVelocityThreshold = 2000.0;
  bool _hasPlayedWhooshInCurrentDrag = false;

  void _onPointerDown(PointerDownEvent event) {
    final now = DateTime.now();
    if (_lastPlayTime == null ||
        now.difference(_lastPlayTime!) > _minInterval) {
      _lastPlayTime = now;
      _lastPosition = event.position;
      playOneShot(widget.path, volume: widget.volume);
    }
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (!_isDragging) {
      _isDragging = true;
      return;
    }

    if (_lastPosition != null) {
      final now = DateTime.now();
      final deltaTime =
          now.difference(_lastPlayTime ?? now).inMilliseconds / 1000.0;
      if (deltaTime > 0) {
        final deltaPosition = event.position - _lastPosition!;
        final velocity = deltaPosition.distance / deltaTime;
        _lastVelocity = velocity;

        if (!_hasPlayedWhooshInCurrentDrag &&
            velocity > _minVelocityThreshold &&
            deltaPosition.distance > 5) {
          final volumeScale = math.min(
              (velocity - _minVelocityThreshold) /
                  (_maxVelocityThreshold - _minVelocityThreshold),
              1.0);
          final whooshVolume = 0.3 + (volumeScale * 0.4);

          if (velocity > 10) {
            playOneShot(
              SoundPaths
                  .instance.whooshSoundPaths[SoundWhoosh.whooshAccelerate]!,
              volume: widget.volume * whooshVolume,
            );
            _hasPlayedWhooshInCurrentDrag = true;
          }
        }
      }
      _lastPosition = event.position;
      _lastPlayTime = now;
    }
  }

  void _onPointerUp(PointerUpEvent event) {
    if (_isDragging) {
      final dropVolume = math.min(_lastVelocity / _maxVelocityThreshold, 1.0);
      final clickVolume = 0.4 + (dropVolume * 0.3);
      playOneShot(
        SoundPaths.instance.clipSoundPaths[SoundClip.itemGetsDropped]!,
        volume: widget.volume * clickVolume,
      );
    }
    _isDragging = false;
    _lastPosition = null;
    _lastVelocity = 0;
    _hasPlayedWhooshInCurrentDrag = false;
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: _onPointerDown,
      onPointerMove: _onPointerMove,
      onPointerUp: _onPointerUp,
      child: widget.child,
    );
  }
}

/// Drag Sound Track Wrapper - supports 3 sound lists with track management
class DragSoundTrackWrapper extends StatefulWidget {
  final Widget child;
  final List<dynamic> tapSounds;
  final List<dynamic> whooshSounds;
  final List<dynamic> dropSounds;
  final SoundType tapType;
  final SoundType whooshType;
  final SoundType dropType;
  final String trackId;
  final double volume;

  const DragSoundTrackWrapper({
    super.key,
    required this.child,
    required this.tapSounds,
    required this.whooshSounds,
    required this.dropSounds,
    required this.tapType,
    required this.whooshType,
    required this.dropType,
    required this.trackId,
    this.volume = 1.0,
  });

  @override
  State<DragSoundTrackWrapper> createState() => _DragSoundTrackWrapperState();
}

class _DragSoundTrackWrapperState extends State<DragSoundTrackWrapper> {
  DateTime? _lastPlayTime;
  static const _minInterval = Duration(milliseconds: 50);
  Offset? _lastPosition;
  bool _isDragging = false;
  double _lastVelocity = 0;
  static const _minVelocityThreshold = 300.0;
  static const _maxVelocityThreshold = 2000.0;
  bool _hasPlayedWhooshInCurrentDrag = false;

  @override
  void initState() {
    super.initState();
    // Register sound tracks for all three types
    DragSoundTrackController.instance.setDragSoundTrack(
      widget.trackId,
      widget.tapSounds,
      widget.whooshSounds,
      widget.dropSounds,
      widget.tapType,
      widget.whooshType,
      widget.dropType,
    );
  }

  String _getSoundPath(dynamic sound, SoundType type) {
    switch (type) {
      case SoundType.tap:
        return SoundPaths.instance.tapSoundPaths[sound as SoundTAP]!;
      case SoundType.whoosh:
        return SoundPaths.instance.whooshSoundPaths[sound as SoundWhoosh]!;
      case SoundType.clip:
        return SoundPaths.instance.clipSoundPaths[sound as SoundClip]!;
      // Add other types as needed
      default:
        throw ArgumentError('Unsupported sound type for drag: $type');
    }
  }

  void _onPointerDown(PointerDownEvent event) {
    final now = DateTime.now();
    if (_lastPlayTime == null ||
        now.difference(_lastPlayTime!) > _minInterval) {
      _lastPlayTime = now;
      _lastPosition = event.position;

      // Play tap sound from track
      final tapSound =
          DragSoundTrackController.instance.getCurrentTapSound(widget.trackId);
      if (tapSound != null) {
        final path = _getSoundPath(tapSound, widget.tapType);
        playOneShot(path, volume: widget.volume);
      }
    }
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (!_isDragging) {
      _isDragging = true;
      return;
    }

    if (_lastPosition != null) {
      final now = DateTime.now();
      final deltaTime =
          now.difference(_lastPlayTime ?? now).inMilliseconds / 1000.0;
      if (deltaTime > 0) {
        final deltaPosition = event.position - _lastPosition!;
        final velocity = deltaPosition.distance / deltaTime;
        _lastVelocity = velocity;

        if (!_hasPlayedWhooshInCurrentDrag &&
            velocity > _minVelocityThreshold &&
            deltaPosition.distance > 5) {
          final volumeScale = math.min(
              (velocity - _minVelocityThreshold) /
                  (_maxVelocityThreshold - _minVelocityThreshold),
              1.0);
          final whooshVolume = 0.3 + (volumeScale * 0.4);

          if (velocity > 10) {
            // Play whoosh sound from track
            final whooshSound = DragSoundTrackController.instance
                .getCurrentWhooshSound(widget.trackId);
            if (whooshSound != null) {
              final path = _getSoundPath(whooshSound, widget.whooshType);
              playOneShot(path, volume: widget.volume * whooshVolume);
              _hasPlayedWhooshInCurrentDrag = true;
            }
          }
        }
      }
      _lastPosition = event.position;
      _lastPlayTime = now;
    }
  }

  void _onPointerUp(PointerUpEvent event) {
    if (_isDragging) {
      final dropVolume = math.min(_lastVelocity / _maxVelocityThreshold, 1.0);
      final clickVolume = 0.4 + (dropVolume * 0.3);

      // Play drop sound from track
      final dropSound =
          DragSoundTrackController.instance.getCurrentDropSound(widget.trackId);
      if (dropSound != null) {
        final path = _getSoundPath(dropSound, widget.dropType);
        playOneShot(path, volume: widget.volume * clickVolume);
      }
    }
    _isDragging = false;
    _lastPosition = null;
    _lastVelocity = 0;
    _hasPlayedWhooshInCurrentDrag = false;
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: _onPointerDown,
      onPointerMove: _onPointerMove,
      onPointerUp: _onPointerUp,
      child: widget.child,
    );
  }
}
