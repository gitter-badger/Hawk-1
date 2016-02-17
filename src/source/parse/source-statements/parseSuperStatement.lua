
 -- 'super' [ '(' EXPRLIST ')' ] ';'

local function parseSourceSuperStatement( session, source, line )
	local lexer = session.lexer
	local list = lexer:consume( "Symbol", "(" ) and parseSourceExpressionList( session ) or {}

	return lexer:consume( "Symbol", ";" ) and {
		source = source, line = line;
		type = "super";
		value = list;
	} or lexer:throw "expected ';'"
end
