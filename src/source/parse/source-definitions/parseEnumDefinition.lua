
 -- 'enum' Identifier '{' Identifier { ( ',' | ';' ) Identifier } '}'

local function parseSourceEnumDefinition( session, source, line )
	local lexer = session.lexer
	local name = lexer:test "Identifier" and lexer:next().value or lexer:throw "expected enum name"
	local body = lexer:consume( "Symbol" ) and { lexer:test "Identifier" and lexer:next().value or lexer:throw "expected identifier in enum body" } or lexer:throw "expected '{'"

	while lexer:consume( "Symbol", "," ) or lexer:consume( "Symbol", ";" ) do
		body[#body + 1] = lexer:test "Identifier" and lexer:next().value or lexer:throw "expected identifier in enum body"
	end

	session.environment:addEnum( name )

	return lexer:consume( "Symbol", "}" ) and {
		source = source, line = line;
		type = "enum";
		name = session.environment:resolve( name );
		value = body;
	} or lexer:throw "expected '}'"
end
