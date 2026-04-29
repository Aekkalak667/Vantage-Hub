local Players = game:GetService("Players")
local Roact = require(game:GetService("ReplicatedStorage"):WaitForChild("Roact"))
local Config = require(script.Parent.Parent:WaitForChild("Config"))

local Header = Roact.Component:extend("Header")

function Header:init()
    self:setState({
        displayName = "Loading...",
        thumbnail = "",
    })
end

function Header:didMount()
    local player = Players.LocalPlayer
    if player then
        local content, isReady = Players:GetUserThumbnailAsync(
            player.UserId,
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size100x100
        )
        
        self:setState({
            displayName = player.DisplayName,
            thumbnail = isReady and content or "",
        })
    end
end

function Header:render()
    return Roact.createElement("Frame", {
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundColor3 = Config.Theme.Background,
        BorderSizePixel = 0,
    }, {
        UICorner = Roact.createElement("UICorner", {
            CornerRadius = Config.UI.CornerRadius,
        }),

        Padding = Roact.createElement("UIPadding", {
            PaddingTop = Config.UI.Padding,
            PaddingBottom = Config.UI.Padding,
            PaddingLeft = Config.UI.Padding,
            PaddingRight = Config.UI.Padding,
        }),

        Title = Roact.createElement("TextLabel", {
            Size = UDim2.new(0.5, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = self.props.Title or "Dashboard",
            TextColor3 = Config.Theme.Text,
            Font = Enum.Font.GothamMedium,
            TextSize = 20,
            TextXAlignment = Enum.TextXAlignment.Left,
        }),

        ProfileSection = Roact.createElement("Frame", {
            Size = UDim2.new(0.5, 0, 1, 0),
            Position = UDim2.new(0.5, 0, 0, 0),
            BackgroundTransparency = 1,
        }, {
            Layout = Roact.createElement("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Right,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Padding = UDim.new(0, 10),
            }),

            PlayerName = Roact.createElement("TextLabel", {
                Size = UDim2.new(0, 0, 1, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1,
                Text = self.state.displayName,
                TextColor3 = Config.Theme.Text,
                Font = Enum.Font.Gotham,
                TextSize = 14,
            }),

            Avatar = Roact.createElement("ImageLabel", {
                Size = UDim2.new(0, 32, 0, 32),
                BackgroundColor3 = Config.Theme.Sidebar,
                Image = self.state.thumbnail,
                BorderSizePixel = 0,
            }, {
                UICorner = Roact.createElement("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                }),
            })
        }),

        AccentLine = Roact.createElement("Frame", {
            Size = UDim2.new(1, 0, 0, 2),
            Position = UDim2.new(0, 0, 1, 0),
            BackgroundColor3 = Config.Theme.Accent,
            BorderSizePixel = 0,
        })
    })
end

return Header
