
 -- Identifier {'::' Identifier}

local function parseSourceName( session )
	local lexer = session.lexer
	local ident = lexer:test "Identifier" and lexer:next().value or lexer:throw "expected identifier"

	while lexer:consume( "Symbol", "::" ) do
		ident = ident .. "::" .. (lexer:test "Identifier" and lexer:next().value or lexer:throw "expected identifier after '.'")
	end

	return ident
end
