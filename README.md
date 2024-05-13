# Eldritch Echoes

 ***Essentially:*** Groundhog Day meets a retro first-person shooter (FPS) game with a Lovecraftian Horror theme.

 Eldritch Echoes is my final year project for my degree and first major project as a solo developer!

**Game Controls:**

    - ‘WASD’ to move around.

    - ‘Mouse look’ to look around.

    - ‘Mouse 1’ (left-click) to attack.

    - ‘Space’ to jump and press it again while in the air to double jump.

    - ‘Ctrl’ to crouch. Hold it while moving to slide (this gives the player more speed). Hold it while in the air to gain more speed and control.

    - ‘E’ to talk to the townspeople (NPCs). While talking, press ‘Mouse 2’ (right-click) to go to the following dialogue or skip it.

    - ‘Esc’ to open the settings menu and pause the game.


 **Main Pillars of the Game:**

    - Retro FPS (games like Quake, DOOM, DUSK).
    - Environmental Storytelling.
    - Lovecraftian Horror.
    - All developed in the Godot Game Engine (v4.2).

 **Main Premise:**

    - Wake up in town.
    - Get a grasp of what is going on.
    - Sent out to face your trial.
    - Fight enemies.
    - Die eventually.
    - Wake up in town.
    - Corruption is taking over. The weather and people change, natures starts dying, the terrain becomes rougher and crumbles to sand, people go missing, and more.
    - The cycle repeats.

 **Goals:**

    - Create a narrative linked to the game’s environment. The player's death has a lasting impact, meaningfully altering the world and its inhabitants. 
    - Emphasis on the technical implementation within the Godot game engine, developing a system that enables the game environment and its narrative components to adapt dynamically in response to player death.
    - Game maintains the feel of a classic retro FPS, preserving the aesthetic and gameplay characteristics of the genre, fast, fluid, and visually reminiscent of the genre’s classics all while integrating modern narrative techniques. 
    - Weave in the essence of Lovecraftian horror, utilising its themes to cultivate an atmosphere filled with cosmic dread and mystery, enriching the storytelling and enhancing the overall experience for the player.

***Research Question:*** “To what extent is it possible to implement environmental storytelling in a retro first-person shooter game in Godot?”.

 **Outcomes:**

    - 9 levels total (town and battlefield) with multiple environmental adaptations for each after the player dies.
    - An arsenal of 5 possible weapons to use.
    - Fast-paced movement with a double jump and slide mechanics.
    - 3 enemy types, along with changes to each at every level, such as strength, speed, and size.
    - 19 NPCs to interact with and witness changes in their behaviour at every level.
    - 70+ lines of dialogue.
    - A Lovecraftian horror tone that rings throughout the game.
    - 2 endings that happen depending on player skill in the final level. 

 **Insights & Learnings:**

    - Diversity in enemy design and responsive weapon mechanics were crucial for enriching combat dynamics, offering varied encounters and satisfying player interactions.
    - Environmental storytelling through progressive-level corruption, atmospheric effects, and NPC dialogue effectively conveyed the narrative depth and escalating tension.
    - Strategic asset management, including modular assets and dynamic loading techniques, was vital for balancing visual richness and optimal game performance.
    - A systematic asset tagging and organization approach facilitated smooth transitions between development phases and ensured assets were easily identifiable and accessible.
    - The cyclical game structure, leveraging repeating levels with increasing corruption, built anticipation and highlighted the game's central themes, making every iteration meaningful and engaging.

 **Known Issues (ran out of time to fix/implement):**

    - Only 4 enemies can be spawned at once because of performance problem, more enemies would be way better.
    - Big FPS issues on final level, especially when on an elevated surface with enemies chasing you.
    - NPCs with no idle animations or hurt/death state.
    - Game does not get more difficult after recieving a new weapon/surviving the time limit.
