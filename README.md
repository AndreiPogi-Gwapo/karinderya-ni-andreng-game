# karinderya-ni-andreng-game

A compact but playable Godot 4 prototype for the narrative entrepreneurship game "Karinderya ni Andreng".

## Features included
- Main menu with title, sign-in flow, and play flow
- Save/load profile system using local JSON
- Story scenes with branching dialogue and consequences
- Business and money tracking
- Achievement unlocks
- Local leaderboard and point-to-key rewards
- Simple timer and day progression
- Secret cutscene unlock flow

## Running the project
1. Open the folder in Godot 4.x.
2. Import the project and let Godot generate the .godot files.
3. Press F5 to run the scene.

## Notes
- The project is intentionally designed as a solid prototype that can be expanded into a full production game.
- SQLite is not required for the prototype; the save system uses a local JSON database designed to be replaced later with SQLite or a remote backend.
- Audio and pixel-art assets are placeholders so the project runs without missing-resource crashes.

## Controls
- Mouse: navigate buttons
- Space/Enter: continue dialogue
- Escape: pause menu (when implemented in expanded scenes)
- Number keys 1-3: select choices when available

## Export to Windows
- In Godot, open Project > Export.
- Add a Windows Desktop preset.
- Set the executable name.
- Export the project to a folder.

## Testing
Use Godot's built-in script editor or command-line tools for validation if available:
- `godot --headless --quit`
- `godot --headless --path . --script tests/test_finance.gd`
