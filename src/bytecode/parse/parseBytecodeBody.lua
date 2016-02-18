
local function parseBytecodeBody( lexer )
	local environment = {}
	local instructions = {}

	while not lexer:consume( "Symbol", "}" ) do
		while lexer:consume "Newline" do end -- skip past trailing newlines

		if lexer:consume( "Keyword", "const" ) then
			environment[#environment + 1] = parseBytecodeConstant( lexer )
		elseif lexer:consume( "Keyword", "upvalue" ) then
			environment[#environment + 1] = parseBytecodeUpvalue( lexer )
		elseif lexer:consume( "Keyword", "block" ) then
			environment[#environment + 1] = parseBytecodeBlock( lexer )
		elseif lexer:consume( "Keyword", "body" ) then
			if lexer:consume( "Symbol", ":" ) then
				instructions = parseBytecodeInstructions( lexer )
				break
			else
				lexer:throw "expected ':'"
			end
		else
			lexer:throw "unexpected symbol"
		end
	end

	return environment, instructions
end
