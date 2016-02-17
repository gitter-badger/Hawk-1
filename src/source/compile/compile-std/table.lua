
local function newCompileTypeTable( value, index )
	local class = newSourceCompilerClass( value:tostring() .. "[]" )

	class:addPublicMethod( "operator[]", value, { { class = index } } )
	class:addPublicMethod( "operator[]", value, { { class = index }, { class = value } } )

	return class
end
