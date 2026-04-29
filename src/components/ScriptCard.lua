local Roact = require(game:GetService("ReplicatedStorage"):WaitForChild("Roact"))
local Config = require(script.Parent.Parent:WaitForChild("Config"))
local TweenService = game:GetService("TweenService")

local ScriptCard = Roact.Component:extend("ScriptCard")

function ScriptCard:init()
    self.state = {
        IsHovered = false,
        Toggled = self.props.DefaultToggled or false
    }
    
    self.onMouseEnter = function()
        self:setState({ IsHovered = true })
    end
    
    self.onMouseLeave = function()
        self:setState({ IsHovered = false })
    end
    
    self.onActivated = function()
        if self.props.Type == "Toggle" then
            local newState = not self.state.Toggled
            self:setState({ Toggled = newState })
            if self.props.OnCallback then
                self.props.OnCallback(newState)
            end
        else
            if self.props.OnCallback then
                self.props.OnCallback()
            end
        end
    end
end

function ScriptCard:render()
    local isToggle = self.props.Type == "Toggle"
    
    return Roact.createElement("Frame", {
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundColor3 = Config.Theme.Sidebar,
        BackgroundTransparency = self.state.IsHovered and 0.5 or 0.7,
        BorderSizePixel = 0,
        [Roact.Event.MouseEnter] = self.onMouseEnter,
        [Roact.Event.MouseLeave] = self.onMouseLeave,
    }, {
        UICorner = Roact.createElement("UICorner", {
            CornerRadius = UDim.new(0, 6),
        }),
        
        Padding = Roact.createElement("UIPadding", {
            PaddingLeft = UDim.new(0, 12),
            PaddingRight = UDim.new(0, 12),
        }),
        
        Title = Roact.createElement("TextLabel", {
            Size = UDim2.new(1, -100, 0, 25),
            Position = UDim2.new(0, 0, 0, 10),
            BackgroundTransparency = 1,
            Text = self.props.Title or "Script Name",
            TextColor3 = Config.Theme.Text,
            Font = Enum.Font.GothamBold,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
        }),
        
        Description = Roact.createElement("TextLabel", {
            Size = UDim2.new(1, -100, 0, 20),
            Position = UDim2.new(0, 0, 0, 30),
            BackgroundTransparency = 1,
            Text = self.props.Description or "Description of what this script does.",
            TextColor3 = Config.Theme.SecondaryText,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTransparency = 0.2,
        }),
        
        ActionArea = Roact.createElement("Frame", {
            Size = UDim2.new(0, 80, 0, 30),
            Position = UDim2.new(1, -80, 0.5, -15),
            BackgroundTransparency = 1,
        }, {
            Button = not isToggle and Roact.createElement("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundColor3 = Config.Theme.Accent,
                Text = "Execute",
                TextColor3 = Color3.fromRGB(0, 0, 0),
                Font = Enum.Font.GothamBold,
                TextSize = 12,
                [Roact.Event.Activated] = self.onActivated,
            }, {
                UICorner = Roact.createElement("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                })
            }),
            
            Toggle = isToggle and Roact.createElement("TextButton", {
                Size = UDim2.new(0, 45, 0, 22),
                Position = UDim2.new(1, -45, 0.5, -11),
                BackgroundColor3 = self.state.Toggled and Config.Theme.Accent or Color3.fromRGB(50, 50, 50),
                Text = "",
                [Roact.Event.Activated] = self.onActivated,
            }, {
                UICorner = Roact.createElement("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                }),
                
                Knob = Roact.createElement("Frame", {
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = UDim2.new(0, self.state.Toggled and 25 or 3, 0.5, -8),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                }, {
                    UICorner = Roact.createElement("UICorner", {
                        CornerRadius = UDim.new(1, 0),
                    })
                })
            })
        })
    })
end

return ScriptCard
