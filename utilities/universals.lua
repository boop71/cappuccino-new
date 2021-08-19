local http = game:service('HttpService')
local json = {encode = function(val)return http:JSONEncode(val)end,decode = function(val)return http:JSONDecode(val)end}
xpcall(function()
    return json.decode(readfile('cappuccino-data-'..game.PlaceId..'.json'))
end,function()
    local d = {
        os = {
            vrs = '0.7',
            key = '',
            toggle = 'LeftControl',
            skipwarning = false,
            fpscap = 60,
            counter = 0,
            theme = {
                r = 1,
                g = 0.254902,
                b = 0.254902
            },
        },
        u = {
            esp = {
                enabled = false,
                tracers = false,
                name = false,
                health = false,
                distance = false,
                teamcolor = false,
                teamcheck = false,
                maxdistance = 20000,
                infdistance = false,
                color = {
                    r = 1,
                    g = 0.5,
                    b = 0.5
                },
                outline = false,
                hpr = false,
                texttp = 1,
                tracertp = 1,
                vcheck = false,
                offset = -14,
                lineoffset = 1.05,
                boxenabled = false,
                boxfilled = false,
                boxtransparency = 1,
                highlightclosest = true,
                multithread = false,
            },
            aimbot = {
                enabled = false,
                bind = 'V',
                teamcheck = false,
                vcheck = false,
                smoothing = true,
                smoothpower = 0.04,
                fovenabled = false,
                fovsize = 200,
                fovcircle = {
                    filled = false,
                    numsides = 14,
                    color = {
                        r = 1,
                        g = 1,
                        b = 1,
                    },
                    transparency = 0.4,
                },
                mode = 'camera',
                tmode = 'hold',
                lockon = true,
                part = 'head',
            },
            exp = {
                bind = 'F6',
                enabled = false,
                size = 10,
                c = {
                    r = 1,
                    g = 0.5,
                    b = 0.5
                },
                teamcheck = false,
                teamcolor = false,
                rdistance = 5000,
                vcheck = false
            },
            crosshair = {
                visible = false,
                thickness = 0.5,
                size = 10,
                color = {
                    r = 1,
                    g = 1,
                    c = 1,
                    outline = {
                        r = 0,
                        g = 0,
                        b = 0,
                    },
                },
                alpha = 1,
                gap = 5,
                pos = 0,
                mouse = false,
                outline = {
                    enabled = false,
                    thickness = 5,
                    transparency = 1
                }
            },
        }
    }
    writefile('cappuccino-data-'..game.PlaceId..'.json',json.encode(d))
end)
local gd = json.decode(readfile('cappuccino-data-'..game.PlaceId..'.json'))
spawn(function()
    while true do 
        wait(0.2)
        writefile('cappuccino-data-'..game.PlaceId..'.json',json.encode(gd))
    end
end)

local esp = library:Page('ESP')
local function AET(name, value)
    esp:Toggle({text = name, state = gd.u.esp[value], callback = function(s)
        gd.u.esp[value] = s
    end})
end
AET('Enabled', 'enabled')
esp:ColorPicker({text = 'Color', color = Color3.new(gd.u.esp.color.r,gd.u.esp.color.g,gd.u.esp.color.b), callback = function(c)
    gd.u.esp.color = {
        r = c.r,
        g = c.g,
        b = c.b
    }
end})
AET('Highlight closest player', 'highlightclosest')
esp:Slider({text = 'Render distance', value = gd.u.esp.maxdistance, min = 750, max = 50000, float = 50, callback = function(v)
    gd.u.esp.maxdistance = v
end})
AET('Infinite render distance', 'infdistance')
AET('Visibility check', 'vcheck')
AET('Team color', 'teamcolor')
AET('Team check', 'teamcheck')
AET('Tracers', 'tracers')
esp:Slider({text = 'Tracer transparency', min = 0, max = 1, float = 0.005, value = gd.u.esp.tracertp, callback = function(v)
    gd.u.esp.tracertp = v
end})
AET('Boxes', 'boxenabled')
esp:Slider({text = 'Box transparency', min = 0, max = 1, float = 0.005, value = gd.u.esp.boxtransparency, callback = function(v)
    gd.u.esp.boxtransparency = v
end})
AET('Show name', 'name')
AET('Show display name', 'dnamesupport')
AET('Show health', 'health')
AET('Show distance', 'distance')
AET('Text outline', 'outline')
esp:Slider({text = 'Text transparency', min = 0, max = 1, float = 0.005, value = gd.u.esp.texttp, callback = function(v)
    gd.u.esp.texttp = v
end})
esp:Slider({text = 'Offset', min = -50, max = 50, value = gd.u.esp.offset, callback = function(v)
    gd.u.esp.offset = v
end})
function percent(a,b)
    return (a*100)/b
