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
    elseif not pebc_execute and not SENTINEL_V2 and request then
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

pcall(function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/boop71/cappuccino-new/main/source.lua'))()
end)
