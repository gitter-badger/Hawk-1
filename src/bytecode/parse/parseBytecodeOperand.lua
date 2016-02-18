
local function parseBytecodeOperand( lexer )
	if lexer:consume( "Symbol", "-" ) then
		return lexer:test "IntegerNumber" and tonumber( lexer:next().value ) or lexer:throw "expected integer after '-'"
	elseif lexer:consume( "Symbol", "#" ) then
		local initial = lexer:test "Identifier" and lexer:next().value or lexer:throw "expected identifier after '#'"

		while lexer:consume( "Symbol", "::" ) do
			initial = initial .. ( lexer:test "Identifier" and lexer:next().value or lexer:throw "expected identifier after '::'" )
		end

		return initial
	elseif lexer:test "IntegerNumber" then
		return tonumber( lexer:next().value )
	else
		lexer:throw "expected signed integer or lookup"
	end
end
