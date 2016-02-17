
 -- 'continue' ';'

local function parseSourceContinueStatement( session, source, line )
	return session.lexer:consume( "Symbol", ";" ) and {
		source = source, line = line;
		type = "continue";
	} or session.lexer:throw "expected ';' after 'continue'"
end
