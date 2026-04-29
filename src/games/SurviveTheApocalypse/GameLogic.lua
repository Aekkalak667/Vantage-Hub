-- Logic for Survive the Apocalypse
-- Optimized and Modularized for Gemini Hub

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Logic = {}

-- State management
Logic.States = {
    KillAura = false,
    ZombieESP = false,
    ItemESP = false,
    HeightModifier = false,
    AutoSpectate = false,
}

Logic.Settings = {
    KillAuraRange = 25,
    KillAuraDelay = 0.1,
    HeightOffset = 0,
    SpectateInterval = 3,
}

-- Connections for cleanup
local Connections = {}
local HeightPlatform = nil

local function clearESP()
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "GeminiZombieESP" or v.Name == "GeminiZombieTextESP" or v.Name == "GeminiZombieBoxESP" or v.Name == "GeminiItemTextESP" then
            v:Destroy()
        end
    end
end

-- =================== Kill Aura ===================
function Logic.ToggleKillAura(state)
    Logic.States.KillAura = state
    if not state then return end

    task.spawn(function()
        while Logic.States.KillAura do
            local character = LocalPlayer.Character
            if character then
                local hitRemote = nil
                local swingRemote = nil

                for _, child in pairs(character:GetChildren()) do
                    local hit = child:FindFirstChild("HitTargets", true)
                    local swing = child:FindFirstChild("Swing", true)
                    if hit then
                        hitRemote = hit
                        swingRemote = swing
                        break
                    end
                end

                if hitRemote then
                    local charsFolder = workspace:FindFirstChild("Characters")
                    local hrp = character:FindFirstChild("HumanoidRootPart")

                    if charsFolder and hrp then
                        local targets = {}
                        for _, obj in pairs(charsFolder:GetChildren()) do
                            if obj:IsA("Model") and obj.ModelStreamingMode == Enum.ModelStreamingMode.Atomic then
                                if not Players:GetPlayerFromCharacter(obj) and obj ~= character then
                                    local targetHRP = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart
                                    if targetHRP then
                                        local dist = (hrp.Position - targetHRP.Position).Magnitude
                                        if dist <= Logic.Settings.KillAuraRange then
                                            table.insert(targets, obj)
                                        end
                                    end
                                end
                            end
                        end

                        if #targets > 0 then
                            hitRemote:FireServer(targets)
                            if swingRemote then swingRemote:FireServer() end
                        end
                    end
                end
            end
            task.wait(Logic.Settings.KillAuraDelay)
        end
    end)
end

-- =================== ESP Zombie ===================
local function updateZombieESP()
    local charsFolder = workspace:FindFirstChild("Characters")
    if not charsFolder then return end
    local lpRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    for _, obj in pairs(charsFolder:GetChildren()) do
        local isZombie = false
        if obj:IsA("Model") and obj.ModelStreamingMode == Enum.ModelStreamingMode.Atomic then
            if not Players:GetPlayerFromCharacter(obj) and obj ~= LocalPlayer.Character then
                isZombie = true
            end
        end

        local rootPart = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso") or obj.PrimaryPart

        if isZombie and rootPart then
            local espText = rootPart:FindFirstChild("GeminiZombieTextESP")
            if not espText then
                espText = Instance.new("BillboardGui")
                espText.Name = "GeminiZombieTextESP"
                espText.AlwaysOnTop = true
                espText.Size = UDim2.new(0, 100, 0, 20)
                espText.StudsOffset = Vector3.new(0, 1.2, 0)

                local textLabel = Instance.new("TextLabel")
                textLabel.Name = "NameLabel"
                textLabel.Size = UDim2.new(1, 0, 1, 0)
                textLabel.BackgroundTransparency = 1
                textLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
                textLabel.TextStrokeTransparency = 0
                textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                textLabel.Font = Enum.Font.GothamMedium
                textLabel.TextSize = 10
                textLabel.Parent = espText
                espText.Parent = rootPart
            end

            local espBox = rootPart:FindFirstChild("GeminiZombieBoxESP")
            if not espBox then
                espBox = Instance.new("BoxHandleAdornment")
                espBox.Name = "GeminiZombieBoxESP"
                espBox.Adornee = rootPart
                espBox.Size = rootPart.Size + Vector3.new(0.05, 0.05, 0.05)
                espBox.Color3 = Color3.fromRGB(255, 80, 80)
                espBox.Transparency = 0.6
                espBox.AlwaysOnTop = true
                espBox.ZIndex = 1
                espBox.Parent = rootPart
            end

            local dist = lpRoot and math.floor((lpRoot.Position - rootPart.Position).Magnitude) or 0
            espText.NameLabel.Text = obj.Name .. " [" .. dist .. "m]"
        end
    end
end

function Logic.ToggleZombieESP(state)
    Logic.States.ZombieESP = state
    if state then
        Connections.ZombieESP = RunService.RenderStepped:Connect(updateZombieESP)
    else
        if Connections.ZombieESP then
            Connections.ZombieESP:Disconnect()
            Connections.ZombieESP = nil
        end
        clearESP()
    end
end

