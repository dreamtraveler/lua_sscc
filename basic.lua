function _G.dump(o, x)
    local indent = x or 0
    if type(o) == 'table' then
        local s = '{ '
        for k,v in pairs(o) do
            if type(k) ~= 'number' then k = '"'..k..'"' end
            local idt = '\n' .. string.rep(" ", 4 * indent)
            s = s .. idt .. '['..k..'] = ' .. _G.dump(v, indent + 1) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

function _G.dump_deep1(o, x)
    local indent = x or 0
    if type(o) == 'table' then
        local s = '{ '
        for k,v in pairs(o) do
            if type(k) ~= 'number' then k = '"'..k..'"' end
            local idt = '\n' .. string.rep(" ", 4 * indent)
            if indent == 1 then
		        s = s .. idt .. '['..k..'] = ' .. tostring(v) .. ','
            else
		        s = s .. idt .. '['..k..'] = ' .. _G.dump_deep1(v, indent + 1) .. ','
            end
        end
        return s .. '} '
	else
        return tostring(o)
    end
end

local function deepcopy_1(t)
	local t2 = {}
	for k, v in pairs(t) do
		if type(v) ~= 'function' then
			t2[k] = v
		end
	end
	return t2
end

local _M = {}
function _M:New(name)
	local o = deepcopy_1(self)
	o.typename = o.typename or name
	o.name = name
	setmetatable(o, {__index = self, __call = self.New})
	return o
end

setmetatable(_M, {__call = _M.New})
return _M
