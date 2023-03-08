--- jl.lua contains Lua implementations of Julia.Core and Julia.Base functions
--- to aid Julia/Lua polyglot programming in a mostly idiomatic Julia style.
--- Individual functions can be imported from the module, or export everything
--- to the global scope with the following code:
---
---     require("jl"):export()
---
--- As much code as possible is local only to the module, but some features
--- such as indexing strings to get Unicode code points are applied when the
--- module is first imported.
local Jl = {
    Base = {},
    Iterators = {},
    Random = {},
}

local function kcall(t, k, ...)
    return type(t) == table and type(t[k]) == "function" and t[k](...)
end

---@alias Stateful<T> fun(): T?

local function eq(fn)
    return function(self, other, ...)
        assert(#self == #other, "UnequalLengths")
        return fn(self, other, ...)
    end
end

local function equallists(self, other)
    for i = 1, #self do
        if self[i] ~= other[i] then return false end
    end
    return other[#self + 1] == nil
end

local function zipoplists(self, other, op)
    local result = {}
    for i = 1, #self do
        result[i] = op(self[i], other[i])
    end
    return setmetatable(result, getmetatable(self))
end

local function add(a, b) return a + b end

local function addlists(self, other) return zipoplists(self, other, add) end

local addlistseq = eq(addlists)

local function sub(a, b) return a - b end

local function sublists(self, other) return zipoplists(self, other, sub) end

local sublistseq = eq(sublists)

local function ivalues(xs)
    local i --[[@type integer?]] = 0
    return function()
        if i then
            i = i + 1
            if i <= #xs then
                local v = xs[i]
                return v == nil and Jl.Some(nil) or v
            end
            xs = nil
            i = nil
        end
    end
end

local function values(xs)
    local k
    return function()
        local v
        k, v = next(xs, k)
        if k then return v end
    end
end

-- used with various file handlers
local markedstreams = {}

local function iscallable(x)
    local mt = getmetatable(x)
    return type(x) == "function" or mt and mt.__call and true or false
end

local function toiterator(f, t, k)
    if type(f) == "table" and not iscallable(f) then
        if #f > 0 then
            f, t, k = ipairs(f)
        else
            f, t, k = pairs(f)
        end
    elseif type(f) == "string" then
        f, t, k = ipairs(f)
    end
    return f, t, k
end

---@param s string
---@param path string
---@param ... string
---@return string
local function getstat(s, path, ...)
    if ... then path = Jl.joinpath(path, ...) end
    local f = assert(io.popen("stat -c " .. s .. (" %q"):format(path)))
    local x = f:read("a")
    f:close()
    return x
end

---@class Jl.AbstractArray: Jl.Any
---@class Jl.AbstractChannel: Jl.Any, coroutinelib
---@class Jl.AbstractDict: Jl.Any, { [any]: any }

-- @class Jl.AbstractDisplay: Jl.Any

---@class Jl.AbstractFloat: Jl.Any, number
---@class Jl.AbstractIrrational: Jl.Any, number
---@class Jl.AbstractMatch: Jl.Any
---@class Jl.AbstractMatrix: Jl.Any
---@class Jl.AbstractPattern: Jl.Any

---@class Jl.AbstractRange: Jl.Any
---@field start number
---@field step number
---@field stop number
Jl.AbstractRange = setmetatable({
    __name = "AbstractRange",
    ---@return number?
    __call = function(self, i)
        if not i then
            return self.start
        else
            local result = i + self.step
            if self.step >= 0 and result <= self.stop
                or self.step < 0 and result >= self.stop then
                return result
            end
        end
    end,
    __tostring = function(self)
        return ("%d:%d:%d"):format(self.start, self.step, self.stop)
    end,
    __len = function(self)
        local l = (self.stop - self.start)
        return l // self.step + (l % self.step == 0 and 1 or 0)
    end,
    __add = function(self, other)
        if #self == #other then
            return Jl.StepRange(
                self.start + other.start,
                self.step + other.step,
                self.stop + other.stop
            )
        end
    end,
    __sub = function(self, other)
        if #self == #other then
            return Jl.StepRange(
                self.start - other.start,
                self.step - other.step,
                self.stop - other.stop
            )
        end
    end,
    __unm = function(self)
        return Jl.StepRange( -self.start, -self.step, -self.stop)
    end,
    reverse = function(self)
        return getmetatable(self)(self.stop, -self.step, self.start)
    end
}, {
    __index = Jl.Any
})

---@class Jl.AbstractSet: Jl.Any
Jl.AbstractSet = setmetatable({
    __name = "AbstractSet",
    __index = Jl.AbstractSet
}, {
    __index = Jl.Any
})

---@class Jl.AbstractChar: Jl.Any, string
---@class Jl.AbstractString: Jl.Any, string todo

---@class Jl.AbstractUnitRange: Jl.AbstractRange
Jl.AbstractUnitRange = setmetatable({
    __name = "AbstractUnitRange",
    ---@return number?
    __call = function(self, i)
        if not i then
            return self.start
        else
            local result = i + self.step
            if self.step >= 0 and result <= self.stop
                or self.step < 0 and result >= self.stop then
                return result
            end
        end
    end,
    __tostring = function(self)
        return ("%d:%d"):format(self.start, self.stop)
    end,
    __len = function(self) return self.stop - self.start + 1 end,
    step = 1
}, {
    __index = Jl.AbstractRange
})
---@class Jl.AbstractVector: Jl.Any, any[]

---@class Jl.Any
Jl.Any = { __name = "Any" }
setmetatable(Jl.Any, Jl.Any)

---@class Jl.BitSet: Jl.AbstractSet
---@operator call(table?): Jl.BitSet
Jl.BitSet = setmetatable({
    __name = "BitSet",
    ---@param k integer
    ---@return boolean
    ---@overload fun(self, k): any
    __index = function(self, k)
        if math.type(k) == "integer" then

        else
            return Jl.BitSet[k]
        end
    end,
    ---@return integer?
    __call = function(self, k)
        if k == nil then
            return self[1] and 1 or self(2)
        elseif k > #self then
            return nil
        elseif self[k] then
            return k
        else
            return self(k + 1)
        end
    end
}, {
    __call = function(self, t, ...)
        local bitset = { data = {} }
        if t then
            for _, v in toiterator(t, ...) do
                bitset.data[v] = true
            end
        end
        return setmetatable(bitset, self)
    end,
    __index = Jl.AbstractSet
})

---@param x integer|boolean
function Jl.Bool(x)
    if x == true or x == 1 then
        return true
    elseif x == false or x == 0 then
        return false
    else
        error("InexactError: Bool(" .. x .. ")")
    end
end

---@class Jl.CartesianIndex
---@operator call(...): Jl.CartesianIndex
Jl.CartesianIndex = setmetatable({
    __name = "CartesianIndex",
    __index = Jl.CartesianIndex,
    __eq = equallists,
    __add = addlistseq,
    __sub = sublistseq,
    __tostring = function(self)
        return ("CartesianIndex(%s)"):format(table.concat(self, ", "))
    end,
}, {
    ---@return Jl.CartesianIndex
    __call = function(self, ...)
        local xs = table.pack(...)
        assert(Jl.all(Jl.isinteger, xs))
        return setmetatable(xs, self)
    end
})
Jl.Char = string.char

---@class Jl.ComposedFunction: function
---@field outer function
---@field inner function
---@operator call(table?): Jl.ComposedFunction
Jl.ComposedFunction = setmetatable({
    __name = "ComposedFunction",
    __call = function(self, ...) return self.outer(self.inner(...)) end,
    __index = Jl.ComposedFunction
}, {
    ---@param outer function
    ---@param inner function
    ---@return Jl.ComposedFunction
    __call = function(self, outer, inner)
        return setmetatable({ outer = outer, inner = inner }, self)
    end
})

---@class Jl.Dict: Jl.AbstractDict
---@operator call(table?): Jl.Dict
Jl.Dict = setmetatable({
    __name = "Dict",
    __index = Jl.Dict
}, {
    __call = function(self, t)
        local instance = t or {}

        return setmetatable(instance, self)
    end
})

Jl.GC = {
    ---@param on boolean
    enable = function(on)
        local previous = collectgarbage("isrunning")
        collectgarbage(on and "restart" or "stop")
        return previous
    end,
    --- Perform garbage collection.
    ---@param full boolean
    gc = function(full) collectgarbage(full and "collect" or "step") end,
}

Jl.Int = math.tointeger
Jl.Int16 = math.tointeger
Jl.Int32 = math.tointeger
Jl.Int64 = math.tointeger
Jl.Int8 = string.byte -- todo: make generic

Jl.MathConstants = {
    catalan = 0.9159655941772,
    e = math.exp(1),
    eulergamma = 0.57721566490153,
    golden = (1 + math.sqrt(5)) / 2,
    pi = Jl.pi,
}

function Jl.Nothing()
end

---@class Jl.OneTo: Jl.AbstractUnitRange
---@operator call(integer): Jl.OneTo
Jl.OneTo = setmetatable({
    __name = "OneTo",
    __index = Jl.OneTo,
    __len = function(self) return self.stop end,
    __call = function(self, i)
        if i and i + 1 <= self.stop then
            return i + 1
        elseif not i then
            return 1
        end
    end,
    start = 1,
    step = 1,
}, {
    ---@param stop integer
    __call = function(self, stop)
        return setmetatable({ stop = assert(math.tointeger(stop)) }, self)
    end,
    __index = Jl.AbstractUnitRange
})

Jl.Random.Random = Jl.Random

---@class Jl.RoundingMode: Jl.Any
---@field fn fun(x: number): number
---@operator call(function): Jl.RoundingMode
Jl.RoundingMode = setmetatable({
    __name = "RoundingMode",
    ---@param self Jl.RoundingMode
    ---@param ... number
    ---@return number
    __call = function(self, ...) return self.fn(...) end,
    __supertype = "RoundingMode"
}, {
    __index = Jl.Any,
    ---@param fn fun(x: number): number
    ---@return Jl.RoundingMode
    __call = function(self, fn)
        return setmetatable({ fn = fn }, self)
    end,
    __supertype = "Any"
})

Jl.RoundDown = Jl.RoundingMode(math.floor)

Jl.RoundFromZero = Jl.RoundingMode(function(x)
    return x - x % 1 + (x > 0 and 1 or 0)
end)

Jl.RoundNearestTiesAway = Jl.RoundingMode(function(x)
    local r = x % 1
    if r == 0.5 then
        return x - r
    else
        return Jl.RoundNearest(x, r)
    end
end)

Jl.RoundNearestTiesUp = Jl.RoundingMode(function(x)
    local r = x % 1
    if r == 0.5 then
        return x + r
    else
        return Jl.RoundNearest(x, r)
    end
end)

Jl.RoundToZero = Jl.RoundingMode(function(x)
    return x - x % 1 + (x < 0 and 1 or 0)
end)

Jl.RoundUp = Jl.RoundingMode(math.ceil)

---@class Jl.StepRange: Jl.AbstractRange
---@field start number
---@field step number
---@field stop number
---@operator call(table?): Jl.StepRange
Jl.StepRange = setmetatable({
    __name = "StepRange",
    __index = Jl.StepRange
}, {
    ---@param start number
    ---@param step number
    ---@param stop number
    ---@return Jl.StepRange|Jl.UnitRange
    __call = function(self, start, step, stop)
        if step == 1 then
            return Jl.UnitRange(start, stop)
        end
        return setmetatable({
            start = assert(start),
            step = assert(step),
            stop = assert(stop)
        }, self)
    end,
    __index = Jl.AbstractRange
})

Jl.String = tostring

---@class Jl.Symbol: Jl.Any, string
---@field name string
---@operator call(table?): Jl.Symbol
Jl.Symbol = setmetatable({
    __name = "Symbol",
    __index = Jl.Symbol,
    __tostring = function(self)
        return self.name
    end,
    __eq = function(self, other)
        return self.name == other.name
    end,
}, {
    ---@param name string
    __call = function(self, name)
        return setmetatable({ name = name }, self)
    end,
    __index = Jl.Any
})

Jl.UInt8 = string.byte -- todo: make generic

---@class Jl.UnitRange
---@field start number
---@field stop number
---@operator call(): Jl.UnitRange
Jl.UnitRange = setmetatable({
    __name = "UnitRange",
    reverse = function(self)
        return Jl.StepRange(self.stop, -1, self.start)
    end
}, {
    ---@param start number
    ---@param stop number
    ---@return Jl.UnitRange
    __call = function(self, start, stop)
        return setmetatable({
            start = assert(type(start) == "number" and start),
            stop = assert(type(stop) == "number" and stop)
        }, self)
    end
})

function Jl.UnitRange:__call(k)
    return k == nil and self.start or k + 1 <= self.stop and k + 1 or nil
end

function Jl.UnitRange:__index(k)
    if type(k) == "number" then
        local i = assert(math.tointeger(k), "Invalid index: " .. k)
        local result = self.start + i - 1
        assert(i >= 1 and result <= self.stop)
        return result
    else
        return Jl.UnitRange[k]
    end
end

function Jl.UnitRange:__tostring()
    return ("UnitRange(%i, %i)"):format(self.start, self.stop)
end

Jl.Val = Jl.identity

---@class Jl.Vector
---@operator call(table?): Jl.Vector
Jl.Vector = setmetatable({
    __name = "Jl.Vector"
}, {
    __call = function(self, T)
        if not T then
            return setmetatable({}, self)
        end
        T = T and T[1]
        return function()
            return {}
        end
    end
})
Jl.Vector.__index = Jl.Vector

Jl.abs = math.abs

--- Squared absolute value of x.
---@param x number
---@return number
function Jl.abs2(x)
    x = math.abs(x)
    return x * x
end

Jl.acos = math.acos

function Jl.acosd(x) return math.deg(math.acos(x)) end

---@param x number
function Jl.acot(x) return math.atan(1, x) end

---@param x number
function Jl.acotd(x) return math.deg(math.atan(1, x)) end

---@param x number
function Jl.acsc(x) return math.asin(1 / x) end

---@param x number
function Jl.acscd(x) return math.deg(math.asin(1 / x)) end

---Returns true if every value in the iterator satisfies the predicate.
---@overload fun(xs: boolean[]): boolean
---@overload fun(p: (fun(x): boolean), xs: boolean[]|(fun(...): boolean), ...): boolean
function Jl.all(...)
    local p, itr, t, k = ...
    local len = select("#", ...)
    if len == 1 or len == 3 and type(itr) ~= "function" then
        p, itr, t, k = Jl.identity, p, itr, t
    end
    for _, v in toiterator(itr, t, k) do
        if not p(v) then
            return false
        end
    end
    return true
end

--- Returns true if all values in the iterator/list/table are equal.
---@param itr function|any[]|table
function Jl.allequal(itr, t, k)
    itr, t, k = toiterator(itr, t, k)
    local init
    k, init = itr(t, k)
    for _, v in itr, t, k do
        if v ~= init then return false end
    end
    return true
end

--- Returns true if all values in the iterator/list/table are unique.
---@param itr function|any[]|table
function Jl.allunique(itr, t, k)
    local seen, seennil = {}, false
    for _, v in toiterator(itr, t, k) do
        if v == nil then
            if seennil then return false end
            seennil = true
        else
            if seen[v] then return false end
            seen[v] = true
        end
    end
    return true
end

---Returns true if any value in the collection satisfies the predicate.
---@param p function? defaults to `identity`
function Jl.any(p, itr, t, k)
    -- todo: make generic
    if type(itr) ~= "function" then
        itr, t, k = p, itr, t
    end
    for key, value in itr, t, k do
        ---@diagnostic disable-next-line: need-check-nil
        if p(value, key, t) then
            return true
        end
    end
    return false
end

--- In Jl, determine whether the given generic function has a method
--- applicable to the given arguments. In Lua, just assume it is.
function Jl.applicable(...) return true end

---@param s string
function Jl.ascii(s)
    local i = s:find("[^%c%g%s]")
    if i then
        error(("ArgumentError: invalid ASCII at index %d in %q"):format(i, s))
    end
    return s
end

---@param x number
function Jl.asec(x) return math.cos(1 / x) end

---@param x number
function Jl.asecd(x) return math.deg(math.cos(1 / x)) end

Jl.asin = math.asin

function Jl.asind(x) return math.deg(math.asin(x)) end

Jl.atan = math.atan

--- Compute the inverse tangent of `y` or `y/x`, respectively, where the output
--- is in degrees.
---@param y number
---@param x number?
function Jl.atand(y, x) return math.deg(math.atan(y, x)) end

--- Calculates the binomial coefficient \binom{n}{k}
---@param n integer
---@param k integer
---@return integer
function Jl.binomial(n, k)
    if n >= 0 then
        return Jl.factorial(n) / (Jl.factorial(k) * Jl.factorial(n - k))
    else
        return -1 ^ k * Jl.binomial(k - n - 1, k)
    end
end

---@param file file*
---@param xs integer[]
---@return nil
---@overload fun(xs: integer[]): string
function Jl.bytes2hex(file, xs)
    if type(xs) == "nil" then
        ---@diagnostic disable-next-line: cast-local-type
        file, xs = nil, file --[[@as integer[] ]]
    end
    local result = {}
    for i, v in toiterator(xs) do
        result[i] = ("%x"):format(v)
    end
    local s = table.concat(result)
    if file then
        file:write(s)
    else
        return s
    end
end

---@param x number
function Jl.cbrt(x) return x ^ (1 / 3) end

---@param path string
function Jl.cd(path) os.execute("cd '" .. path .. "'") end

Jl.ceil = math.ceil

--- Remove a single trailing newline from a string.
---@param s string
function Jl.chomp(s) return s:gsub("\n$", "") end

--- Remove the first `head` and the last `tail` characters from `s`.
---@param s string
---@param kwargs { head?: integer, tail?: integer }?
function Jl.chop(s, kwargs)
    kwargs = kwargs or {}
    local head, tail = kwargs.head or 0, kwargs.tail or 1
    return s:sub(head + 1, #s - tail)
end

--- Remove the prefix prefix from s. If s does not start with prefix, a
--- string equal to s is returned.
---@param s string
---@param prefix string
function Jl.chopprefix(s, prefix)
    return s:sub(1, #prefix) == prefix and s:sub(#prefix + 1) or s
end

--- Remove the suffix suffix from s. If s does not end with suffix, a
--- string equal to s is returned.
---@param s string
---@param suffix string
function Jl.chopsuffix(s, suffix)
    return s:sub(#suffix + 1) == suffix and s:sub(1, #suffix - 1) or s
end

---@generic T any type with a __lt metamethod
---@param x T
---@param lo T
---@param hi T
---@return T
function Jl.clamp(x, lo, hi)
    if type(lo) == "table" then
        if lo.start and lo.stop then
            lo, hi = lo.start, lo.stop
        else
            lo, hi = Jl.typemin(lo), Jl.typemax(lo)
        end
    end
    if x < lo then x = lo end
    if hi < x then x = hi end
    return x
end

---@param stream file*
function Jl.close(stream) stream:flush():close() end

---@param lessthan fun(x, y): boolean
---@param x any
---@param y any
---@return -1|0|1
function Jl.cmp(lessthan, x, y)
    if type(lessthan) ~= "function" then
        lessthan, x, y = Jl.isless, lessthan, x
    end
    return lessthan(x, y) and -1
        or lessthan(y, x) and 1
        or 0
end

function Jl.coalesce(...)
    for i = 1, select("#", ...) do
        local v = select(i, ...)
        if not Jl.ismissing(v) then return v end
    end
    return Jl.missing
end

Jl.codepoint = utf8.codepoint

---@param _ string
function Jl.codeunit(_) return Jl.UInt8 end

---@class Jl.Base.CodeUnits
---@operator call(table?): Jl.Base.CodeUnits
Jl.Base.CodeUnits = setmetatable({
    __name = "Base.CodeUnits",
    __index = Jl.Base.CodeUnits,
    -- todo: make iterable
}, {
    __call = function(self, ...)
        return setmetatable(table.pack(...), self)
    end
})

---@param s string
function Jl.codeunits(s) return Jl.Base.CodeUnits(s:byte(1, #s)) end

---@generic X
---@param xs X[]|fun():X?
---@param ... unknown
---@return X[]
---@overload fun(s: string): string[]
function Jl.collect(xs, ...)
    if type(xs) == "function" then
        local result = {}
        for key, value in xs, ... do
            table.insert(result, value or key)
        end
        return result
    else
        local mt = getmetatable(xs)
        if mt and mt.__len or type(xs) == "string" then
            local result = {}
            for i = 1, #xs do
                table.insert(result, xs[i])
            end
            return result
        else
            return xs
        end
    end
end

function Jl.copy(x)
    if type(x) == "table" then
        if x.copy then
            return x:copy()
        else
            local copy = {}
            for k, v in pairs(x) do
                copy[k] = v
            end
            return setmetatable(copy, getmetatable(x))
        end
    else
        return x
    end
end

--- Return z which has the magnitude of x and the same sign as y.
---@param x number
---@param y number
---@return number z
function Jl.copysign(x, y) return math.abs(x) * (y < 0 and -1 or 1) end

Jl.cos = math.cos

--- Compute `\cos(\pi x) / x - \sin(\pi x) / (\pi x^2)` if `x \neq 0`, and
--- `0` if `x = 0`. This is the derivative of `sinc(x)`.
---@param x number
function Jl.cosc(x)
    if x == 0 then
        return 0
    else
        return math.cos(math.pi * x) / x -
            math.sin(math.pi * x) / (math.pi * x ^ 2)
    end
end

---@param x number
function Jl.cosd(x) return math.deg(math.cos(x)) end

function Jl.cospi(x) return math.cos(math.pi * x) end

---@param x number
function Jl.cot(x) return 1 / math.tan(x) end

---@param x number
function Jl.cotd(x) return math.deg(1 / math.tan(x)) end

---@param file file*
function Jl.countlines(file)
    local wasstring = false
    if type(file) == "string" then
        wasstring = true
        file = assert(io.open(file))
    end
    local i = 0
    for _ in file:lines() do i = i + 1 end
    if wasstring then file:close() end
    return i
end

--- Copy the file, link, or directory from src to dst.
---@param src string
---@param dst string
function Jl.cp(src, dst)
    io.popen(("cp -n %q %q"):format(src, dst))
end

---@param x number
function Jl.csc(x) return math.sin(1 / x) end

---@param x number
function Jl.cscd(x) return math.deg(math.sin(1 / x)) end

---@param path string
---@param ... string
function Jl.ctime(path, ...) return tonumber(getstat("%Z", path, ...)) end

---@param xs number[]|fun(...):number
---@return number[]
function Jl.cumprod(xs, t, k)
    if type(xs) == "table" then
        xs, t, k = Jl.values(xs)
    end
    local result = {}
    local i = 1
    for val in xs, t, k do
        result[i] = val * (result[i - 1] or 1)
        i = i + 1
    end
    return result
end

---@param xs number[]|fun(...):number
---@return number[]
function Jl.cumsum(xs, t, k)
    if type(xs) == "table" then
        xs, t, k = Jl.values(xs)
    end
    local result = {}
    local i = 1
    for val in xs, t, k do
        result[i] = val + (result[i - 1] or 0)
        i = i + 1
    end
    return result
end

function Jl.deepcopy(x)
    if type(x) == "table" then
        if x.deepcopy then
            return x:deepcopy()
        else
            local copy = {}
            for k, v in pairs(x) do
                copy[k] = Jl.deepcopy(v)
            end
            return setmetatable(copy, getmetatable(x))
        end
    else
        return x
    end
end

Jl.deg2rad = math.rad

---Calculate the differences between each successive value of the iterator.
---@param iterator function
---@return function stateful
function Jl.diff(iterator, iterand, key)
    -- to do: make generic, currently only handles iterators
    local previous
    key, previous = iterator(iterand, key)
    return function()
        local value
        local previouskey = key
        key, value = iterator(iterand, previouskey)
        if not key then
            return
        end
        previous, value = value, value - previous
        return previouskey, value
    end
end

---@param n integer
---@param base (integer|{ base: integer })? defaults to 10
function Jl.digits(n, base)
    n = assert(math.tointeger(n), "Expected an integer")
    if n == 0 then return { 0 } end
    ---@cast base integer
    base = Jl.get(base, "base", math.type(base) == "integer" and base or 10)
    local result = {}
    local isnegative = Jl.signbit(n)
    if isnegative then n = -n end
    repeat
        table.insert(result, n % base)
        n = n // base
    until n == 0
    if isnegative then result[#result] = -result[#result] end
    return result
end

---@param x number
---@param y number
---@param r Jl.RoundingMode?
function Jl.div(x, y, r) return Jl.round(x / y, r) end

Jl.eachindex = ipairs

--- Iterator over each line in a file
---@param filename string? defaults to stdin
---@param keep boolean defaults to false
---@return fun():string?
function Jl.eachline(filename, keep)
    if type(filename) == "boolean" then
        filename, keep = nil, filename --[[@as boolean]]
    end
    return io.lines(filename, keep and "l" or "L")
end

---@param r string or Jl.Regex
---@param s string
---@param overlap boolean|{ overlap?: boolean }
function Jl.eachmatch(r, s, overlap)
    overlap = Jl.get(overlap, "overlap", overlap == true)
    local init = 1
    return function()
        local m = Jl.match(r, s, init)
        init = init + (not overlap and m and #m.match or 1)
        return m
    end
end

---@alias Jl.SplitKwargs { limit: integer?, keepempty: boolean? }

---@param s string
---@param dlm string|(fun(s:string):boolean)?
---@param kwargs Jl.SplitKwargs?
---@overload fun(s: string, kwargs: Jl.SplitKwargs): fun(): string?
---@return fun(): string?
function Jl.eachsplit(s, dlm, kwargs)
    if not kwargs and type(dlm) == "table" and #dlm == 0 then
        dlm, kwargs = nil, dlm
    end
    local limit = kwargs and kwargs.limit or 0
    local keepempty = not kwargs or kwargs.keepempty
    if not dlm and limit == 0 and not keepempty then
        return s:gmatch("%S+")
    end
    if type(dlm) == "string" or not dlm then
        dlm = Jl.occursin(dlm or " \t\r\n")
    end
    local iter = s:gmatch(utf8.charpattern)
    return function()
        local cs = {}
        local c = iter()
        while c and dlm(c) do
            c = iter()
        end
        while c and not dlm(c) do
            table.insert(cs, c)
            c = iter()
        end
        return #cs ~= 0 and table.concat(cs) or nil
    end
end

---@param s string
---@param p string or Julia.Regex
function Jl.endswith(s, p)
    return s:sub(-#p) == p or not not s:find(p .. "$")
end

Jl.ENV = setmetatable({}, {
    __index = function(_, k) return os.getenv(k) end
})

--- Test whether an I/O stream is at end-of-file.
---@param file file*
function Jl.eof(file) return file:seek("cur") == file:seek("end") end

Jl.exit = os.exit
Jl.exp = math.exp

---@param x number
function Jl.exp10(x) return 10 ^ x end

---@param x number
function Jl.exp2(x) return 2 ^ x end

---@param path string
function Jl.expanduser(path)
    path = path:gsub("~", Jl.homedir())
    return path
end

---@param x number
function Jl.expm1(x) return math.exp(x) - 1 end

--- Get the exponent of a normalized floating-point number. Returns the largest
--- integer y such that 2^y ≤ abs(x), i.e. the index of the highest set bit.
function Jl.exponent(x)
    x = math.floor(math.abs(x))
    local y = 0x4000000000000000
    repeat
        if x & y ~= 0 then return y end
        y = y >> 1
    until y == 0
    return 0
end

function Jl.export(...)
    if not ... then
        for k, v in pairs(Jl) do
            _G[k] = v
        end
    end
end

---Calculate the minimum and maximum values of applying `fn` to the iterator.
---If multiple values are found, returns the first value.
---@param fn function optional, defaults to `identity`
---@param iterator function
---@return any minkey the key of the minimum argument
---@return any minarg the argument of the minimum value
---@return any minvalue the minimum value
---@return any maxkey the key of the maximum argument
---@return any maxarg the argument of the minimum value
---@return any maxvalue the maximum value
function Jl.extrema(fn, iterator, iterand, key)
    if type(iterator) ~= "function" then
        fn, iterator, iterand, key = Jl.identity, fn, iterator, iterand
    end
    local minkey, maxkey, minarg, maxarg, minvalue, maxvalue, value
    key, minarg = iterator(iterand, key)
    if key == nil then return end
    minkey, maxkey = key, key
    minvalue = fn(minarg)
    maxarg, maxvalue = minarg, minvalue
    for key, arg in iterator, iterand, key do
        value = fn(arg)
        if value < minvalue then
            minkey, minarg, minvalue = key, arg, value
        end
        if value > maxvalue then
            maxkey, maxarg, maxvalue = key, arg, value
        end
    end
    return minkey, minarg, minvalue, maxkey, maxarg, maxvalue
end

---@param n integer
function Jl.factorial(n)
    assert(math.type(n) == "integer", "DomainError: `n` must be an integer.")
    assert(n >= 0, "DomainError: `n` must not be negative.")
    local result = 1
    for i = 2, n do
        result = result * i
    end
    return result
end

---@param ... integer
function Jl.falses(...) return Jl.fill(false, ...) end

---@param path string
---@param ... string
function Jl.filemode(path, ...)
    return math.tointeger(getstat("%f", path, ...))
end

---@param path string
---@param ... string
function Jl.filesize(path, ...)
    return math.tointeger(getstat("%s", path, ...))
end

---Create a list of `value` repeated `count` times.
---@generic T
---@param value T
---@param count integer
---@return T[]
function Jl.fill(value, count)
    assert(count and count >= 0,
        "Expected a non-negative integer, got " .. tostring(value))
    return Jl.collect(Jl.Iterators.repeated(value, count))
end

---@generic X
---@param fn fun(x: X): boolean
---@param xs X[]
---@return X[]
---@overload fun(fn:(fun(s:string):boolean), s:string): string
---@overload fun(fn: function, f: function, ...): stateful
function Jl.filter(fn, xs, ...)
    local X = type(xs)
    if X == "string" then
        local chars = {}
        for c in xs:gmatch(".") do
            if fn(c) then
                table.insert(chars, c)
            end
        end
        return table.concat(chars)
    elseif X == "table" then
        local result = {}
        for x in 1, #xs do
            if fn(x) then
                table.insert(xs, x)
            end
        end
        return result
    elseif X == "function" then
        return Jl.Iterators.filter(fn, xs, ...)
    end
    error(("no method matching filter(fn, ::%s)"):format(X))
end

function Jl.finalize(t) kcall(getmetatable(t), "__gc") end

function Jl.finalizer(f, x)
    local mt = getmetatable(x)
    mt.__gc = mt.__gc and function(self) mt.__gc(f(self)) end or f
    return setmetatable(x, mt)
end

---@generic T
---@param xs T|T[]|fun(...): T
---@return T
function Jl.first(xs, ...)
    if select("#", ...) ~= 0 then
        return xs
    elseif type(xs) == "string" then
        return xs:sub(1, 1)
    elseif type(xs) == "function" then
        return xs(...)
    elseif getmetatable(xs).__len and #xs > 0 then
        return xs[1]
    else
        return xs
    end
end

---@param t table
---@return integer
function Jl.firstindex(t) return t.firstindex or 1 end

function Jl.fld(x, y) return x // y end

function Jl.fld1(x, y) return (x - 1) // y + 1 end

function Jl.fldmod(x, y) return x // y, x % y end

function Jl.fldmod1(x, y) return (x - 1) % y + 1 end

--- Return x with its sign flipped if y is negative.
---@param x number
---@param y number
function Jl.flipsign(x, y) return y < 0 and -x or x end

---@param x number|boolean|any[]
function Jl.float(x)
    local T = type(x)
    if T == "table" then
        for i, v in ipairs(x) do
            x[i] = Jl.float(v)
        end
    elseif T == "boolean" then
        return x and 1 or 0
    elseif T ~= "number" then
        error(("MethodError: no method for float(::%s)"):format(T))
    end
    return x
end

Jl.floor = math.floor

---@param file file*?
function Jl.flush(file) (file or io):flush() end

---@param x number
---@param y number
---@param z number
function Jl.fma(x, y, z) return x * y + z end

---@generic T
---@param fn fun(l: T, r: T): T
---@param iterand T[]|fun():T?
---@param init T?
---@return T
function Jl.foldl(fn, iterand, init)
    return Jl.mapfoldl(fn, Jl.identity, iterand, init)
end

---@generic T
---@param fn fun(l: T, r: T): T
---@param iterand T[]|fun():T?
---@param init T?
---@return T
function Jl.foldr(fn, iterand, init)
    return Jl.mapfoldr(fn, Jl.identity, iterand, init)
end

---Call `procedure` on each value of `iterator`, for `procedure`'s side effects.
---@param procedure function
---@param iterator function|any[]
function Jl.foreach(procedure, iterator, t, k)
    if not iscallable(iterator) then
        iterator, t, k = ipairs(iterator --[[@as any[] ]])
    end
    for value in iterator, t, k do
        procedure(value)
    end
end

--- The greatest common denominator of the arguments.
---@param x integer
---@param y integer?
---@param ... integer
---@return integer
function Jl.gcd(x, y, ...)
    if not y then
        return x
    elseif y == 0 then
        return Jl.gcd(x, ...)
    else
        return Jl.gcd(y, x % y, ...)
    end
end

function Jl.get(xs, i, d)
    local T = type(xs)
    if (T == "table" or T == "string") and i ~= nil then
        return xs[i]
    elseif T == "number" or T == "boolean" then
        if i == 1 then
            return xs
        else
            error("BoundsError")
        end
    else
        return d
    end
end

Jl.getfield = rawget

function Jl.getindex(t, k) return t[k] end

Jl.getproperty = Jl.getindex
Jl.getkey = Jl.get

function Jl.haskey(t, k) return t[k] ~= nil end

function Jl.hasproperty(t, k) return rawget(t, k) ~= nil end

---@param s string
function Jl.hex2bytes(s)
    assert(#s % 2 == 0, "ArgumentError: length of iterable must be even")
    assert(not s:find("%X"), "ArgumentError: byte is not an ASCII hexadecimal digit")
    local result = {}
    for m in s:match("..") do
        table.insert(result, tonumber(m, 16))
    end
    return result
end

---@return string
function Jl.homedir()
    return assert(os.getenv("HOME") or ("/home/" .. os.getenv("USER")),
        "Jl.homedir: Couldn't find the home directory")
end

Jl.htol = Jl.identity

--- Converts host byte order (assumed to be little-endian) to network byte order
---@param n integer
function Jl.hton(n)
    return ((n & 0xff) << 56)
        | ((n & 0xff00) << 40)
        | ((n & 0xff0000) << 24)
        | ((n & 0xff000000) << 8)
        | ((n & 0xff00000000) >> 8)
        | ((n & 0xff0000000000) >> 24)
        | ((n & 0xff000000000000) >> 40)
        | ((n & 0xff00000000000000) >> 56)
end

--- The hypotenuse of a triangle of sides x and y.
---@param x number
---@param y number
function Jl.hypot(x, y) return math.sqrt(x * x + y * y) end

--- Return the inputs unchanged.
---@generic T
---@param ... T
---@return T ...
function Jl.identity(...) return ... end

--- Return x if condition is true, otherwise return y. This differs from `?` or
--- `if` in that it is an ordinary function, so all the arguments are evaluated
--- first.
---@generic X, Y
---@param condition boolean Jl only accepts a Bool here
---@param x X
---@param y Y
---@return X | Y
function Jl.ifelse(condition, x, y) return condition and x or y end

---@param x number
function Jl.inv(x) return 1 / x end

function Jl.invoke(f, _, ...) return f(...) end

---@param x number
---@param y number
---@param kwargs { atol?: number }?
---@return boolean
function Jl.isapprox(x, y, kwargs)
    return math.abs(x - y) < (kwargs and kwargs.atol or 1e-9)
end

function Jl.isascii(s)
    for _, c in utf8.codes(s) do
        if c >= 128 then return false end
    end
    return true
end

function Jl.isassigned(array, i) return array[i] ~= nil end

function Jl.isbits(x) return Jl.isbitstype(type(x)) end

function Jl.isbitstype(T)
    return not (T == "table" or T == "thread" or T == "userdata")
end

function Jl.iscntrl(c) return not not c:find("^%c$") end

function Jl.isconcretetype(T) return not Jl.isabstracttype(T) end

function Jl.isdefined(t, k) return t[k] ~= nil end

function Jl.isdigit(c) return not not c:find("^%d$") end

function Jl.isempty(xs) return #xs == 0 end

function Jl.isequal(...)
    local len = select("#", ...)
    local x = ...
    if len == 1 then
        return function(y) return x == y end
    else
        return x == select(2, ...)
    end
end

---@param x boolean|number
function Jl.iseven(x) return x % 2 == 0 or x == false end

---@param x number
function Jl.isfinite(x) return not Jl.isinf(x) end

function Jl.isimmutable(...) return not Jl.ismutable(...) end

---@param x number
function Jl.isinf(x) return x == math.huge or x == -math.huge end

---@param x number
function Jl.isinteger(x)
    local T = type(x)
    if T == "boolean" then
        return true
    elseif T == "number" then
        return not not math.tointeger(x)
    else
        error(("MethodError: no method matching isinteger(::%s)"):format(T))
    end
end

function Jl.isless(x, y) return x < y end

function Jl.isletter(c) return not not c:find("^%a$") end

function Jl.islowercase(c) return not not c:find("^%l$") end

function Jl.ismarked(s) return #markedstreams[s] > 0 end

function Jl.ismissing(x) return x == Jl.missing end

function Jl.ismutable(x) return Jl.ismutabletype(type(x)) end

function Jl.ismutabletype(T) return T ~= "table" end

---@param x number
function Jl.isnan(x) return x ~= x end

function Jl.isnothing(x) return x == nil end

Jl.isnumeric = Jl.isdigit

---@param x boolean|integer
function Jl.isodd(x) return x % 2 == 1 or x == true end

---@param x boolean|number|string
function Jl.isone(x) return x == 1 or x == "" or x == true end

---@param file file*
function Jl.isopen(file) return io.type(file) == "file" end

function Jl.isperm(xs)
    local p = Jl.falses(#xs)
    for _, v in ipairs(xs) do
        if p[v] then return false end
        p[v] = true
    end
    return Jl.all(p)
end

---@param x number
function Jl.ispow2(x)
    assert(type(x) == "number",
        ("MethodError: no method matching ispow2(::%s)"):format(type(x)))
    local n = math.tointeger(x)
    if not n or n < 1 then return false end
    while Jl.iseven(n) do
        n = n >> 1
    end
    return n == 1
end

---@param c string
function Jl.isprint(c) return not not c:find("^%C$") end

---@param c string
function Jl.ispunct(c) return not not c:find("^%p$") end

---@param x number
function Jl.isqrt(x) return math.floor(math.sqrt(x)) end

function Jl.isreal(x) return type(x) == "number" end

function Jl.isspace(c) return not not c:find("^%s$") end

function Jl.isuppercase(c) return not not c:find("^%u$") end

function Jl.isxdigit(c) return not not c:find("^%x$") end

function Jl.iszero(x) return x == 0 or (type(x) == "table" and #x == 0) end

Jl.keys = pairs

function Jl.last(xs) return xs[Jl.lastindex(xs)] end

Jl.lastindex = Jl.length

function Jl.lcm(x, ...)
    local prod = x
    for i = 1, select("#", ...) do
        prod = prod * select(i, ...)
    end
    return math.abs(prod) / Jl.gcd(x, ...)
end

---@param x number
---@param n number
function Jl.ldexp(x, n) return x * 2 ^ n end

function Jl.length(x)
    return type(x) == "string" and utf8.len(x) or #x
end

Jl.log = math.log

function Jl.log10(x) return math.log(x, 10) end

function Jl.log1p(x) return math.log(x + 1) end

function Jl.log2(x) return math.log(x, 2) end

Jl.lowercase = string.lower

function Jl.lowercasefirst(s) return s:sub(1, 1):lower() .. s:sub(2) end

---@param s string
---@param len integer
---@param c string?
function Jl.lpad(s, len, c)
    if #s >= len then
        return s
    else
        c = c or ' '
        return c:rep(math.ceil(len / #c)):sub(1, len - #s) .. s
    end
end

---@param pred fun(s: string): boolean
---@param s string
---@return string
---@overload fun(s: string, cs?: string[]): string
function Jl.lstrip(pred, s)
    if type(pred) == "function" then
        local i = 1
        while pred(utf8.char(utf8.codepoint(s, i))) do
            i = utf8.offset(s, 2, i)
        end
        return s:sub(i)
    else
        return (pred:gsub("^" .. (s or "%s") .. "+", "", 1))
    end
end

Jl.ltoh = Jl.identity

---@generic D, V
---@param mapper fun(d: D): V
---@param iterable D[]|fun(...): D
function Jl.map(mapper, iterable, ...)
    if select("#", ...) > 0 or iscallable(iterable) then
        return Jl.Iterators.map(mapper, iterable --[[@as function]], ...)
    end
    local result = {}
    for i, v in ipairs(iterable --[[@as any[] ]]) do
        result[i] = mapper(v)
    end
    return result
end

---@generic A, D, V
---@param folder fun(a: A, d: D): A
---@param mapper fun(d: D): V
---@param iterable D[]|fun(): D
---@param init? { init: A }
function Jl.mapfoldl(folder, mapper, iterable, init)
    if type(init) == "table" then
        init = init.init
    else
        init = iscallable(iterable) and iterable() or
            table.remove(iterable --[[@as any[] ]], 1)
        if init == nil then return error("Can't reduce an empty collection") end
    end
    if iscallable(iterable) then
        for v in iterable do
            init = folder(init, mapper(v))
        end
    else
        for _, v in ipairs(iterable --[[@as any[] ]]) do
            init = folder(init, mapper(v))
        end
    end
    return init
end

---@generic A, D, V
---@param folder fun(a: A, d: D): A
---@param mapper fun(d: D): V
---@param iterable D[]|fun(): D
---@param init? { init: A }
function Jl.mapfoldr(folder, mapper, iterable, init)
    if type(init) == "table" then
        init = init.init
    else
        init = iscallable(iterable) and iterable() or
            table.remove(iterable --[[@as any[] ]], 1)
        if init == nil then return error("Can't reduce an empty collection") end
    end
    if iscallable(iterable) then
        return Jl.mapfoldl(folder, mapper, Jl.reverse(iterable), init)
    end
    for i = #iterable, 1, -1 do
        init = folder(init, mapper(iterable[i]))
    end
    return init
end

---@param reducer function
---@param mapper function
---@param iterator function
function Jl.mapreduce(reducer, mapper, iterator, iterand, key)
    iterator, iterand, key = toiterator(iterator, iterand, key)
    local value, other
    key, value = iterator(iterand, key)
    if key ~= nil then
        value = mapper(value)
    end
    while key ~= nil do
        key, other = iterator(iterand, key)
        if key ~= nil then
            value = reducer(value, mapper(other))
        end
    end
    return value
end

---@param r string #|Jl.Regex the needle
---@param s string the haystack
---@param init integer? defaults to 1
---@return Jl.RegexMatch?
function Jl.match(r, s, init)
    init = init or 1
    local m = table.pack(s:find(r))
    if #m > 0 then
        local ss = s:sub(m[1], m[2])
        local i = m[1]
        table.remove(m, 1)
        table.remove(m, 2)
        return Jl.RegexMatch(ss, m, i)
    end
end

function Jl.max(a, b, ...)
    if b then
        if a > b then
            return Jl.max(a, ...)
        else
            return Jl.max(b, ...)
        end
    else
        return a
    end
end

---Find the maximum value of an iterator.
function Jl.maximum(...)
    return select(2, Jl.extrema(...))
end

function Jl.min(a, b, ...)
    if b then
        if a < b then
            return Jl.min(a, ...)
        else
            return Jl.min(b, ...)
        end
    else
        return a
    end
end

---Find the minimum value of an iterator.
function Jl.minimum(...)
    local minvalue = Jl.extrema(...)
    return minvalue
end

---@generic T
---@param ... T
---@return T min, T max
function Jl.minmax(...)
    local min, max = ..., ...
    for i = 2, select("#", ...) do
        local y = select(i, ...)
        min = y < min and y or min
        max = y > max and y or max
    end
    return min, max
end

Jl.Missing = { __name = "missing" }
Jl.missing = setmetatable({}, Jl.Missing)

---@param path string
function Jl.mkdir(path)
    return assert(io.popen(("ls '%s'"):format(path))):close() and path
end

---@param path string
function Jl.mkpath(path)
    return io.popen(("ls -p '%s'"):format(path)):close() and path
end

--- Make a temporary file. If a function is provided, apply the function f to
--- the result of `mktemp()` and remove the temporary file upon completion.
---
--- Unlike Julia, the parent directory is ignored when making temporary files,
--- and the cleanup argument is also ignored, behaving as though cleanup is
--- always set to `true`.
---@param f fun(file: file*)
---@overload fun(path: string?): "", file*
function Jl.mktemp(f)
    local F = type(f)
    if F == "function" then
        local file = io.tmpfile()
        f(file)
        file:close()
    elseif F == "nil" or F == "string" then
        return "", io.tmpfile()
    else
        error("can't make a temp file with a " .. F)
    end
end

---@param x number
---@param y number
function Jl.mod(x, y) return x % y end

---@param x number
---@param y number
function Jl.mod1(x, y) return (x - 1) % y + 1 end

---@param x number
function Jl.mod2pi(x) return math.fmod(x, 2 * math.pi) end

---@param x number
function Jl.modf(x)
    local ipart, fpart = math.modf(x)
    return fpart, ipart
end

---@param path string
---@param ... string
function Jl.mtime(path, ...)
    return math.tointeger(getstat("%y", path, ...))
end

---@param x number
---@param y number
---@param z number
function Jl.muladd(x, y, z) return x * y + z end

function Jl.mv(oldname, newname)
    assert(os.rename(oldname, newname),
        ("Couldn't move %s to %s"):format(oldname, newname))
    return newname
end

function Jl.nameof(x)
    local T = type(x)
    if T == "table" then
        local mt = getmetatable(x)
        if mt then return mt.__name or T end
    end
    return T
end

Jl.NaN = 0 / 0
Jl.NaN16 = 0 / 0
Jl.NaN32 = 0 / 0
Jl.NaN64 = 0 / 0

function Jl.nand(x, y) return ~(x & y) end

Jl.ncodeunits = string.len

--- Compute the number of digits in integer n written in base base.
---@param n number
---@param base number? keyword argument
function Jl.ndigits(n, base)
    base = base or 10
    if n == 0 then
        return 1
    else
        local d = 0
        while n > 0 do
            d = d + 1
            n = n // base
        end
        return d
    end
end

function Jl.nfields(t)
    local total = 0
    for _ in pairs(t) do
        total = total + 1
    end
    return total
end

function Jl.nor(x, y) return ~(x | y) end

Jl.ntoh = Jl.hton

function Jl.ntuple(fn, length)
    local result = {}
    for i = 1, length do
        table[i] = fn(i)
    end
    return result
end

---@param needle string
---@param haystack string
---@return boolean
---@overload fun(haystack: string): fun(needle: string): boolean
function Jl.occursin(needle, haystack)
    if haystack then
        return not not haystack:find(needle, 1, true)
    else
        return function(c)
            return not not needle:find(c, 1, true)
        end
    end
end

--- Convert y to the type of x (`convert(typeof(x), y)`).
function Jl.oftype(x, y) return Jl.convert(Jl.typeof(x), y) end

function Jl.one(x)
    local X = type(x)
    if X == "number" then
        return 1
    elseif X == "string" then
        return ""
    end
end

function Jl.ones(t, len)
    return Jl.fill(type(t) == "number" and 1 or t(1), len or t)
end

---@param _ number
function Jl.oneunit(_) return 1 end

---@generic T
---@param t T[]|fun(...):T?
---@return T?
---@overload fun(x:number): x:number
---@overload fun(b:boolean): b:boolean
function Jl.only(t, ...)
    local T = type(t)
    if T == "number" or T == "boolean" then
        return t
    elseif T == "string" or T == "table" then
        if #t == 1 then return t[1] end
    elseif T == "function" then
        local k, v = t(...)
        if not t(..., k) then
            return v
        end
    end
    error("ArgumentError: Collection has multiple elements, must contain exactly 1 element")
end

--- Opens a file and returns a handle to that file. If the first argument is a
--- function, call that function with the loaded file, closes the file and
--- returns the result.
---@generic T
---@param f fun(file: file*): T
---@param ... string
---@return T
---@overload fun(path: string, mode?: string): file*
function Jl.open(f, path, ...)
    if type(f) == "string" then
        return assert(io.open(f, path), "No such file or directory.")
    elseif type(f) == "function" then
        local file = assert(io.open(path, ...))
        local result = f(file)
        file:close()
        return result
    else
        error("MethodError: open(f::" .. type(f) .. ", ...) not defined")
    end
end

--- Read and return a value of type T from a stream without advancing the
--- current position in the stream.
---@param s file*
function Jl.peek(s, T)
    local value = s:read("n")
    if T == Jl.Char then
        return string.char(value)
    else
        return value
    end
end

Jl.pi = math.pi

--- Get the current position of a stream.
---@param file file*
function Jl.position(file) return file:seek() end

--- Compute x^p mod m.
---@param x integer
---@param p integer
---@param m number
function Jl.powermod(x, p, m) return x ^ p % m end

Jl.print = io.write

---@param s string
function Jl.printf(s, ...) io:write(s:format(...)) end

Jl.println = print
Jl.printstyled = Jl.printf

function Jl.prod(...)
    local result = 1
    for key, value in toiterator(...) do
        result = result * (value or key)
    end
    return result
end

function Jl.pwd()
    local f = io.popen("pwd") --[[@as file*]]
    local result = f:read("a")
    f:close()
    return result
end

Jl.rad2deg = math.deg

function Jl.rand(...)
    local S, dims = ...
    local length = select("#", ...)
    if length == 0 then
        return math.random()
    elseif length == 1 then
        if type(S) == "number" then
            local result = {}
            for i = 1, math.tointeger(S) do
                result[i] = math.random()
            end
            return result
        elseif type(S) == "table" or type(S) == "string" then
            if #S > 0 then
                return S[math.random(1, #S)]
            else
                local keys = Jl.collect(pairs(S --[[@as table]]))
                return S[keys[math.random(1, #keys)]]
            end
        elseif S == Jl.Int then
            return math.random(math.mininteger, math.maxinteger)
        end
    elseif length == 2 then
        if S == Jl.Int then
            local result = {}
            for i = 1, math.tointeger(dims) do
                result[i] = math.random(math.mininteger, math.maxinteger)
            end
            return result
        end
    end
end

---@param start integer
---@param stop integer
---@param length integer
---@return Jl.AbstractRange
---@overload fun(start: integer, stop: integer): Jl.UnitRange
---@overload fun(stop: integer): Jl.UnitRange
function Jl.range(start, stop, length)
    local step = 1
    if length then
        step = (stop - start) / length
    else
        if not stop then
            stop = start
            start = 1
        end
    end
    return Jl.StepRange(start, step, stop)
end

Jl.raw = Jl.identity

---@param stream file*
function Jl.readavailable(stream)
    local s = stream:read("a")
    return s:byte(1, #s)
end

---@param filename string
---@return string
function Jl.readchomp(filename)
    local f = assert(io.open(filename), "No such file or directory.")
    local s = f:read("a"):gsub("\n$", ""):gsub("\r$", "")
    f:close()
    return s
end

function Jl.readdir(path)
    return Jl.collect(
        io.popen("ls -bf1 '" .. path .. "' | sort | tail -n +3", "r"):lines())
end

---@param filename string?
---@param keep boolean|{ keep: boolean }? default false
---@return string?
function Jl.readline(filename, keep)
    if not filename then
        return io.read()
    else
        local mode = Jl.get(keep, "keep", keep == true) and "L" or "l"
        local f = assert(io.open(filename), "No such file or directory.")
        local s = f:read(mode)
        f:close()
        return s
    end
end

function Jl.readlines(filename)
    local file = filename or io.stdin
    if type(filename) == "string" then
        file = io.open(filename, "r")
    end
    return Jl.collect(file:lines())
end

---@generic T
---@param fn fun(x: T, y: T): T
---@param f T[]|fun(...): T?
function Jl.reduce(fn, f, t, k)
    f, t, k = toiterator(f, t, k)
    local v
    k, v = assert(f(t, k))
    assert(k, "Can't reduce an empty collection.")
    for _, o in f, t, k do
        v = fn(v, o)
    end
    return v
end

---@class Jl.RegexMatch
---@field match string
---@field offset integer
---@field offsets integer[]
---@field captures string[]
-- @field regex? Jl.Regex
---@operator call(...): Jl.RegexMatch
Jl.RegexMatch = setmetatable({
    __name = "RegexMatch",
    __index = Jl.RegexMatch,
    __len = function(self) return #self.captures end
}, {
    --- Create a RegexMatch object to wrap results of a `match` call.
    ---@return Jl.RegexMatch
    __call = function(self, match, captures, offset, offsets, regex)
        return setmetatable({
            match = assert(type(match) == "string" and match),
            captures = captures or {},
            offset = offset or 1,
            offsets = offsets or {},
            regex = regex -- and (regex.__name == "Regex" or Jl.Regex(regex)) or regex
        }, self)
    end
})

---@param x number
---@param y number
---@param r Jl.RoundingMode?
---@return number
function Jl.rem(x, y, r) return x - y * Jl.round(x / y, r) end

---@param x number
---@param r Jl.RoundingMode?
---@return number
function Jl.rem2pi(x, r) return Jl.rem(x, 2 * math.pi, r) end

---@param xs string|any[]
---@param i integer
Jl["repeat"] = function(xs, i)
    if type(xs) == "string" then
        return string.rep(xs, i)
    elseif type(xs) == "table" then
        if i == 0 then return {} end
        local copy = table.pack(table.unpack(xs))
        for _ = 2, i do
            table.move(copy, 1, #copy, #xs + 1, xs)
        end
        return xs
    end
end

--- Return a copy of `xs` where each value `x` in `xs` is replaced by `new(x)`.
---@generic X
---@param new fun(x: X): X
---@param xs X[]
---@return X[] xs
function Jl.replace(new, xs)
    local result = {}
    for i, x in ipairs(xs) do
        result[i] = new(x)
    end
    return result
end

Jl.repr = tostring

function Jl.rethrow(...) error(...) end

function Jl.Returns(x) return function(...) return x end end

---@generic T
---@param xs T
---@return T
function Jl.reverse(xs)
    if type(xs) == "function" then
        local result = {}
        local x = xs()
        while x do
            table.insert(result, 1, x)
        end
        return Jl.Stateful(ipairs(result))
    elseif type(xs) == "string" then
        return xs:reverse()
    elseif type(xs) == "table" and not getmetatable(xs) then
        local result = {}
        for _, x in ipairs(xs) do
            table.insert(result, 1, x)
        end
        return result
    else
        return kcall(xs, "reverse")
    end
end

---@param s string
---@param i integer
function Jl.reverseind(s, i) return utf8.offset(s, -i) end

Jl.rm = os.remove

---@param x number
---@param r Jl.RoundingMode?
function Jl.round(x, r) return (r or Jl.RoundToZero)(x) end

---@param s string
---@param len integer
---@param c string?
function Jl.rpad(s, len, c)
    if #s >= len then
        return s
    else
        c = c or ' '
        return s .. c:rep(math.ceil(len / #c)):sub(1, len - #s)
    end
end

function Jl.sec(x) return 1 / math.cos(x) end

function Jl.secd(x) return 1 / math.deg(math.cos(x)) end

--- Seek a stream to the given position.
---@param stream file*
---@param pos integer
function Jl.seek(stream, pos) stream:seek("set", pos) end

---@param stream file*
function Jl.seekend(stream) stream:seek("end") end

---@param stream file*
function Jl.seekstart(stream) stream:seek("set") end

Jl.show = print

---@param x integer
---@return -1|0|1
function Jl.sign(x)
    local i = assert(math.tointeger(x),
        ("no method matching sign(::%s)"):format(type(x)))
    return i > 0 and 1 or i < 0 and -1 or 0
end

--- Doesn't match Jl when x is -0, because Lua doesn't have -0.
---@param x number
function Jl.signbit(x) return x < 0 end

function Jl.signed(x) return x end

Jl.sin = math.sin

function Jl.sinc(x)
    if x == 0 then
        return 1
    else
        local pix = math.pi * x
        return math.sin(pix) / pix
    end
end

function Jl.sincos(x) return math.sin(x), math.cos(x) end

function Jl.sincosd(x)
    return math.deg(math.sin(x)), math.deg(math.cos(x))
end

function Jl.sincospi(x)
    x = math.pi * x
    return math.sin(x), math.cos(x)
end

function Jl.sind(x) return math.deg(math.sin(x)) end

function Jl.sinpi(x) return math.sin(math.pi * x) end

function Jl.size(xs) return kcall(xs, "size") or Jl.length(xs) end

---@param x string|number|boolean
function Jl.sizeof(x)
    if type(x) == "number" then
        return 8
    elseif type(x) == "boolean" then
        return 1
    else
        return #x
    end
end

--- Seek a stream relative to the current position.
---@param s file*
---@param offset integer
function Jl.skip(s, offset) s:seek("cur", offset) end

--- Block the current task for a specified number of seconds. The minimum sleep
--- time is 1 millisecond or input of 0.001.
---@param seconds number
function Jl.sleep(seconds)
    if seconds < 0.001 then return end
    local now = os.time()
    repeat
    until os.difftime(os.time(), now) >= seconds
end

function Jl.something(...)
    for i = 1, select("#", ...) do
        local v = select(i, ...)
        if v ~= nil then
            return v
        end
    end
    error("\27[91mERROR:\27[m ArgumentError: No value arguments present")
end

function Jl.split(...) return Jl.collect(Jl.eachsplit(...)) end

Jl.sqrt = math.sqrt

function Jl.startswith(s, p)
    if not p then
        s, p = nil, s
    end
    if p[1] ~= "^" then p = "^" .. p end
    if s then
        return not not s:find(p)
    else
        return function(s) return not not s:find(p) end
    end
end

Jl.stderr = io.stderr
Jl.stdin = io.stdin
Jl.stdout = io.stdout

function Jl.step(x) return Jl.get(x, "step", 1) end

Jl.string = tostring

---@param s string
---@param cs string[]?
---@overload fun(pred: (fun(c: string): boolean), s: string): string
function Jl.strip(s, cs)
    if type(s) == "function" then
        return Jl.lstrip(s, Jl.rstrip(s, cs))
    else
        return Jl.lstrip(Jl.rstrip(s, cs), cs)
    end
end

function Jl.sum(...) return Jl.reduce(add, ...) end

function Jl.supertype(type) return getmetatable(type).__index end

function Jl.supertypes(type)
    local result = {}
    repeat
        type = Jl.supertype(type)
        table.insert(result, type)
    until type == Jl.Any or not type
    return table.unpack(result)
end

Jl.tan = math.tan
function Jl.tand(x) return math.deg(math.tan(x)) end

Jl.tempname = os.tmpname

Jl.time = os.time

--- `callback` is called every `pollint` seconds until `callback` returns a
--- truthy value or `timeout` seconds have elapsed.
---@param callback fun()
---@param timeout number
---@param pollint number|{pollint: number}? defaults to 0.1
---@return "ok"|"timed_out"
function Jl.timedwait(callback, timeout, pollint)
    local poll = Jl.get(pollint, "pollint", pollint or 0.1)
    local start = os.time()
    repeat
        if callback() then return "ok" end
        local now = os.time()
        repeat
        until os.difftime(now, os.time()) >= poll
    until os.difftime(start, os.time()) >= timeout
    return "timed_out"
end

---@param s string
function Jl.titlecase(s)
    return (s:gsub("%w+", function(ss)
            return ss:sub(1, 1):upper() .. ss:sub(2):lower()
        end))
end

---@param path string
function Jl.touch(path) io.open(path, "a+"):seek("end"):write(""):close() end

---@param ... integer
function Jl.trues(...) return Jl.fill(true, ...) end

function Jl.tuple(...) return ... end

function Jl.union(self, ...) return kcall(self, "union", ...) end

Jl.uppercase = string.upper

function Jl.uppercasefirst(s) return s[1]:upper() .. s:sub(2) end

Jl.vec = Jl.collect

function Jl.versioninfo() return _VERSION end

---@class Jl.VersionNumber: Jl.Any
---@field major integer
---@field minor integer
---@field patch integer
---@field prerelease string?
---@field build string?
---@operator call(table): Jl.VersionNumber
Jl.VersionNumber = setmetatable({
    __name = "VersionNumber",
    __index = Jl.VersionNumber,
    __eq = function(self, other)
        return self.major == other.major
            and self.minor == other.minor
            and self.patch == other.patch
    end,
    __tostring = function(self)
        return string.format("%i.%i.%i", self.major, self.minor, self.patch)
    end
}, {
    __call = function (self, major, minor, patch, prerelease, build)
        return setmetatable({
            major = major,
            minor = minor,
            patch = patch,
            prerelease = prerelease,
            build = build
        }, self)
    end,
    __index = Jl.Any
})

Jl.VERSION = Jl.VersionNumber(1, 8, 5)

---@param s string
function Jl.v(s)
    return Jl.VersionNumber(table.unpack(
        Jl.collect(Jl.map(tonumber, Jl.eachsplit(s, ".")))))
end

---@param s any[]|string
---@param range Jl.AbstractRange
function Jl.view(s, range)
    local result = {}
    for i in range do
        table.insert(result, s[i])
    end
    if type(s) == "string" then
        return table.concat(result)
    else
        return result
    end
end

function Jl.widemul(x, y) return x * y end

Jl.widen = Jl.identity

function Jl.xor(a, b, ...) return b and Jl.xor(a ~ b, ...) or a end

---@return 0
function Jl.zero(_) return 0 end

---@return 0[]
function Jl.zeros(_, len)
    local zs = {}
    for i = 1, len do
        zs[i] = 0
    end
    return zs
end

local stringmt = getmetatable("")
--- Index a string with an integer n to get the nth character
---@param s string
function stringmt.__index(s, k)
    local i = math.tointeger(k)
    if i then
        if i < 0 then i = i + #s end
        return s:match(utf8.charpattern, utf8.offset(s, i))
    else
        return string[k]
    end
end

function stringmt.__mul(s, ss) return s .. ss end

stringmt.__pow = string.rep

---@generic Table, Key, Value
---@alias stateful (fun(): Value?)|(fun(): Value?, Value?)
---@alias stateless fun(t: Table, k: Key?): Key?, Value?
---@alias iterator stateless|stateful

---Given a 2-argument function `combiner` and an iterator `iterator`,
---return a new iterator that successively applies `combiner` to the previous
---value and the next element of `iterator`.
---@generic Total, Value
---@param combiner fun(total: Total, value: Value): total: Total
---@param init Total
---@param iterator fun(...): Value, ...
---@return fun(key: any, value: Value, ...): ... stateful
function Jl.Iterators.accumulate(combiner, init, iterator, iterand, key)
    local total = init
    return function()
        local value
        key, value = iterator(iterand, key)
        if key ~= nil then
            total = combiner(total, value)
            return key, total
        end
    end
end

Jl.Iterators.collect = Jl.collect

---Counts how many items satisfy the predicate, or how many truthy items are in
---the iterator if no predicate is provided.
---@param predicate function optional, defaults to `identity`
---@return integer
function Jl.Iterators.count(predicate, iterator, iterand, key)
    if type(iterator) ~= "function" then
        predicate, iterator, iterand, key = Jl.identity, predicate, iterator,
            iterand
    end
    local result = 0
    for _, value in iterator, iterand, key do
        if predicate(value) then
            result = result + 1
        end
    end
    return result
end

local function countfromnext(step, total)
    return step + total, step + total
end

---Iterate counting from `start`, adding `step` on each iteration.
---@param start? number defaults to `1`
---@param step? number defaults to `1`
---@return fun(step: integer, total: integer): (total: integer), integer, integer
function Jl.Iterators.countfrom(start, step)
    step = step or 1
    start = start and (start - step) or 0
    return countfromnext, step, start
end

---Cycle through the values of the iterator `count` times, or forever if no count is provided.
---@param count? integer optional, defaults to looping forever
---@param iterator function
---@return function stateful
function Jl.Iterators.cycle(count, iterator, iterand, key)
    if type(count) == "function" then
        count, iterator, iterand, key = 1 / 0, count --[[@as function]], iterator, iterand
    elseif count == 0 then
        return Jl.identity
    end
    local exhausted = false
    local keys = {}
    local values = {}
    local index = 0
    return function()
        if not exhausted then
            local value
            key, value = iterator(iterand, key)
            if key ~= nil then
                table.insert(keys, key)
                table.insert(values, value)
                return value
            end
            exhausted = true
        end
        index = index + 1
        if index > #keys then
            index = 1
            count = count - 1
        end
        if count > 0 then
            return keys[index], values[index]
        end
    end
end

---Drop values from the start of an iterator.
---@param count? integer optional, defaults to `1`
---@param iterator function
---@return function iterator, ...
function Jl.Iterators.drop(count, iterator, iterand, key)
    if type(count) ~= "number" then
        count, iterator, iterand, key = 1, count --[[@as function]], iterator, iterand
    end
    for _ = 1, count do
        key = iterator(iterand, key)
        if key == nil then
            break
        end
    end
    return iterator, iterand, key
end

---Wraps an iterator, replacing its keys with a series of numbers.
---@param init? number defaults to `1`
---@param step? number defaults to `1`
---@generic Value, Iterand, Key
---@param iterand Iterand
---@param key Key
---@param iterator fun(i:Iterand, k:Key): Value, Key
---@return fun(): number, Value iterator, Iterand, Key
function Jl.Iterators.enumerate(init, step, iterator, iterand, key)
    if type(init) ~= "number" then
        init, step, iterator, iterand, key = 1, init, step --[[@as function]], iterator, iterand
    end
    if type(step) ~= "number" then
        step, iterator, iterand, key = 1, step --[[@as function]], iterator, iterand
    end
    return function(step, i)
            local value
            key, value = iterator(iterand, key)
            return i + step, value
        end, step, init - step
end

---Filter out values which do not satisfy the predicate from the iterator.
---@param predicate function
---@param iterator function
---@return stateful iterator
function Jl.Iterators.filter(predicate, iterator, iterand, key, ...)
    return function()
        local value
        repeat
            key, value = iterator(iterand, key)
        until key == nil or predicate(value)
        return key, value
    end
end

function Jl.Iterators.flatten(...)
    local iterators, outerkey = { ... }, 0
    local innerkey, value, iterator, iterand
    local function flattennext()
        if innerkey == nil then
            outerkey = outerkey + 1
            if outerkey > #iterators then
                return
            end
            iterator, iterand, innerkey = table.unpack(iterators[outerkey])
        end
        innerkey, value = iterator(iterand, innerkey)
        if innerkey == nil then
            return flattennext()
        end
        return innerkey, value
    end

    return flattennext
end

---Call `mapper` on each value of `iterator`.
---@param mapper fun(value, key, iterand): newvalue: any`
---@param iterator function
---@return function stateful
function Jl.Iterators.map(mapper, iterator, iterand, key)
    return function()
        local value
        key, value = iterator(iterand, key)
        if key ~= nil then
            return key, mapper(value, key, iterand)
        end
    end
end

---Returns the only value returned by the iterator, or throws an error.
---@param iterator function
function Jl.Iterators.only(iterator, iterand, key)
    local value
    key, value = iterator(iterand, key)
    local next_key = iterator(iterand, key)
    if key and not next_key then
        return key, value
    else
        error("Expected the iterator to only have one element.")
    end
end

function Jl.Iterators.partition(collection, n)
    -- todo this, but copying Jl instead of doing random shit
end

--- The product of several iterators, i.e. the pairwise combinations
--- of the results of each iterator.
---@generic A, B
---@param iter1 fun(): A?
---@param iter2 fun(): B?
---@return fun():{[1]: A, [2]: B}? product
function Jl.Iterators.product(iter1, iter2)
    return function()
        -- todo all the mad shit the docstring promised
    end
end

Jl.Iterators.range = Jl.range

local function forevernext(value)
    return value, value
end

local function repeatednext(value, count)
    if count > 0 then return count - 1, value end
end

---Return `value` `count` times, or forever if no `count` is provided.
---@generic Value
---@param value Value
---@param count? integer optional, defaults to forever
---@return fun(value: Value, count?: integer): value: Value? iterator, Value value, integer?
function Jl.Iterators.repeated(value, count)
    if count == nil then
        return forevernext, value
    elseif count >= 0 then
        return repeatednext, value, count
    else
        error("Can't repeat a value " .. count .. " times.")
    end
end

---Close over a stateless iterator, converting it to a stateful iterator.
---Passing `true` to a stateful iterator peeks at the next state without advancing.
---@param iterator function
function Jl.Iterators.Stateful(iterator, iterand, key)
    -- todo: proper generics
    iterator, iterand, key = toiterator(iterator, iterand, key)
    return function()
        local value
        key, value = iterator(iterand, key)
        return key, value
    end
end

---Take the first `count` values from `iterator`.
---@param count integer
---@param iterator function
---@return function stateful
function Jl.Iterators.take(count, iterator, iterand, key)
    iterator, iterand, key = toiterator(iterator, iterand, key)
    return function()
        local value
        count = count - 1
        if count >= 0 then
            key, value = iterator(iterand, key)
            return key, value
        end
    end
end

---Returns the values of the iterator until a value does not fulfill the predicate.
---@param predicate function
---@param iterator function
---@return function stateful
function Jl.Iterators.takewhile(predicate, iterator, iterand, key)
    iterator, iterand, key = toiterator(iterator, iterand, key)
    return function()
        local value
        key, value = iterator(iterand, key)
        if predicate(value) then
            return key, value
        end
    end
end

---Iterate over unique values of the given iterator.
---@generic Iterand, Key, Value
---@param iterator fun(iterand: Iterand, key?: Key): Value?
---@param iterand Iterand
---@param key Key
---@return fun(): key: Key?, value: Value? stateful
function Jl.Iterators.unique(iterator, iterand, key)
    iterator, iterand, key = toiterator(iterator, iterand, key)
    local seen = {}
    local seennil = false
    return function()
        local value
        repeat
            key, value = iterator(iterand, key)
        until key == nil or (value == nil and seennil or seen[value])
        if value == nil then
            seennil = true
        else
            seen[value] = true
        end
        return key, value
    end
end

--- Zip a group of iterators together. Each Lua iterator must be stateful due to
--- differences between the Lua and Jl iterator protocols.
---@param ... stateful
---@return stateful iterator
function Jl.Iterators.zip(...)
    ---@type table?
    local iters = table.pack(...)
    return function()
        if not iters then return end
        local result = {}
        for _, iter in ipairs(iters) do
            local value = iter()
            if value == nil then
                iters = nil
                return
            end
            table.insert(result, value)
        end
        return table.unpack(result)
    end
end

return Jl
