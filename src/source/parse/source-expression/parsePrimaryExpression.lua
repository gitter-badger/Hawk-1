
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
	elseif lexer:test "Identifier" then
		local home = lexer:mark()
		local name = parseSourceName( session )
		local name_resolved = session.environment:resolve( name )

		if name_resolved then

			local type = session.environment:getEnvironmentType( name_resolved )
			if type == "enum" then
				return { type = "Enum", value = name_resolved, source = token.source, line = token.line }

			elseif type == "class" then
				return { type = "Class", value = name_resolved, source = token.source, line = token.line }

			elseif type == "value" or not type then
				return { type = "Identifier", value = name_resolved, source = token.source, line = token.line }

			elseif type == "interface" then
				lexer:home()
				lexer:throw "cannot use interface in expression"

			elseif type == "classdecl" then
				lexer:home()
				lexer:throw "cannot use class declaration in expression"

			else
				lexer:home()
				lexer:throw( "cannot use " .. type .. " in expression" )

			end
		else
			lexer:home()
			lexer:throw "undefined reference"

		end
	else
		return lexer:consume "String"
			or lexer:consume "DoubleNumber" or lexer:consume "FloatNumber"
			or lexer:consume "IntegerNumber" or lexer:consume "ByteNumber"
			or lexer:consume "HexNumber" or lexer:consume "BinaryNumber"
			or lexer:consume "Boolean" or lexer:consume "Null"
			or lexer:throw "expected primary expression"
	end
end
