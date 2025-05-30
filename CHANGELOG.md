# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2024-01-01

### Added
- Initial release of Studyo Music Library
- Background Music (BGM) management system with stack-based approach
- Sound Effects (SFX) system with priority queuing
- Audio ducking functionality (automatic BGM volume reduction during SFX)
- Widget extensions for easy sound integration:
  - `addSound()` for tap sounds
  - `addBGM()` for page-specific background music
  - `addBGMGlobal()` for global background music playlists
- Navigation-aware BGM management with automatic pause/resume
- Built-in sound assets covering multiple categories:
  - Background sounds
  - UI interaction sounds (tap, click)
  - Game sounds (coins, success, transitions)
  - Pet interaction sounds
  - Notification and feedback sounds
- Sound categories and enums for type-safe sound management
- Cross-fade transitions between background music tracks
- Persistent global BGM state with SharedPreferences
- Support for drag and drop sound feedback
- Comprehensive example app demonstrating all features
- Complete documentation and README

### Features
- **BgmManager**: Core background music management
- **SoundQueue**: Priority-based sound effect queuing
- **SoundPaths**: Centralized sound asset path management
- **Sound Extensions**: Widget extensions for easy integration
- **Route Observer**: Navigation-aware sound management
- **Sound Utils**: Utility functions for sound playback
- **Wrapper Widgets**: Specialized widgets for sound integration

### Dependencies
- flame_audio: ^2.10.7
- shared_preferences: ^2.3.1
- audioplayers: ^6.0.0
- collection: ^1.18.0

### Package Structure
- Proper Flutter package structure with library exports
- Example app in `/example` directory
- Built-in assets that don't require manual setup
- Package-aware asset paths for proper library usage