end
function vcheck(name)
    local player = game:service('Players').LocalPlayer
    local c2 = workspace.CurrentCamera.CFrame.Position
    local p2 = game:service('Players')[name]
    local cf = CFrame.new(c2,p2.Character.HumanoidRootPart.Position).lookVector*1000000
    local info = RaycastParams.new()
    local t = {}
    for a,v in next, player.Character:GetChildren() do
        table.insert(t,v)
    end
    info.FilterDescendantsInstances = t
    local result = workspace:Raycast(c2,cf,info)
    if result then
        if result.Instance:IsDescendantOf(p2.Character) then 
            return true
        end
    end
    return false
end
local player = game:service('Players').LocalPlayer
local mouse = player:GetMouse()
local catch = {}
function addesp(name)
    local v = game:service('Players')[name]
    local function drawing(a,b)
        local d = Drawing.new(a)
        for a,v in next, b do
            d[a] = v
        end
        return d
    end
    local data = {
        username = name,
        esp = {
            line = drawing('Line',{Visible = false,Thickness = 1.5,Color = Color3.new(1,1,1)}),
            box = drawing('Square',{Visible = false,Thickness = 1.5,Color = Color3.new(1,1,1)}),
            name = drawing('Text',{Visible = false,Size = 17,Color = Color3.new(1,1,1),Text = 'asd',Center = true,Text = v.Name}),
            health = drawing('Text',{Visible = false,Size = 17,Color = Color3.new(1,1,1),Text = 'asd',Center = true}),
            dist = drawing('Text',{Visible = false,Size = 17,Color = Color3.new(1,1,1),Text = 'asd',Center = true}),
        }
    }
    local function disable()
        for a,v in next, data.esp do
            v.Visible = false
        end
    end
    local function remove()
        for a,v in next, data.esp do
            v:Remove()
        end
    end
    local function getclosest()
        local player,target,closestdist = game:service('Players').LocalPlayer,nil,math.huge
        for a,v in next, game:service('Players'):GetChildren() do 
            if v ~= player and v.Character and v.Character:FindFirstChild('HumanoidRootPart') then
                local a,a2 = workspace.CurrentCamera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                if a2 then
                    if (Vector2.new(mouse.X,mouse.Y+35)-Vector2.new(a.X,a.Y)).magnitude < closestdist then
                        closestdist = (Vector2.new(mouse.X,mouse.Y+35)-Vector2.new(a.X,a.Y)).magnitude
                        target = v
                    end
                end
            end
        end
        return target
    end
    local function update()
        local cam = workspace.CurrentCamera 
        local a,a2 = cam:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
        local dist = (CFrame.new(cam.CFrame.Position,v.Character.HumanoidRootPart.Position).Position-v.Character.HumanoidRootPart.Position).magnitude
        local xs = cam.ViewportSize.X / dist
        local ys = cam.ViewportSize.Y / dist
        data.esp.name.Visible = gd.u.esp.name
        data.esp.dist.Visible = gd.u.esp.distance
        data.esp.health.Visible = gd.u.esp.health
        local p = {
            function()
                return Vector2.new(a.X,((a.Y-10)+gd.u.esp.offset))
            end,
            function()
                return Vector2.new(a.X,((a.Y+5)+gd.u.esp.offset))
            end,
            function()
                return Vector2.new(a.X,((a.Y+20)+gd.u.esp.offset))
            end,
        }
        local function gettext()
            local d = {0,0,0}
            if gd.u.esp.name then
                d[1] = 1
            end
            if gd.u.esp.distance then
                d[2] = 1
            end
            if gd.u.esp.health then
                d[3] = 1
            end
            local d2 = ''
            for a,v in next, d do
                d2 = d2 .. v
                if d[a+1] then
                    d2 = d2..','
                end
            end
            return d2
        end
        if gd.u.esp.boxenabled then
            data.esp.box.Visible = true
            data.esp.box.Filled = gd.u.esp.boxfilled
            data.esp.box.Transparency = gd.u.esp.boxtransparency
            data.esp.box.Size = Vector2.new(xs*1.8,ys*4.4)
            data.esp.box.Position = Vector2.new(((a.X - xs*1.8) + (xs*1.8 / 2)),(a.Y - ys * 2))
        else
            data.esp.box.Visible = false
        end
        data.esp.line.From = Vector2.new(cam.ViewportSize.X/2,cam.ViewportSize.Y-100)
        data.esp.line.To = gd.u.esp.boxenabled and Vector2.new(a.X,(data.esp.box.Position.Y + data.esp.box.Size.Y)) or Vector2.new(a.X,a.Y)
        data.esp.health.Text = not gd.u.esp.hpr and tostring(math.floor(v.Character.Humanoid.Health))..'/'..tostring(math.floor(v.Character.Humanoid.MaxHealth)) or tostring(math.floor(percent(v.Character.Humanoid.Health,v.Character.Humanoid.MaxHealth)))..'%'
        data.esp.dist.Text = tostring(math.floor((game:service('Players').LocalPlayer.Character.HumanoidRootPart.Position-v.Character.HumanoidRootPart.Position).magnitude))
        if gd.u.esp.dnamesupport then
            data.esp.name.Text = v.DisplayName
        else
            data.esp.name.Text = v.Name
        end
        data.esp.name.Outline = gd.u.esp.outline
        data.esp.dist.Outline = gd.u.esp.outline
        data.esp.health.Outline = gd.u.esp.outline
        data.esp.name.Transparency = gd.u.esp.texttp
        data.esp.dist.Transparency = gd.u.esp.texttp
        data.esp.health.Transparency = gd.u.esp.texttp
        data.esp.line.Transparency = gd.u.esp.tracertp
        data.esp.line.Visible = gd.u.esp.tracers
        data.esp.box.Transparency = gd.u.esp.boxtransparency
        if not gd.u.esp.highlightclosest then
            for a,v2 in next, data.esp do
                if not gd.u.esp.teamcolor then
                    local c = gd.u.esp.color
                    v2.Color = Color3.new(c.r,c.g,c.b)
                else
                    local c = v.TeamColor
                    v2.Color = Color3.new(c.r,c.g,c.b)
                end
            end
        else
            if getclosest().Name == v.Name then
                for a,v in next, data.esp do
                    v.Color = Color3.new(1,1,1)
                end
            else
                for a,v2 in next, data.esp do
                    if not gd.u.esp.teamcolor then
                        local c = gd.u.esp.color
                        v2.Color = Color3.new(c.r,c.g,c.b)
                    else
                        local c = v.TeamColor
                        v2.Color = Color3.new(c.r,c.g,c.b)
                    end
                end
            end
        end
        if gettext() == '1,0,0' then
            data.esp.name.Position = p[2]()
        elseif gettext() == '0,1,0' then
            data.esp.dist.Position = p[2]()
        elseif gettext() == '0,0,1' then
            data.esp.health.Position = p[2]()
        elseif gettext() == '1,1,0' then
            data.esp.name.Position = p[2]()
            data.esp.dist.Position = p[3]()
        elseif gettext() == '0,1,1' then
            data.esp.dist.Position = p[2]()
            data.esp.health.Position = p[3]()
        elseif gettext() == '1,0,1' then
            data.esp.name.Position = p[2]()
            data.esp.health.Position = p[3]()
        elseif gettext() == '1,1,1' then
            data.esp.name.Position = p[1]()
            data.esp.dist.Position = p[2]()
            data.esp.health.Position = p[3]()
        end
    end
    local d 
    local callback = function()
        local function on()
            update()
        end
        local attempt = pcall(function()
            if gd.u.esp.enabled then
                if not gd.u.esp.showdead then
                    
                end
                if v.Character and v.Character:FindFirstChild('HumanoidRootPart') then
                    local player = game:service('Players').LocalPlayer
                    local a,a2 = workspace.CurrentCamera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                    if a2 then
                        local dist = not gd.u.esp.infdistance and gd.u.esp.maxdistance or math.huge
                        if (v.Character.HumanoidRootPart.Position-player.Character.HumanoidRootPart.Position).magnitude < dist then
                            if gd.u.esp.teamcheck then
                                if tostring(v.Team) == tostring(player.Team) then
                                    if gd.u.esp.vcheck then
                                        if vcheck(v.Name) then
                                            on()
                                        else
                                            disable()
                                        end
                                    else
                                        on()
                                    end
                                else
                                    disable()
                                end
                            else
                                if gd.u.esp.vcheck then
                                    if vcheck(v.Name) then
                                        on()
                                    else
                                        disable()
                                    end
                                else
                                    on()
                                end
                            end
                        else
                            disable()
                        end
                    else
                        disable()
                    end
                end
            else
                disable()
            end
        end)
        if not attempt then
            disable()
        end
    end
    spawn(function()
        repeat
            wait(1)
            if gd.u.esp.multithread then
                local newrender
                newrender = game:service('RunService').Stepped:connect(function()
                    if not game:service('Players'):FindFirstChild(v.Name) then
                        print('removing '..v.Name)
                        pcall(remove)
                        return newrender:Disconnect() 
                    end
                    if not gd.u.esp.multithread then
                        return newrender:Disconnect()
                    end
                    pcall(callback)
                end)
            end
        until false
    end)
    table.insert(catch,{main = callback,user = v.Name,destroy = remove})
