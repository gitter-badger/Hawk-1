
compileTypeDouble.instance:addPublicMethod( "floor", compileTypeInt, {} )
compileTypeDouble.instance:addPublicMethod( "ceil", compileTypeInt, {} )
compileTypeDouble.instance:addPublicMethod( "round", compileTypeInt, { {
	class = compileTypeInt;
	default = { type = "IntegerNumber", value = 0 };
} } )

compileTypeDouble:addPublicMember( "random", compileTypeDouble.instance )
