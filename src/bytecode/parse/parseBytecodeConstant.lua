
local function parseBytecodeConstant( lexer )
	return lexer:consume "HexNumber" or lexer:consume "BinaryNumber"
	or lexer:consume "IntegerNumber" or lexer:consume "ByteNumber"
	or lexer:consume "DoubleNumber" or lexer:consume "FloatNumber"
	or lexer:consume "Boolean" or lexer:consume "Null"
	or lexer:consume "String"
	or lexer:throw "expected constant"
end
