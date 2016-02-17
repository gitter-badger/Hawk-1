
 -- 'foreach' Identifier [',' Identifier] 'in' EXPR BLOCK
 -- 'foreach' '(' Identifier [',' Identifier] 'in' EXPR ')' BLOCK

local function parseSourceForeachStatement( session, source, line )
	local lexer = session.lexer
	local needsClosingBracket = lexer:consume( "Symbol", "(" )

	local name1 = lexer:test "Identifier" and lexer:next().value or lexer:throw "expected name"
	local name2 = lexer:consume( "Symbol", "," ) and ( lexer:test "Identifier" and lexer:next().value or lexer:throw "expected name" )
	local expr = lexer:consume( "Keyword", "in" ) and parseSourceExpression( session ) or lexer:throw "expected 'in'"
	local body = ( not needsClosingBracket or lexer:consume( "Symbol", ")" ) or lexer:throw "expected ')'" ) and parseSourceBlock( session )

	return {
		source = source;
		line = line;
		type = "foreach";
		name1 = name1;
		name2 = name2;
		expr = expr;
		body = body;
	}
end
