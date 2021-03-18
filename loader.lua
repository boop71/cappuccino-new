if not getgenv then
    _G.getgenv = function()
        return _G
    end
end
if not syn then
    if pebc_execute and not SENTINEL_V2 and not request then
        getgenv().syn = {
            request = function(t)
                return http_request(t)
            end
        }
        getgenv().isfile = function(t)
            return pcall(function()
                readfile(t)
            end)
        end
        getgenv().delfile = function() end
    elseif not pebc_executeand and not SENTINEL_V2 and request then
        getgenv().syn = {
            request = function(t)
                return request(t)
            end
        }
        getgenv().isfile = function(t)
            return pcall(function()
                readfile(t)
            end)
        end
        getgenv().delfile = function() end
    end
end
getgenv().json = {
    encode = function(v)
        return game:service('HttpService'):JSONEncode(v)
    end,
    decode = function(v)
        return game:service('HttpService'):JSONDecode(v)
    end,
}
local function instance(className,properties,children,funcs)
    local object = Instance.new(className,parent)

    for i, v in pairs(properties or {}) do
        object[i] = v
    end

    for i, self in pairs(children or {}) do
        self.Parent = object
    end

    for i,func in pairs(funcs or {}) do
        func(object)
    end

    return object
end
local function ts(object,tweenInfo,properties)
    if tweenInfo[2] and typeof(tweenInfo[2]) == 'string' then
        tweenInfo[2] = Enum.EasingStyle[ tweenInfo[2] ]
    end

    game:service('TweenService'):create(object, TweenInfo.new(unpack(tweenInfo)), properties):Play()
end
local function clone(self,newProperties,children)
    local clone = self:Clone()

    for property,value in next, (newProperties or {}) do
        clone[property] = value
    end

    for _,module in next, (children or {}) do
        module.Parent = clone
    end

    return clone
end
local function udim2(x1,x2,y1,y2)
    local t = tonumber
    return UDim2.new(t(x1),t(x2),t(y1),t(y2))
end
local function rgb(r,g,b)
    return Color3.fromRGB(r,g,b)
end
local function round(exact, quantum)
    local quant, frac = math.modf(exact/quantum)
    return quantum * (quant + (frac > 0.5 and 1 or 0))
end
local function border(self,borderSize,additional)
    borderSize = math.floor(borderSize / 2) == borderSize / 2 and borderSize or borderSize + 1

    local border = clone(self,{
        Parent = self,
        Position = udim2(0,borderSize/2,0,borderSize/2),
        Size = udim2(1,-borderSize,1,-borderSize)
    })

    if border:FindFirstChild('UICorner') then
        self.UICorner:GetPropertyChangedSignal('CornerRadius'):connect(function()
            border.UICorner.CornerRadius = UDim.new(self.UICorner.CornerRadius.Scale, self.UICorner.CornerRadius.Offset - 1)
        end)

        border.UICorner.CornerRadius = UDim.new(self.UICorner.CornerRadius.Scale, self.UICorner.CornerRadius.Offset - 1)
    end

    for property,value in next, (additional or {}) do
        border[property] = value
    end

    return border
end

pcall(function()
    game.CoreGui['cappuccino']:Destroy()
end)
local sgui = instance('ScreenGui', {
    Parent = game.CoreGui,
    Name = 'cappuccino'
})

local gFrame = instance('Frame', {
    Parent = sgui,
    Size = udim2(0,0,0,0),
    Position = udim2(0.5,0,0.5,0),
    BackgroundColor3 = rgb(255,255,255)
}, {
    instance('UICorner', {
        CornerRadius = UDim.new(1, 0)
    }),
    instance('UIGradient', {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, rgb(255, 58, 84)),
            ColorSequenceKeypoint.new(0.434, rgb(252, 255, 46)),
            ColorSequenceKeypoint.new(0.719, rgb(121, 147, 183)),
            ColorSequenceKeypoint.new(1, rgb(53, 90, 255))
        })
    }, nil, {
        function(self)
            spawn(function()
                while true do
                    ts(self, {0.2, 'Linear'}, {
                        Rotation = self.Rotation + 10
                    })
                    wait(0.2)
                end
            end)
        end
    })
})

