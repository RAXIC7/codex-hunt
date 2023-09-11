# 5M-CodeX Hunt Resource

**Version**: 1.0.0

![codex-hunt](https://github.com/5M-CodeX/codex-hunt/assets/112611821/2b69264b-dd33-48d6-a7cf-2c0155f5bfb6)


## Description

The 5M-CodeX Hunt resource brings the nostalgic thrill of classic deer hunting games to the world of FiveM. In this immersive hunting experience, players can venture into designated hunting zones, where they'll face the challenge of tracking and taking down animals, just like in the old Deer Hunter games. With a dynamic countdown timer, random animal spawns, and rewards for successful hunts, this resource offers an authentic hunting adventure within the FiveM universe. Whether you're a seasoned hunter or new to the sport, 5M-CodeX Hunt promises a captivating and rewarding hunting experience for all FiveM enthusiasts.

![derhunter](https://github.com/5M-CodeX/codex-hunt/assets/112611821/4d5a5c35-535d-4bc4-a1bb-51f5dbe93bc3)


## Features

- Start and end hunting events in predefined hunting zones.
- Display a countdown timer for ongoing hunts.
- Spawn a random number of animals (e.g., deer) in hunting zones.
- Track and reward players for killing animals during hunts.
- Cooldown duration between hunting events.
- Chat bubble notifications for hunting events and rewards.
- Integration with the ND_Core economy system (configurable).

## Installation

1. Ensure you have the `ND_Core` dependency installed. (optional)
2. Copy the `codex-hunt` folder to your FiveM server's `resources` directory.
3. Add `ensure codex-hunt` to your `server.cfg` file.

## Configuration

You can customize the behavior of the hunting system by editing the `config.lua` file located in the `5m-codex-hunt` resource folder. Adjust settings such as hunting zone locations, cooldown duration, and more.

```lua
Config = {}

Config.huntingZoneLocations = {
    { x = 1142.3, y = 111.49, z = 80.88 },
    { x = -763.73, y = 4184.92, z = 180.72 },
    -- Add more hunting zone locations as needed
}

Config.UseND = true -- Use ND_Core for economy (true) or specify an alternative action (false)
Config.minAnimals = 3
Config.maxAnimals = 10
Config.huntDuration = 6000 -- Duration of the hunting event in seconds (6000 seconds = 100 minutes)
Config.huntingZoneRadius = 150.0 -- Radius around hunting zones to trigger the event
Config.DefaultHuntingMessage = "There is currently no hunting event in progress."
Config.cooldownDuration = 600 -- Cooldown between hunting events in seconds (600 seconds = 10 minutes)
Config.HuntIconURL = 'https://i.imgur.com/YuxSbbl.png'
```

# Usage
Players can enter designated hunting zones to trigger hunting events.
A countdown timer will display when a hunting event is active.
Kill animals (e.g., deer) during the hunt to earn rewards.
Rewards are based on the number of animals killed and are given at the end of the hunt.

# Support
For support or issues related to this resource, please contact 5M-CodeX or TheStoicBear.
https://discord.gg/suZaFCf75Y
