
 -- 'using' NAMESPACE ';'

local function parseSourceUsingStatement( session, source, line )
	local lexer = session.lexer
	local name = parseSourceName( session ) or lexer:throw "expected source name"

	session.environment:use( name )

	return lexer:consume( "Symbol", ";" ) and {
		source = source, line = line;
		type = "using";
		value = name;
	} or lexer:throw "expected ';'"
end
