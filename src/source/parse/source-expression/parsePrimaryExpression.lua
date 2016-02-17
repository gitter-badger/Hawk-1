
 -- String
 -- DoubleNumber | FloatNumber | IntegerNumber | ByteNumber
 -- HexNumber | BinaryNumber
 -- Boolean | Null
 -- NAMESPACE
 -- '{' TABLEDEF '}'
 -- '[' EXPRLIST ']'
 -- '(' EXPR ')'

local function parseSourceTableContent( session )
	local lexer = session.lexer
	local definitions = {}

	if lexer:consume( "Symbol", "}" ) then return {} end

	while not lexer:isEOF() do
		if lexer:isEOF() then lexer:throw "expected '}'" end

		if lexer:consume( "Symbol", "[" ) then
			local index = parseSourceExpression( session )
			local value = lexer:consume( "Symbol", "]" ) and ( lexer:consume( "Symbol", "=" ) and parseSourceExpression( session ) or lexer:throw "expected '='" ) or lexer:throw "expected ']'"
			definitions[#definitions + 1] = { type = "indexed", index = index, value = value }

		elseif lexer:test "Identifier" then
			local name = lexer:next().value
			local value = lexer:consume( "Symbol", "=" ) and parseSourceExpression( session ) or lexer:throw "expected '='"
			definitions[#definitions + 1] = { type = "named", index = name, value = value }

		else
			lexer:throw "expected '}'"
		end

		if not ( lexer:consume( "Symbol", "," ) or lexer:consume( "Symbol", ";" ) ) then
			break
		end
	end

	return lexer:consume( "Symbol", "}" ) and definitions or lexer:throw "expected '}'"
end

local function parseSourcePrimaryExpression( session )
	local lexer = session.lexer
	local token = lexer:test "Symbol" or lexer:test "Identifier"

	if lexer:consume( "Symbol", "(" ) then
		local expr = parseSourceExpression( session )
		return lexer:consume( "Symbol", ")" ) and expr or lexer:throw "expected ')'"
	elseif lexer:consume( "Symbol", "{" ) then
		return { source = token.source, line = token.line, type = "table", value = parseSourceTableContent( session ) }
	elseif lexer:consume( "Symbol", "[" ) then
		return { source = token.source, line = token.line, type = "array", value = parseSourceExpressionList( session, "]" ) }
	else
		return lexer:consume "String"
			or lexer:consume "DoubleNumber" or lexer:consume "FloatNumber"
			or lexer:consume "IntegerNumber" or lexer:consume "ByteNumber"
			or lexer:consume "HexNumber" or lexer:consume "BinaryNumber"
			or lexer:consume "Boolean" or lexer:consume "Null"
			or lexer:test "Identifier" and { type = "Identifier", value = parseSourceName( session ), source = token.source, line = token.line }
			or lexer:throw "expected primary expression"
	end
end
