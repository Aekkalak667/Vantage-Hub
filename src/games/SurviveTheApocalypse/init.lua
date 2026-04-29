-- Module for Survive the Apocalypse metadata and UI integration
local Logic = require(script:WaitForChild("Logic"))

local GameModule = {
    Name = "Survive the Apocalypse",
    Scripts = {
        {
            Title = "Kill Aura",
            Description = "Automatically attacks nearby zombies.",
            Type = "Toggle",
            Callback = Logic.ToggleKillAura,
        },
        {
            Title = "Zombie ESP",
            Description = "Highlights zombies and shows distance.",
            Type = "Toggle",
            Callback = Logic.ToggleZombieESP,
        },
        {
            Title = "Item ESP",
            Description = "Highlights dropped items.",
            Type = "Toggle",
            Callback = Logic.ToggleItemESP,
        },
        {
            Title = "Smooth Fly/Noclip",
            Description = "Walk on air or go underground smoothly.",
            Type = "Toggle",
            Callback = Logic.ToggleHeightModifier,
        }
    },
    Cleanup = Logic.Cleanup
}

return GameModule
