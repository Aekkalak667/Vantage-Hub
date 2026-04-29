local TweenService = game:GetService("TweenService")
local Roact = require(game:GetService("ReplicatedStorage"):WaitForChild("Roact"))
local Config = require(script.Parent.Parent:WaitForChild("Config"))

local Sidebar = require(script.Parent:WaitForChild("Sidebar"))
local Header = require(script.Parent:WaitForChild("Header"))

local Container = Roact.Component:extend("Container")

function Container:init()
    self.mainRef = Roact.createRef()
end

function Container:didMount()
    local frame = self.mainRef:getValue()
    if frame then
        frame.GroupTransparency = 1
        frame.Position = UDim2.new(0.5, 0, 0.6, 0)
        
        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        local tween = TweenService:Create(frame, tweenInfo, {
            GroupTransparency = 0,
            Position = UDim2.new(0.5, 0, 0.5, 0)
        })
        
        tween:Play()
    end
end

function Container:render()
    return Roact.createElement("CanvasGroup", {
        [Roact.Ref] = self.mainRef,
        Size = UDim2.new(0, 600, 0, 400),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Config.Theme.Background,
        BorderSizePixel = 0,
        GroupTransparency = 1, -- Start transparent for animation
    }, {
        UICorner = Roact.createElement("UICorner", {
            CornerRadius = Config.UI.CornerRadius,
        }),

        UIGradient = Roact.createElement("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 45)),
                ColorSequenceKeypoint.new(1, Config.Theme.Background),
            }),
            Rotation = 45,
        }),

        Sidebar = Roact.createElement(Sidebar, {
            ActiveTab = self.props.ActiveTab,
            onChangeTab = self.props.onChangeTab,
        }),

        MainPanel = Roact.createElement("Frame", {
            Size = UDim2.new(1, -160, 1, 0),
            Position = UDim2.new(0, 160, 0, 0),
            BackgroundTransparency = 1,
        }, {
            Header = Roact.createElement(Header, {
                Title = self.props.ActiveTab or "Home",
            }),

            ContentArea = Roact.createElement("Frame", {
                Size = UDim2.new(1, 0, 1, -60),
                Position = UDim2.new(0, 0, 0, 60),
                BackgroundTransparency = 1,
            }, {
                Padding = Roact.createElement("UIPadding", {
                    PaddingTop = Config.UI.Padding,
                    PaddingBottom = Config.UI.Padding,
                    PaddingLeft = Config.UI.Padding,
                    PaddingRight = Config.UI.Padding,
                }),

                -- Children will be rendered here
                Children = Roact.createFragment(self.props[Roact.Children])
            })
        })
    })
end

return Container
