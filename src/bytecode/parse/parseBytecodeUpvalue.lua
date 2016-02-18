
local function parseBytecodeUpvalue( lexer )
	local t = lexer:next()
	local source = t.source
	local line = t.line

	lexer:back()

	local level = lexer:test "IntegerNumber" and tonumber( lexer:next().value ) or lexer:throw "expected upvalue level"
	local index = lexer:test "IntegerNumber" and tonumber( lexer:next().value ) or lexer:throw "expected upvalue index"

	return {
		source = source, line = line; -- need this because what if you have 1e20 as an upvalue level, huh? you error, that's what
		type = "upvalue";
		level = level;
		index = index;
	}
end
