
local function newCompileTypeArray( value )
	local class = newSourceCompilerClass( value:tostring() .. "[]" )

	class:addPublicMethod( "operator[]", value, { { class = compileTypeInt } } )
	class:addPublicMethod( "operator[]", value, { { class = compileTypeInt }, { class = value } } )

	return class
end
