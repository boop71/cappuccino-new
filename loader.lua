if not getgenv then
    _G.getgenv = function()
        return _G
    end
end
if not syn then
    getgenv().syn = {
        request = function(t)
            return http_request(t)
        end,
        protect_gui = function(object) end
    }
    getgenv().isfile = function(t)
        return pcall(function()
            readfile(t)
        end)
    end
    getgenv().delfile = function() end
end

pcall(function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/boop71/cappuccino-new/main/source.lua'))()
end)
