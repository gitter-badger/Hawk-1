
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
		local res = self:resolve( name )
		if res then
			if self:getEnvironmentType( res ) == "namespace" then
				using[#using][#using[#using] + 1] = res
				return true
			else
				return false, "expected namespace"
			end
		else
			return false, "undefined reference"
		end
	end

	function env:getNamespace()
		return table.concat( namespace, "::" )
	end

	function env:addToEnvironment( name, value )
		local prefix = #namespace == 0 and "" or table.concat( namespace, "::" ) .. "::"
		environment[prefix .. name] = value
		return prefix .. name
	end

	function env:push()
		scope[#scope + 1] = {}
		using[#using + 1] = {}
	end

	function env:pop()
		scope[#scope] = nil
		using[#using] = nil
	end

	function env:definelocal( name )
		if #scope == 0 then
			if #namespace == 0 then
				environment[name] = "value"
			else
				environment[self:getNamespace() .. "::" .. name] = "value"
			end
		else
			scope[#scope][name] = true
		end
	end

	function env:addEnum( name )
		return env:addToEnvironment( name, "enum" )
	end

	function env:declareClass( name )
		return env:addToEnvironment( name, "classdecl" )
	end

	function env:addClass( name )
		return env:addToEnvironment( name, "class" )
	end

	function env:addInterface( name )
		return env:addToEnvironment( name, "interface" )
	end

	function env:getEnvironmentType( name )
		return environment[name]
	end

	function env:testNewEnvironmentType( name )
		return self:getEnvironmentType( ( #namespace == 0 and "" or table.concat( namespace, "::" ) .. "::" ) .. name )
	end

	function env:resolve( name )
		for i = #scope, 1, -1 do
			if scope[i][name] then
				return name
			end
		end

		if #namespace > 0 and environment[self:getNamespace() .. "::" .. name] then
			return self:getNamespace() .. "::" .. name
		elseif #namespace == 0 and environment[name] then
			return name
		end
		
		for i = #using, 1, -1 do
			for n = #using[i], 1, -1 do
				if environment[using[i][n] .. "::" .. name] then
					return using[i][n] .. "::" .. name
				end
			end
		end
	end

	return env
end
