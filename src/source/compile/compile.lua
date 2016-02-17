
local arraycache = {}
local tablecache = {}

@include sourceCompilerEnvironment
@include sourceCompilerIndexable
@include sourceCompilerClass
@include sourceCompilerNamespace

@include compile-std.std

local function arrayOf( value )
	if not arraycache[value] then
		arraycache[value] = newCompileTypeArray( value )
	end
	return arraycache[value]
end

local function tableOf( value, index )
	if not tablecache[value] then
		tablecache[value] = {}
	end
	if not tablecache[value][index] then
		tablecache[value][index] = newCompileTypeTable( value, index )
	end
	return tablecache[value][index]
end

@include compile-1.sourceClassFlattener
@include compile-1.isSourceStatementTerminal
