# Color Twist: A Flutter Flame Engine Game

A fast-paced, color-matching challenge where players navigate obstacles by switching colors.

Tap to jump. Collect stars. Match your ball color to pass through rotating arcs.

## Requirements

- [FVM](https://fvm.app/) (Flutter Version Management)
- Android device or emulator for mobile builds

## Setup

```bash
# Install the pinned Flutter SDK (3.44.4)
fvm install

# Get dependencies
fvm flutter pub get
```

## Run

```bash
# List connected devices
fvm flutter devices

# Run on a connected Android device
fvm flutter run -d <device-id>

# Example: macOS desktop
fvm flutter run -d macos
```

## Project Structure

```
lib/
  main.dart              — app entry
  app/                   — MaterialApp shell
  core/                  — constants, theme
  services/              — audio_service
  features/
    home/                — menu screen
    gameplay/
      models/            — level + config models
      data/              — level definitions + LevelLoader
      presentation/      — GameCubit, screens, overlay widgets
      game/              — TwistColorGame + Flame components
assets/                  — images and audio
```

## Analyze

```bash
fvm flutter analyze
```
