
 -- 'new' TYPENAME Identifier [ '(' EXPRLIST ')' ] ';'

local function parseSourceNewStatement( session, source, line )
	local lexer = session.lexer
	local start = lexer:mark()
	local typename, err = parseSourceTypename( session )
	local type = session.environment:getEnvironmentType( typename )

	if not typename then
		lexer:throw( err )
	elseif type == "classdecl" then
		lexer:home()
		lexer:throw "cannot instantiate a class declaration"
	elseif type == "enum" then
		lexer:home()
		lexer:throw "cannot instantiate an enum"
	end

	local objectname = lexer:test "Identifier" and lexer:next().value or lexer:throw "expected object name"
	local paramlist = lexer:consume( "Symbol", "(" ) and parseSourceExpressionList( session, ")" ) or {}

	session.environment:definelocal( objectname )

	return lexer:consume( "Symbol", ";" ) and {
		source = source, line = line;
		type = "new";
		typename = typename;
		objectname = objectname;
		paramlist = paramlist;
	}
end
