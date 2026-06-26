# Color Twist — Project Context for AI Assistance

You are helping me improve **Color Twist**, a mobile game built with **Flutter + Flame**. Please respect the architecture rules below when suggesting code changes.

---

## 1. What the app is

**Color Twist** is a fast-paced, vertical color-matching arcade game (similar in spirit to Color Switch).

**Gameplay:**

- Player controls a ball that auto-falls with gravity
- **Tap anywhere** to jump upward
- Ball starts **white** until it hits a **ColorSwitcher** (random color from palette)
- **CircleRotator** obstacles are spinning color arcs — pass through only when ball color matches the arc segment; wrong color = game over
- **StarComponent** collectibles increase score (+1 each, with particle effect + sound)
- Camera follows player **upward only** (fixed resolution 600×1000)
- Pause blurs game + pauses BGM; game over clears world and shows overlay

**Repo:** https://github.com/FluttX/color_twist

---

## 2. Tech stack

| Tool | Version / package |
|------|-------------------|
| Flutter (via FVM) | **3.44.4** (see `.fvmrc`) |
| Dart SDK | `>=3.10.0 <4.0.0` |
| Flame | `^1.37.0` |
| flame_audio | `^2.12.1` |
| flutter_bloc | `^9.1.1` |
| equatable | `^2.0.7` |

**Commands (always use FVM):**

```bash
fvm install
fvm flutter pub get
fvm flutter analyze
fvm flutter run -d <device-id>
```

**Platforms:** iOS, Android, macOS, web (tested on iOS simulator)

---

## 3. Architecture (IMPORTANT — follow these rules)

The project uses **feature-first clean architecture** with strict layer boundaries:

### Layer rules

1. **Flame game layer** (`lib/features/gameplay/game/`) — physics, collisions, rendering, level spawning. **Never import flutter_bloc here.**
2. **Flutter presentation layer** (`lib/features/*/presentation/`) — HUD, overlays, navigation. **Never put game logic in widgets.**
3. **GameCubit** bridges Flame ↔ Flutter — owns `TwistColorGame`, exposes `GameState` (status + score).
4. **Do NOT use ValueNotifier in TwistColorGame** — use constructor callbacks: `onScoreChanged`, `onGameOver`.

### Folder structure

```
lib/
  main.dart                          # runApp only
  app/app.dart                       # MaterialApp shell
  core/
    constants/game_constants.dart    # camera, gravity, jump, colors
    constants/asset_paths.dart       # asset file names
    theme/app_theme.dart
  services/audio_service.dart        # FlameAudio wrapper
  features/
    home/presentation/screens/       # HomeScreen (title + Play button)
    gameplay/
      models/                        # GameConfig, GameStatus, LevelDefinition, LevelObject
      data/
        levels/default_level.dart    # current level layout as data
        level_loader.dart            # spawns Flame components from level data
      presentation/
        cubit/game_cubit.dart        # GameCubit + GameState
        screens/gameplay_screen.dart
        widgets/                     # GameHud, PauseOverlay, GameOverOverlay
      game/
        twist_color_game.dart        # TwistColorGame (FlameGame core)
        components/                  # Player, Ground, CircleRotator, ColorSwitcher, StarComponent
assets/
  images/   # star_icon.png, finger_tap.png
  audio/    # background.mp3, collect.wav
```

### State management

- `GameCubit` + `GameState` (Equatable)
- `GameStatus`: `playing` | `paused` | `gameOver`
- Cubit methods: `pause()`, `resume()`, `playAgain()`
- `TwistColorGame` notifies cubit via callbacks (no bloc import in game layer)

### Conventions

- Use `package:color_twist/...` imports consistently
- Game colors from `GameConfig.gameColors` — don't hardcode in components
- New features go under `lib/features/<feature_name>/`
- Keep widgets small; game logic stays in Flame components
- Assets declared in `pubspec.yaml`; paths centralized in `AssetPaths`

---

## 4. Key classes & data flow

```
HomeScreen → [Play] → GameplayScreen
                          ↓
                    BlocProvider<GameCubit>
                          ↓
              GameWidget(TwistColorGame) + overlays
                          ↓
         GameCubit ←callbacks→ TwistColorGame
                          ↓
              LevelLoader → Flame components
```

