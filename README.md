# Nightwatcher

A solo game development project by jedzeb

## Project Status

This game is a work in progress. The current focus is designing and implementing core systems

## Key Systems
- Interaction system for tile-based and entity-based interactions
- Use of custom Godot resources for data configuration such as items and crops
- Procedural world generation using noise
- Custom data structures such as inventory and a map with references to all objects on the map
- Efficient world storage using chunk saving by storing objects using primitive variables
- Efficient game process using chunk loading by loading complex objects from primitive variables using enums

## Structure
- 'Scenes/' - Godot scenes defining structure
- 'Scripts/' - Godot scripts defining logic and systems
- 'assets/' - Art
- 'resources/' - Reusable data configured assets
- 'shaders/' - Custom shaders for visual effects

## Tools/Tech Stack
- Engine: Godot 4.4
- Languages: GDScript, GDShader

## Notes
This repository is meant to showcase my engineering approach rather than a finished product. 