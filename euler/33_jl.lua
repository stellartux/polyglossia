#!/usr/bin/env lua
local _ = #{} --[[

then(x) = true
then(::Nothing) = false
then(b::Bool) = b
Base.:*(x, ::typeof(then)) = then(x)

#=]]

---@param n integer
---@return integer[]
local function digits(n)
    local result = {}
    repeat
        table.insert(result, n % 10)
        n = n // 10
    until n == 0
    return result
end

local function foldr(fn, xs)
    local result = xs[#xs]
    for i = #xs - 1, 1, -1 do
        result = fn(xs[i], result)
    end
    return result
end

local function filter(pred, i, t, k)
    return function()
        while true do
            k = i(t, k)
            if not k or pred(k) then
                return k
            end
        end
    end
end

local function gcd(a, b)
    if b == 0 then
        return a
    else
        return gcd(b, a % b)
    end
end

local function map(fn, i, t, k)
    return function()
        k = i(t, k)
        if k ~= nil then return k, fn(k) end
    end
end

local println = print

local Rational = setmetatable({
    __eq = function(self, other)
        return self[1] == other[1] and self[2] == other[2]
    end,
    __mul = function(self, other)
        local Rational = getmetatable(self)
        if type(other) == "number" then
            return Rational(self[1] * other, self[2])
        else
            return Rational(self[1] * other[1], self[2] * other[2])
        end
    end,
    __tostring = function(self)
        return ("%d//%d"):format(table.unpack(self))
    end
}, {
    __call = function(self, n, d)
        local g = gcd(n, d)
        return setmetatable({ n // g, d // g }, self)
    end
})
Rational.__index = Rational

local function prod(...)
    local result = Rational(1, 1)
    for k, v in ... do
        result = result * (v or k)
    end
    return result
end

local function unitrangenext(stop, i)
    i = i + 1
    if i <= stop then return i end
end
local function UnitRange(start, stop)
    return unitrangenext, stop, start - 1
end

-- code visible to Julia and Lua =#

function fromdigits(ds)
    return foldr(function(a, b) return a + 10 * b end, ds)
end

function findnot(t, x)
    if t[1] == x then
        return t[2]
    else
        return t[1]
    end
end

function findmatch(left, right)
    if left[1] == right[1] then
        return left[1]
    elseif left[1] == right[2] then
        return left[1]
    elseif left[2] == right[1] then
        return left[2]
    elseif left[2] == right[2] then
        return left[2]
    end
end

println(prod(map(function(numer)
        return prod(map(function(denom)
                local fraction = Rational(numer, denom)
                local nds = digits(numer)
                local dds = digits(denom)
                local d = findmatch(nds, dds)
                if (d)then
                    if fraction == Rational(findnot(nds, d), findnot(dds, d)) then
                        return fraction
                    end
                end
                return 1
            end,
            UnitRange(numer + 1, 99)))
    end,
    filter(function(numer) return numer % 10 > 0 end,
        UnitRange(11, 98)))))
