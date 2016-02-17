
 -- 'class' Identifier ['extends' NAMESPACE] ['implements' INTERFACELIST] ( CLASSBODY | ';' )

local function parseSourceClassDefinition( session, source, line )
	local lexer = session.lexer
	local name = lexer:test "Identifier" and lexer:next().value or lexer:throw "expected class name"
	local extends, implements = nil, {}
	local body

	session.environment:addClass( name )

	if lexer:consume( "Keyword", "extends" ) then
		extends = lexer:test "Identifier" and lexer:next().value or lexer:throw "expected super class name"

		if not session.environment:isClass( extends ) then
			lexer:back()
			lexer:throw "expected super class name"
		end
	end
	if lexer:consume( "Keyword", "implements" ) then
		implements = parseSourceImplementationList( session )
	end

	if lexer:consume( "Symbol", ";" ) then
		body = { {}, {}, {}, {} }
	elseif lexer:consume( "Symbol", "{" ) then
		body = parseSourceClassBody( session, name )
	else
		lexer:throw "expected '{'"
	end

	return {
		source = source, line = line;
		type = "class";
		name = name;
		extends = extends;
		implements = implements;
		body = body;
	}
end