### TwistColorGame (`features/gameplay/game/twist_color_game.dart`)

- Mixins: `TapCallbacks`, `HasCollisionDetection`, `HasDecorator`, `HasTimeScale`
- Owns: player, ground, score (internal), pause via `timeScale`
- Fixed camera 600×1000
- `gameOver()` stops audio, removes all world children, calls `onGameOver()`
- `playAgain()` re-runs `_initializeGame()`

### Player (`components/player.dart`)

- Gravity + jump physics (`GameConfig.gravity`, `GameConfig.jumpSpeed`)
- Ground collision via `game.ground` reference (not string key lookup)
- Collision handling:
  - `ColorSwitcher` → random color, remove switcher
  - `CircleArc` (wrong color) → `game.gameOver()`
  - `StarComponent` → collect effect, score++, collect sound

### Flame components

| Component | Role |
|-----------|------|
| `Ground` | Platform at spawn; shows finger-tap tutorial sprite |
| `ColorSwitcher` | Pie-chart color wheel; passive hitbox |
| `CircleRotator` | Spawns one `CircleArc` per game color + infinite rotation |
| `CircleArc` | Arc segment with polygon hitbox |
| `StarComponent` | Collectible with sprite + particle burst on collect |

### Level system

- `LevelDefinition` + `LevelObject` (type, positionX/Y, optional size)
- `default_level.dart` — single hardcoded level (7 objects)
- `LevelLoader.loadInto(world, level)` spawns components

### Game constants

- Camera: 600 × 1000
- Gravity: 980, Jump: 350
- Colors: redAccent, greenAccent, blueAccent, yellowAccent

---

## 5. Current screens & UI

1. **HomeScreen** — "Color Twist" title + Play button → navigates to GameplayScreen
2. **GameplayScreen** — Stack of:
   - `GameWidget` (Flame canvas)
   - `GameHud` (pause button + score) when playing
   - `PauseOverlay` when paused
   - `GameOverOverlay` when game over (score + play again)

---

## 6. What is implemented vs planned

### Implemented

- Core gameplay loop (jump, color switch, obstacles, stars, score)
- Pause / resume / game over / play again
- BGM + collect SFX via AudioService
- Feature-first folder structure
- LevelDefinition + LevelLoader (one default level)
- Home menu screen
- GameCubit state bridge

### Not yet implemented (planned)

- Multiple levels / level select screen
- JSON level files (loader already accepts `LevelDefinition`)
- Difficulty settings (extend `GameConfig`: rotation speed, obstacle density)
- Player profile + high scores (`shared_preferences`, `features/profile/`)
- Routing package (`go_router`) — currently `Navigator.push`
- Dependency injection (`get_it`) — currently `BlocProvider` only
- Unit/widget tests (test stub is empty)
- Collision registry (all collision logic still in `Player.onCollision`)

### Known quirks / improvement opportunities

- Player starts **white** — can die on first arc before hitting a ColorSwitcher
- Camera only tracks upward (no downward follow)
- `gameOver()` removes entire world bluntly; `playAgain()` full re-init
- Collision logic centralized in Player — new entity types require editing Player
- Only one level exists
- Home screen is minimal (no settings, no high score)

---

## 7. How I want you to help

When I ask for improvements, please:

1. **Respect layer boundaries** — don't put game logic in Flutter widgets or bloc in Flame components
2. **Suggest file paths** under the existing `features/` structure
3. **Keep changes scoped** — small, focused diffs preferred
4. **Use FVM commands** (`fvm flutter`, not bare `flutter`)
5. **Match existing patterns**: `HasGameReference<TwistColorGame>`, `GameCubit` bridge, `LevelLoader` for spawns
6. Provide **complete code snippets** with correct import paths (`package:color_twist/...`)
7. If adding a new feature (e.g. level select, profile), show where it fits in the folder tree

---

## 8. Example prompts I may ask you

- "Add a level select screen with 3 levels"
- "Fix the white-ball death before first color switcher"
- "Add difficulty settings (easy/medium/hard)"
- "Save high score with shared_preferences"
- "Refactor Player collisions into a collision registry"
- "Add procedural infinite level generation"
- "Improve home screen UI with animations"
- "Add haptic feedback on jump and collect"

---

## 9. My current question

[Paste your specific question or feature request here]
