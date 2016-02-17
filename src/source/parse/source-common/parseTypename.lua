
 -- NAMESPACE

local function parseSourceTypename( session )
	local lexer = session.lexer
	local token = lexer:test "Identifier"
	local name = token and parseSourceName( session )

	return token and session.environment:isType( name )  and name
end
