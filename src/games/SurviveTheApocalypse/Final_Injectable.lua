-- [[ VANTAGE HUB: SURVIVE THE APOCALYPSE - SINGLE FILE ]]
-- Created by Aekkalak667
-- Theme: Silent Luxury (Obsidian Gold)
-- Runner note: this file is self-contained. Paste/run this file only; no external Library.lua, Roact, or module require is needed.

-- =============================================================================
-- [ EMBEDDED UI LIBRARY ]
-- =============================================================================
-- Gemini UI Library (Silent Luxury Edition)
-- มาตรฐาน GSD Standard & uxuipromax

local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local Library = {}

function Library:CreateWindow(hubName, gameName)
    local uiName = hubName .. "_UI"

    local oldCoreGui = CoreGui:FindFirstChild(uiName)
    if oldCoreGui then oldCoreGui:Destroy() end

    if Players.LocalPlayer and Players.LocalPlayer:FindFirstChild("PlayerGui") then
        local oldPlayerGui = Players.LocalPlayer.PlayerGui:FindFirstChild(uiName)
        if oldPlayerGui then oldPlayerGui:Destroy() end
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = uiName
    ScreenGui.ResetOnSpawn = false

    -- ป้องกันการตรวจจับเบื้องต้น
    local success, err = pcall(function() ScreenGui.Parent = CoreGui end)
    if not success then ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui") end

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 550, 0, 380)
    MainFrame.Position = UDim2.new(0.5, -275, 0.5, -190)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 17) -- Obsidian
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

    local Stroke = Instance.new("UIStroke", MainFrame)
    Stroke.Color = Color3.fromRGB(212, 175, 55) -- Gold
    Stroke.Thickness = 1.5
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    -- แถบ Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 160, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

    -- เส้นกั้น Sidebar
    local Line = Instance.new("Frame")
    Line.Size = UDim2.new(0, 1, 1, -20)
    Line.Position = UDim2.new(1, -1, 0, 10)
    Line.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Line.BorderSizePixel = 0
    Line.Parent = Sidebar

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.BackgroundTransparency = 1
    Title.Text = hubName
    Title.TextColor3 = Color3.fromRGB(212, 175, 55)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.Parent = Sidebar

    local SubTitle = Instance.new("TextLabel")
    SubTitle.Size = UDim2.new(1, 0, 0, 20)
    SubTitle.Position = UDim2.new(0, 0, 0, 40)
    SubTitle.BackgroundTransparency = 1
    SubTitle.Text = gameName
    SubTitle.TextColor3 = Color3.fromRGB(150, 150, 150)
    SubTitle.Font = Enum.Font.Gotham
    SubTitle.TextSize = 11
    SubTitle.Parent = Sidebar

    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Size = UDim2.new(1, -20, 1, -80)
    TabContainer.Position = UDim2.new(0, 10, 0, 70)
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.ScrollBarThickness = 0
    TabContainer.Parent = Sidebar

    local TabList = Instance.new("UIListLayout", TabContainer)
    TabList.Padding = UDim.new(0, 5)

    local PageContainer = Instance.new("Frame")
    PageContainer.Size = UDim2.new(1, -170, 1, -20)
    PageContainer.Position = UDim2.new(0, 170, 0, 10)
    PageContainer.BackgroundTransparency = 1
    PageContainer.Parent = MainFrame

    local Pages = {}
    local firstTab = true

    -- ระบบลากหน้าต่าง
    local dragging, dragInput, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    function Pages:CreateTab(name)
        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.ScrollBarThickness = 2
        Page.Visible = firstTab
        Page.Parent = PageContainer

        local PageList = Instance.new("UIListLayout", Page)
        PageList.Padding = UDim.new(0, 8)

        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 35)
        TabBtn.BackgroundColor3 = firstTab and Color3.fromRGB(212, 175, 55) or Color3.fromRGB(30, 30, 33)
        TabBtn.Text = name
        TabBtn.TextColor3 = firstTab and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(200, 200, 200)
        TabBtn.Font = Enum.Font.GothamSemibold
        TabBtn.TextSize = 13
        TabBtn.Parent = TabContainer
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(PageContainer:GetChildren()) do v.Visible = false end
            for _, v in pairs(TabContainer:GetChildren()) do
                if v:IsA("TextButton") then
                    TS:Create(v, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(30, 30, 33), TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
                end
            end
            Page.Visible = true
            TS:Create(TabBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(212, 175, 55), TextColor3 = Color3.fromRGB(0, 0, 0)}):Play()
        end)

        firstTab = false

        local Elements = {}

        function Elements:CreateToggle(title, desc, default, callback)
            local state = default
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Size = UDim2.new(1, -10, 0, 50)
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 27)
            ToggleFrame.Parent = Page
            Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 6)

            local TTitle = Instance.new("TextLabel", ToggleFrame)
            TTitle.Size = UDim2.new(1, -60, 0, 30)
            TTitle.Position = UDim2.new(0, 15, 0, 5)
            TTitle.Text = title
            TTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            TTitle.Font = Enum.Font.GothamBold
            TTitle.TextSize = 14
            TTitle.TextXAlignment = Enum.TextXAlignment.Left
            TTitle.BackgroundTransparency = 1

            local TDesc = Instance.new("TextLabel", ToggleFrame)
            TDesc.Size = UDim2.new(1, -60, 0, 20)
            TDesc.Position = UDim2.new(0, 15, 0, 25)
            TDesc.Text = desc
            TDesc.TextColor3 = Color3.fromRGB(150, 150, 150)
            TDesc.Font = Enum.Font.Gotham
            TDesc.TextSize = 11
            TDesc.TextXAlignment = Enum.TextXAlignment.Left
            TDesc.BackgroundTransparency = 1

            local Switch = Instance.new("Frame", ToggleFrame)
            Switch.Size = UDim2.new(0, 40, 0, 20)
            Switch.Position = UDim2.new(1, -55, 0.5, -10)
            Switch.BackgroundColor3 = state and Color3.fromRGB(212, 175, 55) or Color3.fromRGB(50, 50, 55)
            Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

            local Knob = Instance.new("Frame", Switch)
            Knob.Size = UDim2.new(0, 16, 0, 16)
            Knob.Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

            local Btn = Instance.new("TextButton", ToggleFrame)
            Btn.Size = UDim2.new(1, 0, 1, 0)
            Btn.BackgroundTransparency = 1
            Btn.Text = ""

            Btn.MouseButton1Click:Connect(function()
                state = not state
                TS:Create(Switch, TweenInfo.new(0.3), {BackgroundColor3 = state and Color3.fromRGB(212, 175, 55) or Color3.fromRGB(50, 50, 55)}):Play()
                TS:Create(Knob, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
                callback(state)
            end)
        end

        function Elements:CreateSlider(title, min, max, default, callback)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(1, -10, 0, 60)
            SliderFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 27)
            SliderFrame.Parent = Page
            Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 6)

            local STitle = Instance.new("TextLabel", SliderFrame)
            STitle.Size = UDim2.new(0.7, 0, 0, 30)
            STitle.Position = UDim2.new(0, 15, 0, 5)
            STitle.Text = title
            STitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            STitle.Font = Enum.Font.GothamBold
            STitle.TextSize = 14
            STitle.TextXAlignment = Enum.TextXAlignment.Left
            STitle.BackgroundTransparency = 1

            local ValLabel = Instance.new("TextLabel", SliderFrame)
            ValLabel.Size = UDim2.new(0.3, -15, 0, 30)
            ValLabel.Position = UDim2.new(0.7, 0, 0, 5)
            ValLabel.Text = tostring(default)
            ValLabel.TextColor3 = Color3.fromRGB(212, 175, 55)
            ValLabel.Font = Enum.Font.GothamBold
            ValLabel.TextSize = 14
            ValLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValLabel.BackgroundTransparency = 1

            local Bar = Instance.new("Frame", SliderFrame)
            Bar.Size = UDim2.new(1, -30, 0, 6)
            Bar.Position = UDim2.new(0, 15, 0, 40)
            Bar.BackgroundColor3 = Color3.fromRGB(45, 45, 47)
            Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)

            local Fill = Instance.new("Frame", Bar)
            Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            Fill.BackgroundColor3 = Color3.fromRGB(212, 175, 55)
            Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

            local Trigger = Instance.new("TextButton", Bar)
            Trigger.Size = UDim2.new(1, 0, 1, 20)
            Trigger.Position = UDim2.new(0, 0, 0, -10)
            Trigger.BackgroundTransparency = 1
            Trigger.Text = ""

            local dragging = false
            local function update()
                local pos = math.clamp((UIS:GetMouseLocation().X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                local val = math.floor(min + (max - min) * pos)
                ValLabel.Text = tostring(val)
                Fill.Size = UDim2.new(pos, 0, 1, 0)
                callback(val)
            end

            Trigger.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true update() end
            end)
            UIS.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
            end)
            UIS.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then update() end
            end)
        end

        function Elements:CreateButton(title, callback)
            local BtnFrame = Instance.new("TextButton")
            BtnFrame.Size = UDim2.new(1, -10, 0, 40)
            BtnFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 38)
            BtnFrame.Text = title
            BtnFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
            BtnFrame.Font = Enum.Font.GothamBold
            BtnFrame.TextSize = 14
            BtnFrame.Parent = Page
            Instance.new("UICorner", BtnFrame).CornerRadius = UDim.new(0, 6)

            BtnFrame.MouseButton1Click:Connect(callback)

            BtnFrame.MouseEnter:Connect(function()
                TS:Create(BtnFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 48)}):Play()
            end)
            BtnFrame.MouseLeave:Connect(function()
                TS:Create(BtnFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 38)}):Play()
            end)
        end

        return Elements
    end

    return Pages
end

-- =============================================================================
-- [ EMBEDDED GAME LOGIC ]
-- =============================================================================
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
-- =============================================================================
-- [ MAIN: UI EXECUTION ]
-- =============================================================================
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

print("Vantage Hub Survive the Apocalypse Loaded Successfully!")
