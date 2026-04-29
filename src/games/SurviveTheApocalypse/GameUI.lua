-- UI wiring for Survive the Apocalypse

local function BuildUI(Library, Logic)
    local Win = Library:CreateWindow("VANTAGE HUB", "Survive the Apocalypse")

    local CombatTab = Win:CreateTab("Combat")
    local VisualsTab = Win:CreateTab("Visuals")
    local MovementTab = Win:CreateTab("Movement")
    local SettingsTab = Win:CreateTab("Settings")

    CombatTab:CreateToggle("Kill Aura", "โจมตีซอมบี้รอบตัวโดยอัตโนมัติ", false, Logic.ToggleKillAura)
    CombatTab:CreateSlider("Aura Range", 5, 100, Logic.Settings.KillAuraRange, function(v)
        Logic.Settings.KillAuraRange = v
    end)
    CombatTab:CreateSlider("Attack Delay x0.1s", 1, 20, 1, function(v)
        Logic.Settings.KillAuraDelay = v / 10
    end)

    VisualsTab:CreateToggle("Zombie ESP", "แสดงตำแหน่งและระยะของซอมบี้", false, Logic.ToggleZombieESP)
    VisualsTab:CreateToggle("Item ESP", "แสดงตำแหน่งและระยะของไอเทม", false, Logic.ToggleItemESP)
    VisualsTab:CreateToggle("Auto Spectate", "สลับกล้องมอง Humanoid คนอื่นอัตโนมัติ", false, Logic.ToggleAutoSpectate)
    VisualsTab:CreateButton("Clear ESP", function()
        Logic.ToggleZombieESP(false)
        Logic.ToggleItemESP(false)
    end)

    MovementTab:CreateToggle("Smooth Fly / Noclip", "ปรับความสูงและเดินผ่านสิ่งกีดขวางแบบนุ่ม", false, Logic.ToggleHeightModifier)
    MovementTab:CreateSlider("Height Offset", -50, 100, Logic.Settings.HeightOffset, function(v)
        Logic.Settings.HeightOffset = v
    end)

    SettingsTab:CreateButton("Stop All Features", function()
        Logic.Cleanup()
    end)
    SettingsTab:CreateButton("Destroy UI", function()
        Logic.Cleanup()
        local ui = game:GetService("CoreGui"):FindFirstChild("VANTAGE HUB_UI")
        if ui then ui:Destroy() end
    end)
end

return BuildUI
