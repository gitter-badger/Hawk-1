
 -- TYPENAME Identifier {TYPEMOD} ['=' EXPR] {',' Identifier {TYPEMOD} ['=' EXPR]} ';'

local function parseSourceDefinitions( session, source, line, typename, name, modifiers )
	local lexer = session.lexer
	local definitions = { type = "definitions" }
	local value

	if lexer:consume( "Symbol", ";" ) then
		definitions[1] = { typename = typename, name = name, modifiers = modifiers, source = source, line = line }
		return definitions
	end

	while not lexer:isEOF() do

		definitions[#definitions + 1] = { typename = typename, name = name, modifiers = modifiers, value = lexer:consume( "Symbol", "=" ) and parseSourceExpression( session ), source = source, line = line }

		if lexer:consume( "Symbol", "," ) then
			source, line = lexer:get().source, lexer:get().line
			name = lexer:test "Identifier" and lexer:next().value or lexer:throw "expected name"
			modifiers = parseSourceTypeModifiers( session )

		elseif lexer:consume( "Symbol", ";" ) then
			return definitions
		else
			return lexer:throw "expected ';'"
		end
	end

	return lexer:throw "expected ';'"
end
