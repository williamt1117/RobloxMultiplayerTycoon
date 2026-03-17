# Roblox Multiplayer Tycoon

A multiplayer Roblox tycoon/incremental game built with an economy system, modular upgrade framework, and event-driven gameplay. Players can earn resources through upgradable fountains, unlock cosmetic skins, participate in world events, and compete for a spot on the global leaderboard.

## Getting Started

The game is most easily accessible by the official game link [here](https://www.roblox.com/games/75674563355265/Fortune-Fountain-Simulator). The following steps will be instructions for if you want to open the project in Roblox Studio to see the inner workings.

### Dependencies

* Roblox Studio
* A Roblox account

### Installing + Executing

* Download `FortuneFountainSimulator.rbxl` directly or clone repository to get file.
* Open the project in Roblox Studio
* Press **Play** or **Start Server** to simulate multiplayer clients
* Interact with the tycoon systems to test gameplay, upgrades, and events.

## Description

This project implements a multiplayer tycoon system in Roblox designed with modular gameplay systems and server-authoritative logic.

Notable key systems are:

* **Economy System**  
  Players generate coins through upgradable fountains. Upgrade costs scale dynamically and currency types upgrade as fountain upgrades.

* **Upgrade Framework**  
  Upgrades are defined through configuration modules, allowing new upgrades to be added without modifying core logic.

* **Player Data System**  
  Player progression persists across instances and is tracked through structured data modules.

* **Global Coin Rain Event**  
  Global server events introduce gameplay variation and encourage interaction between players.

* **Boost Gems**
  Fountains will occasionally spawn temporary fountain boosts that provide short-term engagement.

* **Cosmetic Skins**  
  Players can purchase fountain skins with in-game currency as another means to display their progression to other players.

* **Multiplayer Architecture**  
  Client and server responsibilities are separated using standard Roblox networking principles to maintain a stable client-server architecture.

## Future Work

* Implement a prestige / rebirth system for long-term progression
* Expand global leaderboard functionality to allow players to see multiple pages of the leaderboard
* Introduce cooperative multiplayer interaction like a coin or skin gifting system
* Expand world events to create dynamic gameplay moments
