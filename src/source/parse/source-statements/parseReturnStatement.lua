
 -- 'return' [EXPR] ';'

local function parseSourceReturnStatement( session, source, line )
	local lexer = session.lexer
	if lexer:consume( "Symbol", ";" ) then
		return {
			source = source, line = line;
			type = "return";
		}
	else
		local expr = parseSourceExpression( session )
		return lexer:consume( "Symbol", ";" ) and {
			source = source, line = line;
			type = "return";
			value = expr;
		} or lexer:throw "expected ';'"
	end
end
