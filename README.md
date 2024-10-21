# GameMaker Studio Utilities
A set of utility scripts for GameMaker Studio users, by Raechel V.

*Though the scripts are free to use and copy under the Unlicense license, credit is appreciated.*

### Scripts
**Utilities:**
- `_various.gml` contains any minor utility function that didn't fit in any other category.
- `CurveUtils.gml` contains helper functions for interpolation and other related things.
- `RandomUtils.gml` contains functions to help with random/procedural number generation, including smooth 2D noise based on Gamemaker's default random generator and an implementation of a Linear Congruential Generator (with many default configurations).
- `VKUtils.gml` contains helper functions to deal with vk_* constants and other keyboard constants (currently only one function)

**Objective Ports:** 
- `EventSystem.gml` includes a simple Event Listener system useable with just two functions, and supporting event priorities.
- `ObjectiveAlarms.gml` implements Gamemaker's new TimeSource system as a struct/object that can be instantiated.
- `ObjectiveLists.gml` creates a form of instantiable linked List in the form of a struct/object.
- `Vec2.gml` offers a simple implementation of basic 2D Vector functions in an instantiable struct/object form.
- `StateMachine.gml` implements a quick and simple Finite State Machine system.

### Post Scriptum
I've been a Gamemaker user for over a decade now. I've started back in the 8.0 days, and have embarked in countless projects across the years. While I haven't published a lot of games, or even finished many, I've collected a lot of little scripts and utilities across the years that I often find myself rewriting on the fly on new projects, because I'll be honest, I'm not the most organized when it comes to my home projects: finding whichever the latest version of a utility script is, out of my 12 concurrent projects, is a daunting task my own hubris caused.

So, I make this repository as a way to store my utilities in one place, but also to share it with the world. Anyone who may need similar functions or implementations is free to use them as they please. Just be careful, despite 13 years of experience I am still unsure of my skills, especially since some of these scripts have been ported between multiple versions of Gamemaker, so some stuff in here might be outdated or poorly optimized, or have outdated JSDocs.

I hope these can be as helpful to you as they are to me :)
