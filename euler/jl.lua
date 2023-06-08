local Jl = setmetatable({}, { __name = "Jl"})

local function digitsnext(n, i)
    if n >= 10 ^ i then
        i = i + 1
        return i, math.tointeger(n // (10 ^ (i - 1)) % 10)
    end
end
function Jl.digits(n)
    return digitsnext, n, 0
end

local factorialcache = { [0] = 1, 1, 2, 6, 24, 120, 720, 5040, 40320, 362880 }
function Jl.factorial(n) return factorialcache[n] end

---@param pred fun(...): boolean
---@param itr function
function Jl.filter(pred, itr, t, k)
    return function()
        local v
        repeat
            k, v = itr(t, k)
            if k ~= nil and pred(v) then
                return k, v
            end
        until k == nil
    end
end

function Jl.map(fn, i, t, k)
    return function ()
        local v
        k, v = i(t, k)
        if k ~= nil then
            if v == nil then
                return fn(k)
            else
                return k, fn(v)
            end
        end
    end
end

Jl.println = print

function Jl.sum(...)
    local result = 0
    for k, v in ... do result = result + (v or k) end
    return result
end

local function unitrangenext(stop, i)
    i = i + 1
    if i <= stop then
        return i, i
    end
end
function Jl.UnitRange(start, stop)
    return unitrangenext, stop, start - 1
end

return Jl
