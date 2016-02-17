
compileTypeString.instance:addPublicMethod( "sub", compileTypeString, {
	{ class = compileTypeInt };
} )
compileTypeString.instance:addPublicMethod( "sub", compileTypeString, {
	{ class = compileTypeInt };
	{ class = compileTypeInt };
} )

compileTypeString.instance:addPublicMethod( "find", compileTypeInt, {
	{ class = compileTypeString };
	{ class = compileTypeInt, default = { type = "IntegerType", value = 0 } }
} )

compileTypeString.instance:addPublicMethod( "match", compileTypeString, {
	{ class = compileTypeString };
	{ class = compileTypeInt, default = { type = "IntegerType", value = 0 } }
} )
