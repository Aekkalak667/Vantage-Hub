-- Main entry point for the Roblox Script Hub
-- Theme: Obsidian Gold (Silent Luxury)

local Roact = _G.Roact or require(game:GetService("ReplicatedStorage"):WaitForChild("Roact"))
local Config = require(script.Parent:WaitForChild("Config"))

local Container = require(script.Parent:WaitForChild("components"):WaitForChild("Container"))
local ScriptCard = require(script.Parent:WaitForChild("components"):WaitForChild("ScriptCard"))

-- Game Loader
local Games = {}
local gamesFolder = script.Parent:WaitForChild("games")
for _, child in pairs(gamesFolder:GetChildren()) do
    if child:IsA("ModuleScript") or (child:IsA("Folder") and child:FindFirstChild("init")) then
        local gameModule = require(child)
        Games[gameModule.Name] = gameModule
    end
end

local App = Roact.Component:extend("App")

function App:init()
    self:setState({
        ActiveTab = "Home",
        CurrentGame = "Survive the Apocalypse" -- Default or auto-detected
    })

    self.onChangeTab = function(tabName)
        self:setState({
            ActiveTab = tabName
        })
    end
end

function App:render()
    local currentGameData = Games[self.state.CurrentGame]
    local scriptElements = {}
    
    if currentGameData and currentGameData.Scripts then
        for i, scriptInfo in ipairs(currentGameData.Scripts) do
            scriptElements[scriptInfo.Title] = Roact.createElement(ScriptCard, {
                Title = scriptInfo.Title,
                Description = scriptInfo.Description,
                Type = scriptInfo.Type,
                DefaultToggled = false,
                OnCallback = scriptInfo.Callback,
                LayoutOrder = i,
            })
        end
    end

    return Roact.createElement("ScreenGui", {
        Name = "RobloxScriptHub",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, {
        Container = Roact.createElement(Container, {
            ActiveTab = self.state.ActiveTab,
            onChangeTab = self.onChangeTab,
        }, {
            -- Content based on ActiveTab
            Home = self.state.ActiveTab == "Home" and Roact.createElement("Frame", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
            }, {
                Layout = Roact.createElement("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 10),
                }),
                
                Title = Roact.createElement("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 40),
                    BackgroundTransparency = 1,
                    Text = "Welcome to Gemini Script Hub",
                    TextColor3 = Config.Theme.Text,
                    Font = Enum.Font.GothamBold,
                    TextSize = 20,
                    TextXAlignment = Enum.TextXAlignment.Left,
                }),
                
                GameInfo = currentGameData and Roact.createElement("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundTransparency = 1,
                    Text = "Current Game: " .. currentGameData.Name,
                    TextColor3 = Config.Theme.Accent,
                    Font = Enum.Font.GothamSemibold,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                }),
            }),
            
            Scripts = self.state.ActiveTab == "Scripts" and Roact.createElement("ScrollingFrame", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ScrollBarThickness = 2,
                ScrollBarImageColor3 = Config.Theme.Accent,
                CanvasSize = UDim2.new(0, 0, 0, 0), -- Auto-calculated by UIListLayout
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
            }, {
                Layout = Roact.createElement("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 10),
                }),
                
                Scripts = Roact.createFragment(scriptElements)
            }),

            Settings = self.state.ActiveTab == "Settings" and Roact.createElement("TextLabel", {
                Size = UDim2.new(1, 0, 0, 100),
                BackgroundTransparency = 1,
                Text = "Settings menu coming soon.",
                TextColor3 = Config.Theme.Text,
                Font = Enum.Font.Gotham,
                TextSize = 16,
            }),
        })
    })
end

local function Init()
    local player = game:GetService("Players").LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    
    local handle = Roact.mount(Roact.createElement(App), playerGui, "ScriptHub")
    return handle
end

local handle = Init()

return {
    Unmount = function()
        if handle then
            Roact.unmount(handle)
        end
        -- Cleanup current game logic
        for _, gameData in pairs(Games) do
            if gameData.Cleanup then
                gameData.Cleanup()
            end
        end
    end
}
