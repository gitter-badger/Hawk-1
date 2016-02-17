
 -- 'throw' Identifier EXPR ';'

local function parseSourceThrowStatement( session, source, line )
	local lexer = session.lexer
	local exceptiontype = lexer:test "Identifier" and lexer:next().value or lexer:throw "expected exception type"
	local value = parseSourceExpression( session )

	return lexer:consume( "Symbol", ";" ) and {
		source = source, line = line;
		type = "throw";
		etype = exceptiontype;
		value = value;
	} or lexer:throw "expected ';'"
end
