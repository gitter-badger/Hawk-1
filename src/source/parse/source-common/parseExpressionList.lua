
 -- [ EXPR {',' EXPR} ] #close#

local function parseSourceExpressionList( session, close )
	local lexer = session.lexer
	local terms = {}

	if lexer:consume( "Symbol", close or ")" ) then return {} end
	
	while not lexer:isEOF() do
		terms[#terms + 1] = parseSourceExpression( session )

		if not lexer:consume( "Symbol", "," ) then
			break
		end
	end

	return lexer:consume( "Symbol", close or ")" ) and terms or lexer:throw( "expected '" .. ( close or ")" ) .. "'" )
end
