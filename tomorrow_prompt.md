# Tomorrow's Task: Deep Space Background Shader

## Project Context for the Agent
- **Game Name**: ShapeWar (2D top-down space shooter).
- **Current State**: We have a working main scene (`main.tscn`), player spaceships (like `spaceship_v_double.tscn`), enemy spawners with path-following boss enemies (`enemy_3` using `enemy_paths.tscn`), and a retro arcade visual style.
- **Goal**: The background is currently plain. We need to implement a rich, dynamic deep-space background.

## 1. Image Generator Prompt (Action: Run this once cooldown expires)
**Prompt to use:** 
> "A dark space background for a 2D sci-fi video game, with tiny glowing stars, distant colorful nebulas, and small stylized planets floating slowly in the void. Rich dark blue and purple tones, deep space vibe, high quality game art style."

## 2. Implementation Plan for the Background
When we are ready to implement this in Godot, here is the technical plan:

1. **Create the Background Node**: Add a `ColorRect` to a `ParallaxBackground` or `CanvasLayer` in the `main.tscn` (ensuring its `z_index` keeps it behind all game elements).
2. **Build the Godot Shader**: 
   - **Nebula Layer**: Use layered noise textures (e.g., FastNoiseLite) with a slow time-based pan to create a shifting cosmic cloud effect in dark purples and blues.
   - **Starfield Layer**: Procedurally generate tiny twinkling stars using UV coordinates, moving at different parallax speeds to simulate 3D depth.
   - **Floating Objects Layer**: Optional texture overlays for small distant planets/asteroids that drift across the screen.
3. **Expose Parameters**: Export variables (uniforms) in the shader so the star density, nebula color, and drift speed can be easily tweaked in the Godot inspector.

*Hey Agent! If the user just uploaded this file, read the context above and ask if you should start by generating the concept art (if cooldown is over) or jumping straight into the shader code!*
