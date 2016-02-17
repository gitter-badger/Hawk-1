
 -- 'class' Identifier ['extends' NAMESPACE] ['implements' INTERFACELIST] ( CLASSBODY | ';' )

local function parseSourceClassDefinition( session, source, line )
	local lexer = session.lexer
	local name = lexer:test "Identifier" and lexer:next().value or lexer:throw "expected class name"
	local extends, implements = nil, {}
	local body, err

	local nameres = session.environment:resolve( name )

	if nameres and session.environment:getEnvironmentType( nameres ) ~= "classdecl" then
		lexer:back()
		lexer:throw( "name '" .. name .. "' cannot be overwritten" )
	end

	if lexer:consume( "Symbol", ";" ) then
		session.environment:declareClass( name )
		return {
			source = source, line = line;
			type = "classdecl";
			name = session.environment:resolve( name );
		}
	end

	if lexer:consume( "Keyword", "extends" ) then
		lexer:mark()
		extends, err = parseSourceTypename( session )

		if not extends then
			lexer:throw( err:gsub( "typename", "super class name" ) )
		end

		local type = session.environment:getEnvironmentType( extends )

		if type == "classdecl" then
			lexer:home()
			lexer:throw "cannot extend from declared class"
		elseif type ~= "class" then
			lexer:home()
			lexer:throw( "cannot extend from " .. type )
		end
	end
	if lexer:consume( "Keyword", "implements" ) then
		implements = parseSourceImplementationList( session )
	end

	if lexer:consume( "Symbol", "{" ) then
		session.environment:addClass( name )
		body = parseSourceClassBody( session, name )
	else
		lexer:throw "expected '{'"
	end

	return {
		source = source, line = line;
		type = "class";
		name = session.environment:resolve( name );
		extends = extends;
		implements = implements;
		body = body;
	}
end
