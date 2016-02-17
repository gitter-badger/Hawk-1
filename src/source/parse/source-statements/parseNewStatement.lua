
 -- 'new' TYPENAME Identifier [ '(' EXPRLIST ')' ] ';'

local function parseSourceNewStatement( session, source, line )
	local lexer = session.lexer
	local start = lexer:mark()
	local typename = parseSourceName( session )
	local objectname = lexer:test "Identifier" and lexer:next().value or lexer:throw "expected object name"
	local paramlist = lexer:consume( "Symbol", "(" ) and parseSourceExpressionList( session, ")" ) or {}

	if not session.environment:isType( typename ) then
		lexer:home()
		lexer:throw "invalid typename"
	end

	return lexer:consume( "Symbol", ";" ) and {
		source = source, line = line;
		type = "new";
		typename = typename;
		objectname = objectname;
		paramlist = paramlist;
	}
end
