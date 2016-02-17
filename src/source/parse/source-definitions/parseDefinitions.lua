
 -- TYPENAME Identifier {TYPEMOD} ['=' EXPR] {',' Identifier {TYPEMOD} ['=' EXPR]} ';'

local function parseSourceDefinitions( session, typename, name, modifiers )
	local lexer = session.lexer
	local definitions = { type = "definitions", typename = typename }
	local value

	if lexer:consume( "Symbol", ";" ) then
		definitions[1] = { name = name, modifiers = modifiers }
		return definitions
	end

	while not lexer:isEOF() do

		definitions[#definitions + 1] = { name = name, modifiers = modifiers, value = lexer:consume( "Symbol", "=" ) and parseSourceExpression( session ) }

		if lexer:consume( "Symbol", "," ) then
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
