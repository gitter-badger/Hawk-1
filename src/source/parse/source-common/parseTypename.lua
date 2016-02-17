
 -- NAMESPACE

local function parseSourceTypename( session )
	local lexer = session.lexer
	local token = lexer:test "Identifier"
	local start = lexer:mark()
	local name = token and parseSourceName( session )

	if name then
		local typename = session.environment:resolve( name )
		if typename then
			local type = session.environment:getEnvironmentType( typename )
			if type == "class" or type == "classdecl" or type == "enum" then
				return typename
			else
				lexer:home()
				return false, "invalid typename"
			end
		else
			lexer:home()
			return false, "undefined reference"
		end
	else
		lexer:home()
		return false, "expected typename"
	end
end
