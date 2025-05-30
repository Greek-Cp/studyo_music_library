# Studyo Music Library

A comprehensive Flutter sound management library with BGM (Background Music), SFX (Sound Effects), and audio ducking capabilities.

## Features

- 🎵 **Background Music Management**: Stack-based BGM system with cross-fade transitions
- 🔊 **Sound Effects**: One-shot sound effects with priority queuing
- 🎚️ **Audio Ducking**: Automatic BGM volume reduction during SFX playback
- 🎮 **Widget Extensions**: Easy-to-use widget extensions for adding sounds
- 📱 **Navigation Aware**: Automatic pause/resume on navigation
- 🔄 **Global BGM**: Support for global background music across the app
- 📦 **Asset Management**: Built-in sound assets - no manual asset setup required

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  studyo_music_library: ^0.1.0
```

Then run:

```bash
flutter pub get
```

## Quick Start

### 1. Initialize the Sound System

```dart
import 'package:studyo_music_library/studyo_music_library.dart';
import 'package:flame_audio/flame_audio.dart';

Future<void> initSoundSystem() async {
  // Initialize the sound system for library usage
  FlameAudio.audioCache.prefix = 'packages/studyo_music_library/assets/';
  
  // Preload all sounds
  await BgmManager.instance.preloadAll();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSoundSystem();
  runApp(MyApp());
}
```

### 2. Add Route Observer (Optional)

For navigation-aware BGM management:

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver], // Add this line
      home: MyHomePage(),
    );
  }
}
```

### 3. Add Sounds to Widgets

#### Tap Sounds
```dart
Container(
  child: Text('Tap me!'),
).addSound(TAPSound.tap, SoundType.tap)
```

#### Drag Sounds
```dart
Draggable(
  child: Container(
    child: Text('Drag me!'),
  ),
).addSound(TAPSound.tap, SoundType.tap, isDragWidget: true)
```

#### Background Music
```dart
// For a single page
Scaffold(
  body: YourPageContent(),
).addBGM(BackgroundSound.journal)

// For global BGM across multiple pages
Scaffold(
  body: YourPageContent(),
).addBGMGlobal([
  BackgroundSound.balance,
  BackgroundSound.bonus,
  BackgroundSound.journal,
])
```

## Available Sound Types

### Background Sounds
- `BackgroundSound.journal`
- `BackgroundSound.bonus`
- `BackgroundSound.balance`
- `BackgroundSound.teamup`
- `BackgroundSound.bubbles`
- `BackgroundSound.tetris`
- And more...

### Sound Effects
- `TAPSound.tap` - Tap/click sounds
- `CoinsSound.coin1` - Coin collection sounds
- `SuccessSound.winning` - Success/achievement sounds
- `WhooshSound.longwhoosh` - Movement/transition sounds
- `ReviewSound.happy` - Feedback sounds
- And many more categories...

## Advanced Usage

### Manual BGM Control

```dart
// Play specific BGM
BgmManager.instance.push(BackgroundSound.journal);

// Stop current BGM
BgmManager.instance.pop(BackgroundSound.journal);

// Set volume
BgmManager.instance.setBaseVolume(0.8);

// Pause/Resume
BgmManager.instance.pause();
BgmManager.instance.resume();
```

### Manual SFX Playbook

```dart
// Play one-shot sound effect
SoundQueue.instance.play(
  SoundPaths.instance.tapSoundPaths[TAPSound.tap]!,
  volume: 0.8,
  type: SoundType.tap,
);
```

## Example

Check out the `/example` folder for a complete working example that demonstrates all features.

## License

This project is licensed under the MIT License.
