
 -- 'using' NAMESPACE ';'

local function parseSourceUsingStatement( session, source, line )
	local lexer = session.lexer
	local home = lexer:mark()
	local name = parseSourceName( session ) or lexer:throw "expected source name"

	local ok, err = session.environment:using( name )

	if not ok then
		lexer:home()
		lexer:throw( err )
	end

	if not lexer:consume( "Symbol", ";" ) then
		lexer:throw "expected ';'"
	end
end
