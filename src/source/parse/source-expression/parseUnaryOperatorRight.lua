
 -- '(' EXPRLIST ')'
 -- String
 -- '[' EXPR ']'
 -- '->' TYPE
 -- '.' Identifier
 -- ':' Identifier '(' EXPRLIST ')'
 -- ':' Identifier String
 -- '++' | '--'

local function parseSourceUnaryOperatorRight( session, lvalue )
	local lexer = session.lexer
	local token = lexer:test "Symbol"

	if lexer:consume( "Symbol", "(" ) then
		return { source = token.source, line = token.line, type = "call", lvalue = lvalue, value = parseSourceExpressionList( session ) }

	elseif lexer:test "String" then
		local token = lexer:next()
		return { source = token.source, line = token.line, type = "scall", value = token.value, lvalue = lvalue }

	elseif lexer:consume( "Symbol", "[" ) then
		local index = parseSourceExpression( session )
		return lexer:consume( "Symbol", "]" ) and { source = token.source, line = token.line, type = "index", value = index, lvalue = lvalue }

	elseif lexer:consume( "Symbol", "->" ) then
		return { source = token.source, line = token.line, type = "cast", value = parseSourceType( session ), lvalue = lvalue }

	elseif lexer:consume( "Symbol", "." ) then
		return { source = token.source, line = token.line, type = "dotindex", value = lexer:test "Identifier" and lexer:next().value or lexer:throw "expected index name", lvalue = lvalue }

	elseif lexer:consume( "Symbol", ":" ) then
		local name = lexer:test "Identifier" and lexer:next().value or lexer:throw "expected method name"
		if lexer:consume( "Symbol", "(" ) then
			local list = parseSourceExpressionList( session )
			return lexer:consume( "Symbol", ")" ) and { source = token.source, line = token.line, type = "method", lvalue = lvalue, value = name, arguments = list }
		else
			return { source = token.source, line = token.line, type = "smethod", value = name, arguments = lexer:test "String" and lexer:next().value or lexer:throw "expected '('", lvalue = lvalue }
		end

	elseif lexer:test( "Symbol", "++" ) or lexer:test( "Symbol", "--" ) then
		local token = lexer:next()
		return { source = token.source, line = token.line, type = "operator-right", value = token.value, value = lvalue }

	end
end
