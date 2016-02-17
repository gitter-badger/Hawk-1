
local compileTypeByte = newSourceCompilerIndexable( {}, {} )
local compileTypeInt = newSourceCompilerIndexable( {}, {} )
local compileTypeFloat = newSourceCompilerIndexable( {}, {} )
local compileTypeDouble = newSourceCompilerIndexable( {}, {} )
local compileTypeChar = newSourceCompilerIndexable( {}, {} )
local compileTypeString = newSourceCompilerIndexable( {}, {} )
local compileTypeBool = newSourceCompilerIndexable( {}, {} )
local compileTypeVoid = newSourceCompilerIndexable( {}, {} )

@include compile-std.byte
@include compile-std.int
@include compile-std.float
@include compile-std.double
@include compile-std.char
@include compile-std.string
@include compile-std.bool
@include compile-std.void

compileTypeByte:addCast( compileTypeChar, compileTypeInt, compileTypeDouble, compileTypeFloat, compileTypeString )
compileTypeInt:addCast( compileTypeChar, compileTypeByte, compileTypeDouble, compileTypeFloat, compileTypeString )
compileTypeFloat:addCast( compileTypeInt, compileTypeByte, compileTypeDouble, compileTypeString )
compileTypeDouble:addCast( compileTypeInt, compileTypeByte, compileTypeFloat, compileTypeString )
compileTypeChar:addCast( compileTypeInt, compileTypeByte, compileTypeString )
compileTypeBool:addCast( compileTypeInt, compileTypeByte, compileTypeString )
compileTypeVoid:addCast( compileTypeString )