end
game:service('RunService').Stepped:connect(function()
    if not gd.u.esp.multithread then
        for a,v in next, catch do
            if not game:service('Players'):FindFirstChild(v.user) then
                print('removing '..v.user)
                pcall(v.destroy)
                table.remove(catch,a)
            end
            pcall(v.main)
        end
    end
end)
for a,v in next, game:service('Players'):GetChildren() do
    if v ~= game:service('Players').LocalPlayer then
        addesp(v.Name)
    end
end
game:service('Players').PlayerAdded:connect(function(v)
    addesp(v.Name)
end)
local aimbot = library:Page('Aimbot')
aimbot:Toggle({text = 'Enabled',state = gd.u.aimbot.enabled,callback = function(s)
    gd.u.aimbot.enabled = s
end})
local aimbotUpdate = setmetatable({},{
    __newindex = function(t,v,k)
        gd.u.aimbot.bind = k
    end
})
aimbot:Keybind({text = 'Key',key = Enum.KeyCode[gd.u.aimbot.bind],callback = function()
    tick()
end,newCallback = function(s)
    aimbotUpdate[#aimbotUpdate+1] = tostring(s):split('.')[3]
end})
aimbot:Dropdown({text = 'Type',value = gd.u.aimbot.mode,values = {'mouse','camera'},callback = function(o)
    gd.u.aimbot.mode = o
end})
aimbot:Toggle({text = 'Lock on',state = gd.u.aimbot.lockon,callback = function(s)
    gd.u.aimbot.lockon = s
end})
aimbot:Dropdown({text = 'Aim part',value = gd.u.aimbot.part,values = {'head','torso'},callback = function(o)
    gd.u.aimbot.part = o
end})
aimbot:Dropdown({text = 'Toggling',value = gd.u.aimbot.tmode,values = {'toggle','hold'},callback = function(o)
    gd.u.aimbot.tmode = o
end})
aimbot:Toggle({text = 'Team check',state = gd.u.aimbot.teamcheck,callback = function(s)
    gd.u.aimbot.teamcheck = s
end})
aimbot:Toggle({text = 'Visibility check',state = gd.u.aimbot.vcheck,callback = function(s)
    gd.u.aimbot.vcheck = s
end})
aimbot:Slider({text = 'Smoothing', value = gd.u.aimbot.smoothpower*100, min = 0, max = 10, float = 0.5, callback = function(v)
    v = tonumber(v ~= 10 and '0.0'..tostring(v) or 0.1)
    gd.u.aimbot.smoothpower = v
    if v == 0 then
        gd.u.aimbot.smoothing = false
    else
        gd.u.aimbot.smoothing = true
    end
end})
local fov2 = Drawing.new('Circle')
fov2.Thickness = 1.4
fov2.NumSides = gd.u.aimbot.fovcircle.numsides
fov2.Radius = gd.u.aimbot.fovsize
fov2.Filled = gd.u.aimbot.fovcircle.filled
fov2.Color = Color3.new(gd.u.aimbot.fovcircle.color.r,gd.u.aimbot.fovcircle.color.g,gd.u.aimbot.fovcircle.color.b)
fov2.Visible = gd.u.aimbot.fovenabled
fov2.Transparency = 0.65
local mouse = game:service('Players').LocalPlayer:GetMouse()
mouse.Move:connect(function()
    fov2.Position = Vector2.new(mouse.X,mouse.Y+35)
end)
aimbot:Toggle({text = 'FOV', state = gd.u.aimbot.fovenabled, callback = function(s)
    gd.u.aimbot.fovenabled = s
    fov2.Visible = s
end})
aimbot:Slider({text = 'Size',value = gd.u.aimbot.fovsize,min = 20,max = 600,callback = function(v)
    gd.u.aimbot.fovsize = v
    fov2.Radius = v
end})
aimbot:ColorPicker({text = 'Color',color = Color3.new(gd.u.aimbot.fovcircle.color.r,gd.u.aimbot.fovcircle.color.g,gd.u.aimbot.fovcircle.color.b),callback = function(c)
    gd.u.aimbot.fovcircle.color = {
        c.r,
        c.g,
        c.b
    }
    fov2.Color = c
end})
aimbot:Slider({text = 'Num sides',value = gd.u.aimbot.fovcircle.numsides,min = 3,max = 120,callback = function(v)
    gd.u.aimbot.fovcircle.numsides = v
    fov2.NumSides = v
end})
local function service(a) 
    return game:service(a) 
end
local keyholding = false
local uis = service('UserInputService')
uis.InputBegan:connect(function(k,t)
    if t then
        return
    end
    pcall(function()
        if gd.u.aimbot.tmode == 'hold' then
            if k.KeyCode == Enum.KeyCode[gd.u.aimbot.bind] then
                keyholding = true
            end
        else
            if k.KeyCode == Enum.KeyCode[gd.u.aimbot.bind] then
                keyholding = not keyholding
            end
        end
    end)
end)
uis.InputEnded:connect(function(k,t)
    if t then
        return
    end
    pcall(function()
        if gd.u.aimbot.tmode == 'hold'then
            if k.KeyCode == Enum.KeyCode[gd.u.aimbot.bind] then
                keyholding = false
            end
        end
    end)
end)
local player = service('Players').LocalPlayer 
local mouse = player:GetMouse()
function getclosest()
    local player,target,closestdist = game:service('Players').LocalPlayer,nil,math.huge
    for a,v in next, game:service('Players'):GetChildren() do 
        if v ~= player and v.Character and v.Character:FindFirstChild('HumanoidRootPart') then
            local a,a2 = workspace.CurrentCamera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if a2 then
                if gd.u.aimbot.fovenabled then
                    if (Vector2.new(mouse.X,mouse.Y)-Vector2.new(a.X,a.Y)).magnitude < gd.u.aimbot.fovsize then
                        if (Vector2.new(mouse.X,mouse.Y)-Vector2.new(a.X,a.Y)).magnitude < closestdist then
                            if gd.u.aimbot.vcheck then
                                if vcheck(v.Name) then
                                    if gd.u.aimbot.teamcheck then
                                        if tostring(v.Team) ~= tostring(service('Players').LocalPlayer.Team) then
                                            closestdist = (Vector2.new(mouse.X,mouse.Y+35)-Vector2.new(a.X,a.Y)).magnitude
                                            target = v
                                        end
                                    else
                                        closestdist = (Vector2.new(mouse.X,mouse.Y+35)-Vector2.new(a.X,a.Y)).magnitude
                                        target = v
                                    end
                                end
                            else
                                if gd.u.aimbot.teamcheck then
                                    if tostring(v.Team) ~= tostring(service('Players').LocalPlayer.Team) then
                                        closestdist = (Vector2.new(mouse.X,mouse.Y+35)-Vector2.new(a.X,a.Y)).magnitude
                                        target = v
                                    end
                                else
                                    closestdist = (Vector2.new(mouse.X,mouse.Y+35)-Vector2.new(a.X,a.Y)).magnitude
                                    target = v
                                end
                            end
                        end
                    end
                else
                    if (Vector2.new(mouse.X,mouse.Y)-Vector2.new(a.X,a.Y)).magnitude < closestdist then
                        if gd.u.aimbot.vcheck then
                            if vcheck(v.Name) then
                                if gd.u.aimbot.teamcheck then
                                    if tostring(v.Team) ~= tostring(service('Players').LocalPlayer.Team) then
                                        closestdist = (Vector2.new(mouse.X,mouse.Y+35)-Vector2.new(a.X,a.Y)).magnitude
                                        target = v
                                    end
                                else
                                    closestdist = (Vector2.new(mouse.X,mouse.Y+35)-Vector2.new(a.X,a.Y)).magnitude
                                    target = v
                                end
                            end
                        else
                            if gd.u.aimbot.teamcheck then
                                if tostring(v.Team) ~= tostring(service('Players').LocalPlayer.Team) then
                                    closestdist = (Vector2.new(mouse.X,mouse.Y+35)-Vector2.new(a.X,a.Y)).magnitude
                                    target = v
                                end
                            else
                                closestdist = (Vector2.new(mouse.X,mouse.Y+35)-Vector2.new(a.X,a.Y)).magnitude
                                target = v
                            end
                        end
                    end
                end
            end
        end
    end
    return target
end
function move(n)
    pcall(function()
        workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position,n)
    end)
