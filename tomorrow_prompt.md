# ShapeWar - Progress & Architecture Hand-off

This document summarizes all the major systems, gameplay mechanics, and architecture we have built so far, to serve as a prompt/context for tomorrow's work. It also contains the list of newly proposed 1* and 2* powerups to build next.

## 1. Code Architecture & Core Systems

### Player Ships (`character_body_2d.gd`, `rocket.gd`, `roocket0.gd`)
- **Multiple Ship Variants:** We support several player ship designs (Classic, V-Double, Single Heavy, etc.). Each ship variant uses its own specific movement/weapon script, but they share core powerup application methods to ensure feature parity.
- **Movement & Rotation:** Ships track mouse movement (`mouse_velocity.angle()`) or joystick inputs to determine rotation. `move_and_slide()` handles physics.
- **Weapon Hardpoints:** 
  - `%shotting_point` and `%shotting_point2`: Used by base weapons to fire bullets.
  - `%death_ray_point`: A dedicated `Marker2D` added to all 7 ship variants at exactly `(0, -35)` with `-1.5708` rotation. This completely decouples specialized powerups (like the Death Beam) from the standard weapon hardpoints, ensuring they always fire perfectly straight out of the ship's nose.

### Powerup Drop System (`powerup.gd`)
- Enemies have a random chance to drop powerups upon death (e.g., `powerup_drop_chance`).
- The `powerup.tscn` handles floating around and interacting with the player. 
- It uses a custom icon for each powerup type, loaded dynamically from the `SPRITE/powerups/` folder.
- Powerup logic is triggered by passing an integer `type` (0-4) to the player ship when collected.

### Current Powerups (Implemented)
- **[Type 0] Health:** Restores the player's health.
- **[Type 1] Speed Boost:** Increases movement speed for 5 seconds.
- **[Type 2] Rapid Fire 360:** Instantiates 16 bullets in a circular burst `(TAU / num_bullets)` every 0.15 seconds for 2 seconds.
- **[Type 3] Death Beam:** Attaches a massive 2000-pixel `Area2D` laser to the `%death_ray_point`. It charges up visually using tweens, enables collision, and ticks damage every 0.1s using a `DamageTimer` for 3 seconds.
- **[Type 4] Shield Aura (`shield_powerup_aura.gd`):** A dual-zone forcefield.
  - **Inner Zone (100px):** Any non-boss enemy that touches this area is instantly killed.
  - **Outer Zone (250px):** Acts as a solid, bouncy wall. When enemies touch this boundary, they are instantly bounced away 600 pixels using a high-speed `Tween` (easing out), creating a satisfying knockback effect without glitching through the shield.

### Enemy Architecture
- **Groups:** Enemies are categorized via groups (`enemy1`, `enemy2`, `enemy5`, etc.).
- **Damage Model:** `take_damage()` and `kill()` methods are used. When enemies die, they spawn particle explosions and handle their own powerup drop probabilities.

---

## 2. Future Development: Proposed Powerups

Below are the brainstormed ideas for future 1* (Common) and 2* (Rare) powerup drops to implement next.

### ⭐ 1-Star Powerups (Drops from common enemies)
1. **Spread Shot / Triple Shot**: Temporarily changes the main guns to shoot 3 or 5 bullets in a wide arc instead of straight forward.
2. **Magnetic Pull (Magnet)**: Instantly pulls all uncollected powerups scattered across the entire map directly to the player.
3. **EMP Flash**: A quick burst that instantly destroys all enemy bullets/projectiles currently on the screen.
4. **Homing Missiles**: Instantly spawns a swarm of 4-6 small missiles that automatically lock onto and blow up the nearest enemies.

### ⭐⭐ 2-Star Powerups (Drops from tough enemies like Enemy 2 & 5)
1. **Chain Lightning**: Shoots a massive bolt of electricity from the ship that bounces between 10+ enemies, chaining through crowds.
2. **Gravity Bomb (Black Hole)**: Drops a localized mini black hole at the player's position. It sucks all nearby enemies into the center, clumping them up and crushing them.
3. **Time Dilation (Slow Motion)**: Slows down time for all enemies and their projectiles by 80% for 5 seconds, while the player moves at normal speed.
4. **Orbital Drones**: Spawns two small drone ships that orbit around the spaceship for 10 seconds, automatically firing at enemies.
5. **Supernova (Screen Clear)**: A massive, blinding explosion that wipes out every non-boss enemy currently visible on the screen.
6. **Piercing Beam Upgrade**: An upgrade to the Death Beam that allows it to pierce and hit every single enemy in its path without stopping (similar to enemy 3's beam).

### ⭐⭐⭐ 3-Star Powerups (Ultra-Rare drops from Bosses or Black Holes)
1. **Mothership / Dreadnought Form:** The player's ship temporarily transforms into a massive, invincible dreadnought for 10 seconds. It fires a barrage of lasers in all directions and can literally ram enemies to instantly destroy them.
2. **Time Stop (The World):** Instantly stops time completely for everything on the screen (all enemies, all projectiles freeze in place) for 7 seconds. The player is free to fly around, dodge, and shoot frozen enemies. Once time resumes, all damage dealt is applied at once.
3. **Starstorm / Meteor Strike:** Summons a massive shower of huge meteors or orbital strikes that rain down across the entire screen for several seconds, completely obliterating everything they touch.
4. **Clone Armada:** Spawns 4 exact hologram clones of the player's ship that fly in a diamond formation alongside the player. Whenever the player shoots, all 4 clones shoot the exact same weapon, quintupling firepower.
5. **Warp Drive (Teleport & Destruct):** Grants the player the ability to instantly teleport to the mouse cursor 3 times. Whenever the player teleports, a massive shockwave explosion happens at both the start and end locations, wiping out all nearby enemies.

*(Note: We still need to finalize the "huge beam" request for Enemy 2 and the "piercing" behavior for the Death Beam mentioned previously).*