-- =================== ESP Item ===================
local function updateItemESP()
    local droppedItemsFolder = workspace:FindFirstChild("DroppedItems")
    if not droppedItemsFolder then return end
    local lpRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    for _, obj in pairs(droppedItemsFolder:GetChildren()) do
        local targetPart = obj:IsA("BasePart") and obj or (obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")))
        if targetPart then
            local espText = targetPart:FindFirstChild("GeminiItemTextESP")
            if not espText then
                espText = Instance.new("BillboardGui")
                espText.Name = "GeminiItemTextESP"
                espText.AlwaysOnTop = true
                espText.Size = UDim2.new(0, 100, 0, 20)
                espText.StudsOffset = Vector3.new(0, 1, 0)

                local textLabel = Instance.new("TextLabel")
                textLabel.Name = "NameLabel"
                textLabel.Size = UDim2.new(1, 0, 1, 0)
                textLabel.BackgroundTransparency = 1
                textLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
                textLabel.TextStrokeTransparency = 0
                textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                textLabel.Font = Enum.Font.GothamMedium
                textLabel.TextSize = 10
                textLabel.Parent = espText
                espText.Parent = targetPart
            end
            local dist = lpRoot and math.floor((lpRoot.Position - targetPart.Position).Magnitude) or 0
            espText.NameLabel.Text = "📦 " .. obj.Name .. " [" .. dist .. "m]"
        end
    end
end

function Logic.ToggleItemESP(state)
    Logic.States.ItemESP = state
    if state then
        Connections.ItemESP = RunService.RenderStepped:Connect(updateItemESP)
    else
        if Connections.ItemESP then
            Connections.ItemESP:Disconnect()
            Connections.ItemESP = nil
        end
        clearESP()
    end
end

-- =================== Height Modifier ===================
function Logic.ToggleHeightModifier(state)
    Logic.States.HeightModifier = state
    if state then
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end

        local startY = char.HumanoidRootPart.Position.Y
        local lastOffset = Logic.Settings.HeightOffset

        HeightPlatform = Instance.new("Part")
        HeightPlatform.Name = "GeminiSmoothPlatform"
        HeightPlatform.Size = Vector3.new(100, 2, 100)
        HeightPlatform.Anchored = true
        HeightPlatform.Transparency = 1
        HeightPlatform.Parent = workspace

        LocalPlayer.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam

        Connections.HeightModifier = RunService.Stepped:Connect(function()
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local hrp = character.HumanoidRootPart
                for _, p in pairs(character:GetDescendants()) do
                    if p:IsA("BasePart") and p.CanCollide and p.Name ~= "GeminiSmoothPlatform" then
                        p.CanCollide = false
                    end
                end

                local targetY = startY + Logic.Settings.HeightOffset
                HeightPlatform.CFrame = CFrame.new(hrp.Position.X, targetY - 3.5, hrp.Position.Z)

                if lastOffset ~= Logic.Settings.HeightOffset then
                    hrp.CFrame = hrp.CFrame + Vector3.new(0, Logic.Settings.HeightOffset - lastOffset, 0)
                    lastOffset = Logic.Settings.HeightOffset
                end

                if math.abs(hrp.Position.Y - targetY) > 4 then
                    hrp.CFrame = CFrame.new(hrp.Position.X, targetY, hrp.Position.Z) * hrp.CFrame.Rotation
                    hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 0, hrp.AssemblyLinearVelocity.Z)
                end
            end
        end)
    else
        if Connections.HeightModifier then
            Connections.HeightModifier:Disconnect()
            Connections.HeightModifier = nil
        end
        if HeightPlatform then
            HeightPlatform:Destroy()
            HeightPlatform = nil
        end
        local char = LocalPlayer.Character
        if char then
            for _, p in pairs(char:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = true end
            end
        end
        LocalPlayer.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Zoom
    end
end

-- =================== Auto Spectate ===================
local function restoreCameraToLocalPlayer()
    Camera = workspace.CurrentCamera or Camera
    local character = LocalPlayer.Character
    if not character then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid and Camera then
        Camera.CameraSubject = humanoid
    end
end

function Logic.ToggleAutoSpectate(state)
    if state and Logic.States.AutoSpectate then return end
    Logic.States.AutoSpectate = state

    if not state then
        restoreCameraToLocalPlayer()
        return
    end

    task.spawn(function()
        while Logic.States.AutoSpectate do
            local foundSomeone = false
            Camera = workspace.CurrentCamera or Camera

            for _, obj in pairs(workspace:GetDescendants()) do
                if not Logic.States.AutoSpectate then break end

                if obj:IsA("Humanoid") then
                    local character = obj.Parent
                    if character and character:IsA("Model") and character ~= LocalPlayer.Character then
                        foundSomeone = true
                        if Camera then
                            Camera.CameraSubject = obj
                        end
                        task.wait(Logic.Settings.SpectateInterval)
                    end
                end
            end

            if not foundSomeone and Logic.States.AutoSpectate then
                task.wait(1)
            end
        end
    end)
end

function Logic.Cleanup()
    Logic.ToggleKillAura(false)
    Logic.ToggleZombieESP(false)
    Logic.ToggleItemESP(false)
    Logic.ToggleHeightModifier(false)
    Logic.ToggleAutoSpectate(false)
end

return Logic
