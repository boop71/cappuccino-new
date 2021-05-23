if not getgenv then
    _G.getgenv = function()
        return _G
    end
end
if not syn then
    if not pebc_executeand and not SENTINEL_V2 and request then
        getgenv().syn = {
            request = function(t)
                return request(t)
            end,
            protect_gui = function(inst)
                print('dm boop71 if you have krnl docs plez i cant find them ;(')
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

local function load()
    local d = loadstring(game:HttpGet('https://raw.githubusercontent.com/boop71/cappuccino-new/main/source.lua'))()
    repeat
        wait()
    until d == 'a'
    return 'l'
end

pcall(function()
    game:service('CoreGui')['cappuccinoL']:Destroy()
end)
local sgui = instance('ScreenGui', {
    Name = 'cappuccinoL',
})
syn.protect_gui(sgui)
sgui.Parent = game:service('CoreGui')

local mainFrame = instance('Frame', {
    Parent = sgui, 
    Size = udim2(0, 0, 0, 0),
    Position = udim2(0.5, 0, 0.5, 0),
    ZIndex = 10,
    BackgroundColor3 = rgb(40, 40, 40)
}, {
    instance('ImageLabel', {
        Size = udim2(1, 0, 1, 0),
        Image = 'rbxassetid://6840808068',
        BackgroundTransparency = 1,
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        Name = 'logo',
        ZIndex = 10
    }),
    instance('UICorner', {
        CornerRadius = UDim.new(1, 0),
        Name = 'rounding'
    }),
})

ts(mainFrame, {0.4, 'Sine'}, {
    Size = udim2(0, 150, 0, 150),
    Position = udim2(0.5, -75, 0.5, -75)
})

wait(1.2)
ts(mainFrame, {0.3, 'Sine'}, {
    Size = udim2(0, 500, 0, 350),
    Position = udim2(0.5, -250, 0.5, -175),
    BackgroundColor3 = rgb(30, 30, 30)
})
ts(mainFrame.rounding, {0.6, 'Sine'}, {
    CornerRadius = UDim.new(0, 4)
})
mainFrame.logo.Size = udim2(0, 150, 0, 150)
mainFrame.logo.Position = udim2(0.5, -75, 0.5, -75)

local attempt = load()
repeat
    wait()
until attempt

ts(mainFrame.logo, {0.3, 'Sine'}, {
    ImageColor3 = rgb(0, 255, 20)
})
delay(0.5, function()
    ts(mainFrame.logo, {0.3, 'Sine'}, {
        ImageTransparency = 1
    })
    ts(mainFrame, {1, 'Sine'}, {
        BackgroundTransparency = 1
    })
    delay(1.2, function()
        sgui:Destroy()
    end)
end)