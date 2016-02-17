
 -- 'if' EXPR BLOCK ['else' BLOCK]

local function parseSourceIfStatement( session, source, line )
	local condition = parseSourceExpression( session )
	local body = parseSourceBlock( session )
	local elsebody

	if session.lexer:consume( "Keyword", "else" ) then
		elsebody = parseSourceBlock( session )
	end

	return {
		source = source, line = line;
		type = "if";
		condition = condition;
		body = body;
		elsebody = elsebody;
	}
end
