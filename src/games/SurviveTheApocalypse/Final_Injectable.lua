-- [[ GEMINI HUB: SURVIVE THE APOCALYPSE ]]
-- Powered by Gemini UI Template (Silent Luxury)

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/your-repo/main/Library.lua"))() 
-- หมายเหตุ: ในที่นี้ผมจะรวม Library ไว้ในไฟล์เดียวเพื่อให้คุณก๊อปปี้ง่ายๆ

-- =============================================================================
-- [ MODULE: LOGIC ] ระบบการทำงานของเกม
-- =============================================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Logic = {
    States = { KillAura = false, ZombieESP = false, ItemESP = false, HeightMod = false },
    Settings = { Range = 25, Delay = 0.1, Height = 0 },
    Connections = {}
}

local function clearESP()
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name:match("Gemini") and (v:IsA("BillboardGui") or v:IsA("BoxHandleAdornment")) then v:Destroy() end
    end
end

function Logic.ToggleKillAura(s)
    Logic.States.KillAura = s
    if not s then return end
    task.spawn(function()
        while Logic.States.KillAura do
            local char = LocalPlayer.Character
            if char then
                local hitRemote = char:FindFirstChild("HitTargets", true)
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hitRemote and hrp then
                    local targets = {}
                    for _, obj in pairs(workspace:FindFirstChild("Characters"):GetChildren()) do
                        if obj:IsA("Model") and obj.ModelStreamingMode == Enum.ModelStreamingMode.Atomic then
                            local tHrp = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart
                            if tHrp and (hrp.Position - tHrp.Position).Magnitude <= Logic.Settings.Range then
                                table.insert(targets, obj)
                            end
                        end
                    end
                    if #targets > 0 then hitRemote:FireServer(targets) end
                end
            end
            task.wait(Logic.Settings.Delay)
        end
    end)
end

function Logic.ToggleZombieESP(s)
    Logic.States.ZombieESP = s
    if s then
        Logic.Connections.ZESP = RunService.RenderStepped:Connect(function()
            local folder = workspace:FindFirstChild("Characters")
            if not folder then return end
            for _, obj in pairs(folder:GetChildren()) do
                if obj:IsA("Model") and obj.ModelStreamingMode == Enum.ModelStreamingMode.Atomic and not Players:GetPlayerFromCharacter(obj) then
                    local root = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart
                    if root and not root:FindFirstChild("GeminiZESP") then
                        local bg = Instance.new("BillboardGui", root)
                        bg.Name = "GeminiZESP"; bg.AlwaysOnTop = true; bg.Size = UDim2.new(0,100,0,20); bg.StudsOffset = Vector3.new(0,2,0)
                        local tl = Instance.new("TextLabel", bg)
                        tl.BackgroundTransparency = 1; tl.Size = UDim2.new(1,0,1,0); tl.TextColor3 = Color3.fromRGB(255,100,100); tl.Font = Enum.Font.GothamBold; tl.TextSize = 10
                        RunService.RenderStepped:Connect(function() if tl.Parent then tl.Text = obj.Name .. " [" .. math.floor((LocalPlayer.Character.HumanoidRootPart.Position - root.Position).Magnitude) .. "m]" end end)
                    end
                end
            end
        end)
    else
        if Logic.Connections.ZESP then Logic.Connections.ZESP:Disconnect() end
        clearESP()
    end
end

-- =============================================================================
-- [ MAIN: UI EXECUTION ] สร้างหน้าต่างและการเชื่อมต่อ
-- =============================================================================
-- (จำลองการโหลด Library จากไฟล์ข้างต้น)
local Win = Library:CreateWindow("GEMINI HUB", "Survive the Apocalypse")

local MainTab = Win:CreateTab("ฟังก์ชั่นหลัก")
local EspTab = Win:CreateTab("ระบบมอง")
local MiscTab = Win:CreateTab("อื่นๆ")

-- หน้าฟังก์ชั่นหลัก
MainTab:CreateToggle("เปิดใช้งาน Kill Aura", "โจมตีซอมบี้รอบตัวโดยอัตโนมัติ", false, Logic.ToggleKillAura)
MainTab:CreateSlider("ระยะการโจมตี (Studs)", 5, 100, 25, function(v) Logic.Settings.Range = v end)
MainTab:CreateSlider("ความเร็วการโจมตี (วินาที)", 0, 2, 0.1, function(v) Logic.Settings.Delay = v end)

-- หน้า ESP
EspTab:CreateToggle("เปิดใช้งาน ESP Zombie", "แสดงตำแหน่งซอมบี้ทะลุกำแพง", false, Logic.ToggleZombieESP)
EspTab:CreateButton("เคลียร์ ESP ทั้งหมด", function() clearESP() end)

-- หน้าอื่นๆ
MiscTab:CreateButton("ทำลาย UI", function() 
    if game:GetService("CoreGui"):FindFirstChild("GEMINI HUB_UI") then 
        game:GetService("CoreGui")["GEMINI HUB_UI"]:Destroy() 
    end 
end)

print("Gemini Hub Loaded Successfully!")
