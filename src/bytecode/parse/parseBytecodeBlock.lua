
function parseBytecodeBlock( lexer )
	local argc = 0

	if lexer:consume( "Symbol", "(" ) then
		argc = lexer:test "IntegerNumber" and tonumber( lexer:next().value ) or lexer:throw "expected parameter count"

		if not lexer:consume( "Symbol", ")" ) then
			lexer:throw "expected closing ')'"
		end
	end

	if lexer:consume( "Symbol", "{" ) then
		local environment, instructions = parseBytecodeBody( lexer )
		return {
			type = "block";
			argc = argc;
			environment = environment;
			instructions = instructions;
		}
	else
		lexer:throw "expected '{'"
	end
end
