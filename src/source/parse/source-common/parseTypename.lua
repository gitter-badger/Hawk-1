
 -- NAMESPACE

local function parseSourceTypename( session )
	local lexer = session.lexer
	local token = lexer:test "Identifier"
	local start = lexer:mark()
	local name = token and parseSourceName( session )

	if token and session.environment:isType( name ) then
		return name
	else
		lexer:home()
	end
end
