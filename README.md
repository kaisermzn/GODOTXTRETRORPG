# GODOTXTRETRORPG

# Retro Text RPG Project

A personal, humble and little proyect about **retro‐style text RPG** built in **Godot Engine 4.4.1 (Mono)**, inspired by classic console interfaces.

---

## 🎯 Objectives

- **Console‐Style UI**  
  - Full-screen black background.  
  - Green, monospaced text with adjustable line spacing.  
  - Auto-scrolling `RichTextLabel` for game output.  
  - `LineEdit` + ASCII cursor `_` that blinks and follows the input.  
  - “Typewriter” effect: responses appear character by character.

- **Welcome ASCII Art**  
  - Loaded from `res://ascii/welcome.txt` (or embedded).  
  - Displayed on startup before any command.

- **Command Menu & Flow**  
  - Console-only main menu (New Game, Load Game, Quit).  
  - Parser supporting commands like `look`, `go north`, `inventory`, `use [item]`.  
  - Clean state management (“MENU” vs “PLAYING”).

- **Game State & Logic Layers**  
  - **GameState** singleton (AutoLoad) holds global variables (`current_room`, `inventory`, `flags`).  
  - **CommandParser** maps input strings to callable methods.  
  - **GameManager** orchestrates UI ↔ Parser ↔ State via signals.  
  - **GameUI** layer handles presentation: history, scrolling, typewriter, cursor.

- **Persistence & Extras**  
  - Save/Load using `ConfigFile` or JSON.  
  - Basic inventory system with `Item` classes.  
  - Event triggers on room entry (show ASCII, descriptions).  
  - Retro sound effects (letter blips, command confirms).  
  - Optional CRT shaders (scanlines, distortion) via `ShaderMaterial`.