end
function smoothmove(n,s)
    local tw = game:service('TweenService'):create(workspace.CurrentCamera,TweenInfo.new(tonumber(s),Enum.EasingStyle.Linear),{CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position,n)})
    tw:Play()
    local t = {}
    function t:c()
        tw:Pause() 
    end
    return t
end
local tween
service('RunService').Stepped:connect(function()
    if gd.u.aimbot.lockon then
        if not keyholding then
            shared.target = getclosest()
        end
    else
        shared.target = getclosest()
    end
end)

local mouse2Down = false
local mouse = game:service('Players').LocalPlayer:GetMouse()
mouse.Button2Down:connect(function()
    mouse2Down = true
end)
mouse.Button2Up:connect(function()
    mouse2Down = false
end)

service('RunService').Stepped:connect(function()
    if gd.u.aimbot.enabled then
        if keyholding then
            local targetpart
            print(gd.u.aimbot.part)
            if gd.u.aimbot.part == 'torso' then
                targetpart = shared.target.Character.HumanoidRootPart
            elseif gd.u.aimbot.part == 'head' then
                targetpart = shared.target.Character.Head
            end
            local a,a2 = workspace.CurrentCamera:WorldToViewportPoint(targetpart.Position)
            if gd.u.aimbot.mode == 'camera' then
                if gd.u.aimbot.smoothing then
                    tween = smoothmove(targetpart.Position,0.04)
                else
                    move(targetpart.Position)
                end
            elseif gd.u.aimbot.mode == 'mouse' then
                if a2 then
                    if not mouse2Down then
                        mousemoveabs(a.X + 3, a.Y)
                    end
                end
            end
        else
            pcall(function()
                tween:c()
            end)
        end
    end
end)
--[[
local function draw(i, k)
    local d = Drawing.new(i)
    for a,v in next, k do
        d[a] = v
    end
    return d
end

local outline = {
    up = draw('Line', {}),
    left = draw('Line', {}),
    right = draw('Line', {}),
    down = draw('Line', {}),
}

local cross = {
    up = draw('Line', {}),
    left = draw('Line', {}),
    right = draw('Line', {}),
    down = draw('Line', {}),
}

local ut
ut = {
    gc = function()
        local mouse = game:service('Players').LocalPlayer:GetMouse()
        return not gd.u.crosshair.mouse and Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2) or Vector2.new(mouse.X, mouse.Y) + Vector2.new(0, 36)
    end,
    gs = function(a, i, g)
        local c = ut.gc()
        local xs, ys, xs2, ys2 = (a == 0 and c.X - (g + i) or a == 1 and c.X + (g + i) or c.X), (a == 3 and c.Y - (g + i) or a == 4 and c.Y + (g + i) or c.Y), (a == 0 and c.X - g or a == 1 and c.X + g or c.X), (a == 3 and c.Y - g or a == 4 and c.Y + g or c.Y)
        return {Vector2.new(xs, ys), Vector2.new(xs2, ys2)}
    end,
    up = function(d, i, k)
        cross[d].From = i
        cross[d].To = k
    end,
    up2 = function(d, i, k)
        outline[d].From = i
        outline[d].To = k
    end,
    f = function(t)
        return {t.r, t.g, t.b}
    end
}

game:service('RunService').Stepped:connect(function()
    for a,v in next, outline do        
        v.Visible = gd.u.crosshair.outline.enabled
        v.Thickness = cross[a].Thickness + gd.u.crosshair.outline.thickness
        v.Transparency = gd.u.crosshair.outline.transparency
        local c = gd.u.crosshair.color.outline

        v.Color = Color3.new(c.r, c.g, c.b)
    end

    local t = gd.u.crosshair.outline.thickness
    outline.up.From = cross.up.From - Vector2.new(0, t * 0.6); outline.up.To = cross.up.To + Vector2.new(0, t * 0.6)
    outline.down.From = cross.down.From + Vector2.new(0, t * 0.6); outline.down.To = cross.down.To - Vector2.new(0, t * 0.6)
    outline.left.From = cross.left.From - Vector2.new(t * 0.6, 0); outline.left.To = cross.left.To + Vector2.new(t * 0.6, 0)
    outline.right.From = cross.right.From + Vector2.new(t * 0.6, 0); outline.right.To = cross.right.To - Vector2.new(t * 0.6, 0)
end)


local w = library:Page('Crosshair')
w:Toggle({text = 'Visible', state = gd.u.crosshair.visible, callback = function(s)
    gd.u.crosshair.visible = s
end})
w:Slider({text = 'Thickness', value = gd.u.crosshair.thickness, min = 0.5, max = 10, float = 0.1, callback = function(v)
    gd.u.crosshair.thickness = v
end})
w:Slider({text = 'Gap', value = gd.u.crosshair.gap, min = 0, max = 20, float = 0.5, callback = function(v)
    gd.u.crosshair.gap = v
end})
w:Slider({text = 'Size', value = gd.u.crosshair.size, min = 1, max = 30, foat = 1, callback = function(v)
    gd.u.crosshair.size = v
end})
w:Slider({text = 'Alpha', value = gd.u.crosshair.alpha, min = 0, max = 1, float = 0.01, callback = function(v)
    gd.u.crosshair.alpha = v
end})
w:Toggle({text = 'Follow mouse', state = gd.u.crosshair.mouse, callback = function(s)
    gd.u.crosshair.mouse = s
end})
w:ColorPicker({text = 'Color', colour = ut.f(gd.u.crosshair.color), callback = function(f)
    local c = gd.u.crosshair.color; c.r = f.r; c.g = f.g; c.b = f.b
end})
w:Toggle({text = 'Outline', state = gd.u.crosshair.outline.enabled, callback = function(s)
    gd.u.crosshair.outline.enabled = s
end})
w:Slider({text = 'Outline size', value = gd.u.crosshair.outline.thickness, min = 3, max = 10, float = 0.01, callback = function(v)
    gd.u.crosshair.outline.thickness = v
end})
w:Slider({text = 'Outline alpha', value = gd.u.crosshair.outline.transparency, min = 0.1, max = 1, float = 0.1, callback = function(v)
    gd.u.crosshair.outline.transparency = v
end})
w:ColorPicker({text = 'Outline colour', colour = ut.f(gd.u.crosshair.color.outline), callback = function(f)
    local c = gd.u.crosshair.color.outline; c.r = f.r; c.g = f.g; c.b = f.b
end})

local function update()
    ut.up('up', ut.gs(3, gd.u.crosshair.size, gd.u.crosshair.gap)[1], ut.gs(3, gd.u.crosshair.size, gd.u.crosshair.gap)[2])
    ut.up('down', ut.gs(4, gd.u.crosshair.size, gd.u.crosshair.gap)[1], ut.gs(4, gd.u.crosshair.size, gd.u.crosshair.gap)[2])
    ut.up('left', ut.gs(0, gd.u.crosshair.size, gd.u.crosshair.gap)[1], ut.gs(0, gd.u.crosshair.size, gd.u.crosshair.gap)[2])
    ut.up('right', ut.gs(1, gd.u.crosshair.size, gd.u.crosshair.gap)[1], ut.gs(1, gd.u.crosshair.size, gd.u.crosshair.gap)[2])

    for a,v in next, cross do
        v.Transparency = gd.u.crosshair.alpha
        v.Visible = gd.u.crosshair.visible
        v.Thickness = gd.u.crosshair.thickness
        v.Color = Color3.new(gd.u.crosshair.color.r, gd.u.crosshair.color.g, gd.u.crosshair.color.b)
    end
end

game:service('RunService').Stepped:connect(update)
]]
