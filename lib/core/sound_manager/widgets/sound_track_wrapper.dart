import 'package:flutter/material.dart';
import 'package:studyo_music_library/core/sound_manager/core/sound_controller.dart';

/// Widget wrapper that automatically manages sound track lifecycle
///
/// This wrapper will automatically advance to the next sound in the track
/// when the widget is disposed (e.g., when leaving a page)
class SoundTrackWrapper extends StatefulWidget {
  final Widget child;
  final String trackId;

  const SoundTrackWrapper({
    super.key,
    required this.child,
    required this.trackId,
  });

  @override
  State<SoundTrackWrapper> createState() => _SoundTrackWrapperState();
}

class _SoundTrackWrapperState extends State<SoundTrackWrapper> {
  @override
  void dispose() {
    // Advance to next track when leaving the page
    SoundTrackController.instance.nextTrack(widget.trackId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// Extension to easily wrap widgets with sound track management
extension SoundTrackExtension on Widget {
  /// Wrap widget with automatic sound track management
  ///
  /// This will automatically advance the sound track when the widget is disposed
  ///
  /// Example:
  /// ```dart
  /// Scaffold(
  ///   // your page content
  /// ).withSoundTrack('page_b_track')
  /// ```
  Widget withSoundTrack(String trackId) {
    return SoundTrackWrapper(
      trackId: trackId,
      child: this,
    );
  }
}
