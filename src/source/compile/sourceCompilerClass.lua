
local function newSourceCompilerClass( name, members, methods, casts )
	local class = {}

	class.index = newSourceCompilerIndexable( members, methods )

	function class:init( params )
		if self.instance and self.instance.index:call( name, false, params ) then
			return self.instance
		end
	end

	function class:castsTo( type )
		return casts[type]
	end

	function class:addCast( type, ... )
		casts[type] = true
		if ... then
			self:addCast( ... )
		end
	end

	return class
end
