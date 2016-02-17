
local function flatten( t )
	local o = {}
	for i = 1, #t do
		for n = 1, #t[i] do
			o[#o + 1] = t[i][n]
		end
	end
	return o
end

local function add( t, v )
	t[#t + 1] = v
	return t
end

local function lookup( t, v, m )
	if t[v] then return t[v] end
	for i = 1, #m do
		if t[m[i] .. "::" .. v] then return t[m[i] .. "::" .. v] end
	end
	return false
end

local function newSourceEnvironment()
	local environment = {}
	local namespace = {}
	local using = { { "std" } }
	local scope = {}

	local env = {}

	function env:pushNamespace( name )
		namespace[#namespace + 1] = name
		using[#using + 1] = {}
		environment[self:getNamespace()] = "namespace"
	end

	function env:popNamespace()
		namespace[#namespace] = nil
		using[#using] = nil
	end

	function env:using( name )
		using[#using][#using[#using] + 1] = name
	end

	function env:getNamespace()
		return table.concat( namespace, "::" )
	end

	function env:addToEnvironment( name, value )
		local prefix = #namespace == 0 and "" or table.concat( namespace, "::" ) .. "::"
		environment[prefix .. name] = value
	end

	function env:push()
		scope[#scope + 1] = {}
	end

	function env:pop()
		scope[#scope] = nil
	end

	function env:definelocal( name )
		scope[#scope][name] = true
	end

	function env:addEnum( name )
		return env:addToEnvironment( name, "enum" )
	end

	function env:addClass( name )
		return env:addToEnvironment( name, "class" )
	end

	function env:addType( name )
		local prefix = #namespace == 0 and "" or table.concat( namespace, "::" ) .. "::"
		environment[prefix .. name] = "type"
	end

	function env:isType( name )
		local t = lookup( environment, name, add( flatten( using ), table.concat( namespace, "." ) ) )
		return t == "class" or t == "enum" or t == "type"
	end

	function env:isClass( name )
		return lookup( environment, name, add( flatten( using ), table.concat( namespace, "." ) ) ) == "class"
	end

	function env:addInterface( name )
		local prefix = #namespace == 0 and "" or table.concat( namespace, "::" ) .. "::"
		environment[prefix .. name] = "interface"
	end

	function env:isInterface( name )
		return lookup( environment, name, add( flatten( using ), table.concat( namespace, "." ) ) ) == "interface"
	end

	return env
end
