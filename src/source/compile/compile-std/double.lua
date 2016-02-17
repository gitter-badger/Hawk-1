
compileTypeDouble:addMethod( "floor", {}, compileTypeInt )
compileTypeDouble:addMethod( "ceil", {}, compileTypeInt )
compileTypeDouble:addMethod( "round", { {
	class = compileTypeInt;
	default = { type = "IntegerNumber", value = 0 };
} }, compileTypeInt )
