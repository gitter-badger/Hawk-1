
local function newCompilerNamespace()
	local classes = {}
	local interfaces = {}
	local namespace = newCompilerIndexable()

	function namespace:addClass( name, value )
		classes[name] = value
	end

	function namespace:getClass( name )
		return classes[name]
	end

	function namespace:addInterface( name, value )
		interfaces[name] = value
	end

	function namespace:getInterface( name )
		return interfaces[name]
	end

	return namespace
end
