
@include compile-std.array
@include compile-std.table

local arraycache = {}
local tablecache = {}

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