local function getGame()
    local gameList = syn.request({
        Url = 'https://raw.githubusercontent.com/boop71/cappuccino-new/main/gameList.json',
        Method = 'GET'
    }).Body
    gameList = game.HttpService:JSONDecode(gameList)
    for a,v in next, gameList do
        if tostring(game.PlaceId) == a then
            return v
        end
    end
    return 'Universal aimbot and ESP'
end

local innerFrame = instance('Frame', {
    Parent = gFrame,
    Size = udim2(1,0,1,0),
    Position = udim2(0,0,0,0),
    BackgroundColor3 = rgb(255,255,255),
    ClipsDescendants = true
}, {
    instance('UICorner', {
        CornerRadius = UDim.new(0, 3)
    }),
    instance('UIGradient', {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, rgb(33,33,33)),
            ColorSequenceKeypoint.new(1, rgb(13,13,13))
        }),
        Rotation = 16,
    })
})

local title = instance('TextLabel', {
    Parent = innerFrame, 
    TextSize = 30,
    Text = 'Cappuccino',
    Size = udim2(1,0,1,0),
    TextColor3 = rgb(255,255,255),
    Font = 'GothamSemibold',
    BackgroundTransparency = 1,
    TextTransparency = 1,
}, nil, {
    function(self)
        delay(0.1, function()
            ts(self, {0.3, 'Sine'}, {
                TextTransparency = 0,
            })
        end)
    end
})

ts(gFrame, {0.3, 'Sine'}, {
    Size = udim2(0, 330, 0, 100),
    Position = udim2(0.5, -330/2, 0.5, -50),
})

wait(0.6)

ts(gFrame, {0.25, 'Sine'}, {
    Size = udim2(0, 338, 0, 108),
    Position = udim2(0.5, -338/2, 0.5, -108/2),
})
ts(innerFrame, {0.25, 'Sine'}, {
    Size = udim2(1, -8, 1, -8),
    Position = udim2(0, 4, 0, 4)
})
ts(gFrame.UICorner, {0.25, 'Sine'}, {
    CornerRadius = UDim.new(0, 3)
})

wait(0.3)

local button = instance('TextButton', {
    Parent = innerFrame,
    Size = udim2(1, 0, 1, 0),
    Text = getGame(),
    TextColor3 = rgb(255,255,255),
    TextTransparency = 1,
    BackgroundTransparency = 1,
    BackgroundColor3 = rgb(40,40,40),
    TextSize = 35,
    Font = 'Gotham',
    AutoButtonColor = false,
}, {
    instance('UICorner', {
        CornerRadius = UDim.new(0, 3)
    })
})
button.MouseEnter:connect(function()
    ts(button, {0.3, 'Sine'}, {
        BackgroundColor3 = rgb(70,70,70)
    })
end)
button.MouseLeave:connect(function()
    ts(button, {0.3, 'Sine'}, {
        BackgroundColor3 = rgb(40,40,40)
    })
end)
ts(title, {0.2, 'Sine'}, {
    TextSize = 10,
    TextTransparency = 1,
})
local realSize = game.TextService:GetTextSize(getGame(), 30, 'GothamSemibold', Vector2.new(math.huge, 0))
ts(gFrame, {0.15, 'Sine'}, {
    Size = udim2(0, realSize.X + 40, 0, 108),
    Position = udim2(0.5, -(realSize.X + 40)/2, 0.5, -108/2),
})
ts(button, {0.3, 'Sine'}, {
    Size = udim2(1,-8,1,-8),
    Position = udim2(0,4,0,4),
    TextSize = 28,
    TextTransparency = 0,
    BackgroundTransparency = 0,
})

button.MouseButton1Down:connect(function()
    ts(button, {0.3, 'Sine'}, {
        BackgroundTransparency = 1,
        TextTransparency = 1,
    })
    ts(innerFrame, {1.5, 'Sine'}, {
        BackgroundTransparency = 1,
    })
    ts(gFrame, {0.5, 'Exponential'}, {
        Size = udim2(1, 0, 0, 0),
        Position = udim2(0.5, -workspace.CurrentCamera.ViewportSize.X/2, 0.5, 0)
    })
    delay(1, function()
        ts(gFrame, {0.3, 'Sine'}, {
            BackgroundTransparency = 1,
        })
        wait(0.3)
        sgui:Destroy()
    end)
    loadstring(game:HttpGet('https://raw.githubusercontent.com/boop71/cappuccino-new/main/source.lua'))()
end)
