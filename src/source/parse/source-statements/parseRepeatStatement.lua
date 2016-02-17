
 -- 'repeat' [BLOCK] ['until' EXPR ';']

local function parseSourceRepeatStatement( session, source, line )
	local lexer = session.lexer
	local body = lexer:test( "Keyword", "until" ) and {} or parseSourceBlock( session )
	local condition = lexer:consume( "Keyword", "until" ) and parseSourceExpression( session )

	if condition and not lexer:consume( "Symbol", ";" ) then lexer:throw "expected ';'" end

	return {
		source = source, line = line;
		type = "repeat";
		body = body;
		condition = condition;
	}
end
