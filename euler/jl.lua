local Jl = setmetatable({}, { __name = "Jl" })

function Jl.all(fn, ...)
    for k, v in ... do
        if v == nil then v = k end
        if not fn(v) then return false end
    end
    return true
end

function Jl.any(fn, ...)
    for k, v in ... do
        if v == nil then v = k end
        if fn(v) then return true end
    end
    return false
end

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

function Jl.get(t, k, v)
    local fn
    if type(t) == "function" then
        fn, t, k = t, k, v
    end
    if t[k] == nil then
        if fn then v = fn(k) end
        t[k] = v
    end
    return t[k]
end

local function keysnext(t, k) return (next(t, k)) end
function Jl.keys(t)
    return keysnext, t, nil
end

function Jl.map(fn, i, t, k)
    return function()
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
