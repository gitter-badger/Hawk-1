
 -- 'typename' Identifier '=' TYPE ';'

local function parseSourceTypenameStatement( session, source, line )
	local lexer = session.lexer
	local name = lexer:test "Identifier" and lexer:next().value or lexer:throw "expected type name"
	local deftype, err

	if lexer:consume( "Symbol", ":" ) or lexer:consume( "Symbol", ":" ) then
		deftype, err = parseSourceType( session )
	else
		lexer:throw "expected '='"
	end

	if not deftype then
		lexer:throw( err )
	end

	local deftype_envtype = session.environment:getEnvironmentType( deftype )

	if deftype_envtype == "class" or deftype_envtype == "classdecl" then
		session.environment:declareClass( name )
	elseif deftype_envtype == "enum" then
		session.environment:addEnum( name )
	end

	return lexer:consume( "Symbol", ";" ) and {
		source = source, line = line;
		type = "typedef";
		name = session.environment:resolve( name );
		deftype = deftype;
	} or lexer:throw "expected ';'"
end
