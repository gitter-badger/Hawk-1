
 -- 'typename' Identifier '=' TYPE ';'

local function parseSourceTypenameStatement( session, source, line )
	local lexer = session.lexer
	local name = lexer:test "Identifier" and lexer:next().value or lexer:throw "expected type name"
	local deftype = lexer:consume( "Symbol", "=" ) and ( parseSourceType( session ) or lexer:throw "expected valid type" ) or lexer:throw "expected '='"

	session.environment:addType( name )

	return lexer:consume( "Symbol", ";" ) and {
		source = source, line = line;
		type = "typedef";
		name = name;
		deftype = deftype;
	} or lexer:throw "expected ';'"
end
