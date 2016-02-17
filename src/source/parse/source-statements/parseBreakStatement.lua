
 -- 'break' ';'

local function parseSourceBreakStatement( session, source, line )
	return session.lexer:consume( "Symbol", ";" ) and {
		source = source, line = line;
		type = "break";
	} or session.lexer:throw "expected ';' after 'break'"
end
