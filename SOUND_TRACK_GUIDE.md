# Sound Track Management Guide

This guide explains how to use the new sound track management features in Studyo Music Library.

## Features

### 1. List Sound Support
You can now use a list of sounds instead of a single sound:

```dart
// Single sound (original behavior)
widget.addSound(SoundTAP.tap, SoundType.tap)

// List of sounds with track management
widget.addSound([
  SoundTAP.tap,
  SoundTAP.deepbutton,
  SoundTAP.bubble,
  SoundTAP.water,
], SoundType.tap, trackId: 'my_track')
```

### 2. Automatic Track Management
The system automatically manages sound tracks:
- Saves current track position
- Advances to next sound when leaving a page
- Loops back to first sound after the last one
- Persists track position across app sessions

### 3. Synchronized Sounds
All widgets using the same `trackId` will play the same sound from the track.

## Usage Example

### Step 1: Define Your Sound Track
```dart
class PageB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const trackId = 'page_b_containers';
    final soundList = [
      SoundTAP.tap,
      SoundTAP.deepbutton,
      SoundTAP.bubble,
      SoundTAP.water,
    ];
    
    // Your widget implementation...
  }
}
```

### Step 2: Apply Sound Track to Widgets
```dart
// All these containers will play the same sound from the track
Container(
  // container properties...
).addSound(soundList, SoundType.tap, trackId: trackId),

Container(
  // container properties...
).addSound(soundList, SoundType.tap, trackId: trackId),

// More containers with the same trackId...
```

### Step 3: Enable Automatic Track Advancement
```dart
return Scaffold(
  // your page content...
).withSoundTrack(trackId); // This enables automatic track advancement
```

## How It Works

1. **Track Registration**: When you use `addSound()` with a list and trackId, the system registers the track
2. **Current Sound**: All widgets with the same trackId play the current sound from the track
3. **Track Advancement**: When the page is disposed (user leaves), the track automatically advances to the next sound
4. **Persistence**: Track positions are saved using SharedPreferences and restored when the app restarts

## API Reference

### SoundTrackController

```dart
// Set a sound track
SoundTrackController.instance.setSoundTrack(trackId, sounds, type);

// Get current sound from track
final currentSound = SoundTrackController.instance.getCurrentSound(trackId);

// Manually advance track
await SoundTrackController.instance.nextTrack(trackId);

// Reset track to first sound
await SoundTrackController.instance.resetTrack(trackId);
```

### Widget Extensions

```dart
// Add sound with track support
widget.addSound(soundList, SoundType.tap, trackId: 'my_track')

// Enable automatic track management
widget.withSoundTrack('my_track')
```

## Best Practices

1. **Unique Track IDs**: Use descriptive and unique track IDs (e.g., 'page_b_containers', 'menu_buttons')
2. **Consistent Sound Lists**: Use the same sound list for all widgets sharing a track
3. **Page-Level Tracks**: Apply `.withSoundTrack()` at the page level (Scaffold) for automatic management
4. **Sound Type Consistency**: All sounds in a track should be of the same SoundType

## Migration from Single Sounds

To migrate existing single sound usage to track management:

**Before:**
```dart
widget.addSound(SoundTAP.tap, SoundType.tap)
```

**After:**
```dart
widget.addSound([
  SoundTAP.tap,
  SoundTAP.deepbutton,
  SoundTAP.bubble,
], SoundType.tap, trackId: 'my_track')
```

The original single sound API remains fully supported for backward compatibility.