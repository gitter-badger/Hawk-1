
local function parseBytecodeInstructions( lexer )
	local instructions = {}
	local source, line = "", 0

	while not lexer:consume( "Symbol", "}" ) do
		while lexer:consume "Newline" do end

		if lexer:test "String" then
			source = lexer:next().value
		end

		if lexer:test "IntegerNumber" then
			line = tonumber( lexer:next().value )
		end

		local t = lexer:consume "Identifier"
		local instruction = t and t.value or lexer:throw "expected identifier instruction"
		local params = {}

		while not lexer:consume "Newline" and not lexer:consume( "Symbol", ";" ) and not lexer:test( "Symbol", "}" ) do
			params[#params + 1] = parseBytecodeOperand( lexer )
		end

		instructions[#instructions + 1] = {
			source = t.source, line = t.line;
			instruction = instruction;
			params = params;
			isource = source; -- source of the instruction in its source code not in bytecode
			iline = line;
		}
	end

	return instructions
end
