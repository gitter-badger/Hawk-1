
local compileTypeByte = newSourceCompilerClass( "byte" )
local compileTypeInt = newSourceCompilerClass( "int" )
local compileTypeFloat = newSourceCompilerClass( "float" )
local compileTypeDouble = newSourceCompilerClass( "double" )
local compileTypeChar = newSourceCompilerClass( "char" )
local compileTypeString = newSourceCompilerClass( "string" )
local compileTypeBool = newSourceCompilerClass( "bool" )
local compileTypeVoid = newSourceCompilerClass( "void" )

compileTypeByte.instance = newSourceCompilerClass( "byte" )
compileTypeInt.instance = newSourceCompilerClass( "int" )
compileTypeFloat.instance = newSourceCompilerClass( "float" )
compileTypeDouble.instance = newSourceCompilerClass( "double" )
compileTypeChar.instance = newSourceCompilerClass( "char" )
compileTypeString.instance = newSourceCompilerClass( "string" )
compileTypeBool.instance = newSourceCompilerClass( "bool" )
compileTypeVoid.instance = newSourceCompilerClass( "void" )

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

@include compile-std.array
@include compile-std.table
