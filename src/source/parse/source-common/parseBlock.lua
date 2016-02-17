
 -- '{' {STATEMENT} '}'
 -- STATEMENT

function parseSourceBlock( session )
	local lexer = session.lexer
	local block = {}

	if lexer:consume( "Symbol", "{" ) then
		session.environment:push()

		while not lexer:consume( "Symbol", "}" ) do
			if lexer:isEOF() then
				lexer:throw "expected '}'"
			end

			if lexer:consume( "Keyword", "return" ) then
				if lexer:consume( "Symbol", ";" ) then
					block[#block + 1] = {
						source = source, line = line;
						type = "return";
					}
				else
					local expr = parseSourceExpression( session )
					block[#block + 1] = lexer:consume( "Symbol", ";" ) and {
						source = source, line = line;
						type = "return";
						value = expr;
					} or lexer:throw "expected ';'"
				end

				session.environment:pop()

				return lexer:consume( "Symbol", "}" ) and block or lexer:throw "expected '}' <end of block> after return statement"

			else
				block[#block + 1] = parseSourceStatement( session )
			end
		end

		session.environment:pop()
		return block
	else
		if lexer:isEOF() then
			return lexer:throw "expected statement"
		end

		local statement

		session.environment:push()
		statement = parseSourceStatement( session )
		session.environment:pop()
	end
end
