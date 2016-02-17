
compileTypeFloat.instance:addPublicMethod( "floor", compileTypeInt, {} )
compileTypeFloat.instance:addPublicMethod( "ceil", compileTypeInt, {} )
compileTypeFloat.instance:addPublicMethod( "round", compileTypeInt, { {
	class = compileTypeInt;
	default = { type = "IntegerNumber", value = 0 };
} } )

compileTypeFloat:addPublicMember( "random", compileTypeFloat.instance )
