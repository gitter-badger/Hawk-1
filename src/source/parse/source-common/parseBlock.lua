
 -- '{' {STATEMENT} '}'
 -- STATEMENT

function parseSourceBlock( session )
	local lexer = session.lexer
	if lexer:consume( "Symbol", "{" ) then
		local block = {}
		while not lexer:consume( "Symbol", "}" ) do
			if lexer:isEOF() then
				lexer:throw "expected '}'"
			end
			if lexer:consume( "Keyword", "return" ) then
				local s
				if lexer:consume( "Symbol", ";" ) then
					s = {
						source = source, line = line;
						type = "return";
					}
				else
					local expr = parseSourceExpression( session )
					s = lexer:consume( "Symbol", ";" ) and {
						source = source, line = line;
						type = "return";
						value = expr;
					} or lexer:throw "expected ';'"
				end
				return lexer:consume( "Symbol", "}" ) and s or lexer:throw "expected '}' <end of block> after return statement"
			else
				block[#block + 1] = parseSourceStatement( session )
			end
		end
		return block
	else
		return lexer:isEOF() and lexer:throw "expected statement" or { parseSourceStatement( session ) }
	end
end
