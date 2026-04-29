local Roact = require(game:GetService("ReplicatedStorage"):WaitForChild("Roact"))
local Config = require(script.Parent.Parent:WaitForChild("Config"))
local TweenService = game:GetService("TweenService")

local Sidebar = Roact.Component:extend("Sidebar")

function Sidebar:init()
    self.buttonRefs = {}
end

function Sidebar:render()
    local tabs = {"Home", "Scripts", "Settings"}
    local children = {
        UICorner = Roact.createElement("UICorner", {
            CornerRadius = Config.UI.CornerRadius,
        }),
        
        UIGradient = Roact.createElement("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Config.Theme.Sidebar),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 25)),
            }),
            Rotation = 90,
        }),

        Padding = Roact.createElement("UIPadding", {
            PaddingTop = Config.UI.Padding,
            PaddingBottom = Config.UI.Padding,
            PaddingLeft = Config.UI.Padding,
            PaddingRight = Config.UI.Padding,
        }),

        Layout = Roact.createElement("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8),
        }),

        Title = Roact.createElement("TextLabel", {
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundTransparency = 1,
            Text = "GEMINI",
            TextColor3 = Config.Theme.Accent,
            Font = Enum.Font.GothamBold,
            TextSize = 18,
            TextXAlignment = Enum.TextXAlignment.Left,
            LayoutOrder = 0,
        })
    }

    for i, tabName in ipairs(tabs) do
        local isActive = self.props.ActiveTab == tabName
        
        children[tabName] = Roact.createElement("TextButton", {
            Size = UDim2.new(1, 0, 0, 32),
            BackgroundColor3 = isActive and Config.Theme.Accent or Config.Theme.Sidebar,
            BackgroundTransparency = isActive and 0.8 or 1,
            BorderSizePixel = 0,
            Text = tabName,
            TextColor3 = isActive and Config.Theme.Accent or Config.Theme.Text,
            Font = Enum.Font.GothamMedium,
            TextSize = 14,
            LayoutOrder = i,
            [Roact.Event.Activated] = function()
                if self.props.onChangeTab then
                    self.props.onChangeTab(tabName)
                end
            end,
            [Roact.Event.MouseEnter] = function(rbx)
                if not isActive then
                    TweenService:Create(rbx, TweenInfo.new(0.2), {
                        BackgroundTransparency = 0.9,
                        TextColor3 = Config.Theme.Accent
                    }):Play()
                end
            end,
            [Roact.Event.MouseLeave] = function(rbx)
                if not isActive then
                    TweenService:Create(rbx, TweenInfo.new(0.2), {
                        BackgroundTransparency = 1,
                        TextColor3 = Config.Theme.Text
                    }):Play()
                end
            end
        }, {
            UICorner = Roact.createElement("UICorner", {
                CornerRadius = UDim.new(0, 4),
            })
        })
    end

    return Roact.createElement("Frame", {
        Size = UDim2.new(0, 160, 1, 0),
        BackgroundColor3 = Config.Theme.Sidebar,
        BorderSizePixel = 0,
    }, children)
end

return Sidebar
