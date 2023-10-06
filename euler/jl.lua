local Jl = setmetatable({
    Primes = {}
}, { __name = "Jl" })

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

local function countfromnext(step, i)
    return step + i
end
function Jl.countfrom(start, step)
    step = step or 1
    return countfromnext, step, start - step
end

local function digitsnext(n, i)
    if n >= 10 ^ i then
        i = i + 1
        return i, math.tointeger(n // (10 ^ (i - 1)) % 10)
    elseif i == 0 and n == 0 then
        return 1, 0
    end
end
---@param n integer
---@return (fun(n: integer, i: integer): integer, integer), integer, integer
function Jl.digits(n)
    return digitsnext, n, 0
end

local factorialcache = { [0] = 1, 1, 2, 6, 24, 120, 720, 5040, 40320, 362880,
    39916800, 479001600, 6227020800, 87178291200, 1307674368000, 20922789888000,
    355687428096000, 6402373705728000, 121645100408832000, 2432902008176640000 }
---@param n integer
function Jl.factorial(n) return factorialcache[n] end

---@param pred fun(...): boolean
---@param itr function
function Jl.filter(pred, itr, t, k)
    return function()
        local v
        repeat
            k, v = itr(t, k)
            if k ~= nil and pred(v == nil and k or v) then
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

---@param x number
function Jl.Primes.isprime(x)
    if x == 1 then
        return false
    elseif x == 2 then
        return true
    elseif x % 2 == 0 then
        return false
    end
    for i = 3, math.sqrt(x), 2 do
        if x % i == 0 then return false end
    end
    return true
end

---@param x number
function Jl.isqrt(x)
    return math.floor(math.sqrt(x))
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

function Jl.prod(...)
    local result = 1
    for k, v in ... do result = result * (v or k) end
    return result
end

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
---@param start integer
---@param stop integer
function Jl.UnitRange(start, stop)
    return unitrangenext, stop, start - 1
end

return Jl
