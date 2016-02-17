
 -- 'while' EXPR ( BLOCK | ';' )

local function parseSourceWhileStatement( session, source, line )
	local condition = parseSourceExpression( session )
	local body = session.lexer:consume( "Symbol", ";" ) and {} or parseSourceBlock( session )

	return {
		source = source, line = line;
		type = "while";
		condition = condition;
		body = body;
	}
end
