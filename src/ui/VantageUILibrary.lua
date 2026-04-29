-- [[ VANTAGE HUB UI LIBRARY ]]
-- Created by Aekkalak667
-- Theme: Silent Luxury (Obsidian Gold)
-- Source of truth for reusable UI template.
-- For one-file runner usage, bundle this source into a Final_Injectable.lua artifact.

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

    -- ปุ่มลอยสำหรับเปิด/ปิดหน้าต่างหลัก ใช้เป็นมาตรฐานของ template ทุกเกม
    local uiVisible = true
    local ToggleOpenIcon = "VH"
    local ToggleClosedIcon = "+"

    local FloatingToggleButton = Instance.new("TextButton")
    FloatingToggleButton.Name = "FloatingToggleButton"
    FloatingToggleButton.Size = UDim2.new(0, 54, 0, 54)
    FloatingToggleButton.Position = UDim2.new(0, 20, 0.5, -27)
    FloatingToggleButton.AnchorPoint = Vector2.new(0, 0)
    FloatingToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
    FloatingToggleButton.Text = ToggleOpenIcon
    FloatingToggleButton.TextColor3 = Color3.fromRGB(212, 175, 55)
    FloatingToggleButton.Font = Enum.Font.GothamBlack
    FloatingToggleButton.TextSize = 18
    FloatingToggleButton.AutoButtonColor = false
    FloatingToggleButton.ZIndex = 50
    FloatingToggleButton.Parent = ScreenGui
    Instance.new("UICorner", FloatingToggleButton).CornerRadius = UDim.new(1, 0)

    local FloatingStroke = Instance.new("UIStroke", FloatingToggleButton)
    FloatingStroke.Color = Color3.fromRGB(212, 175, 55)
    FloatingStroke.Thickness = 1.5
    FloatingStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local function setUiVisible(visible)
        uiVisible = visible
        MainFrame.Visible = uiVisible
        FloatingToggleButton.Text = uiVisible and ToggleOpenIcon or ToggleClosedIcon
        TS:Create(FloatingToggleButton, TweenInfo.new(0.2), {
            BackgroundColor3 = uiVisible and Color3.fromRGB(20, 20, 22) or Color3.fromRGB(212, 175, 55),
            TextColor3 = uiVisible and Color3.fromRGB(212, 175, 55) or Color3.fromRGB(0, 0, 0)
        }):Play()
    end

    FloatingToggleButton.MouseButton1Click:Connect(function()
        setUiVisible(not uiVisible)
    end)

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

return Library
