
local function newCompilerNamespace()
	local classes = {}
	local enums = {}
	local namespace = newCompilerIndexable( {}, {} )

	function namespace:addClass( name, value )
		classes[name] = value
	end

	function namespace:getClass( name )
		return classes[name]
	end

	return namespace
end
