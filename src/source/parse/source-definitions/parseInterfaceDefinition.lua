
 -- 'interface' Identifier ['implements' INTERFACELIST] ( CLASSBODY | ';' )

local function parseSourceInterfaceDefinition( session, source, line )
	local lexer = session.lexer
	local name = lexer:test "Identifier" and lexer:next().value or lexer:throw "expected interface name"
	local implements = {}
	local body

	if session.environment:resolve( name ) then
		lexer:back()
		lexer:throw( "name '" .. name .. "' cannot be overwritten" )
	end

	session.environment:addInterface( name )

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
		type = "interface";
		name = session.environment:resolve( name );
		implements = implements;
		body = body;
	}
end
