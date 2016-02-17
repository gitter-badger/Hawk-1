
 -- '(' ')'
 -- '(' TYPENAME Identifier {TYPEMOD} ['=' EXPR] { ',' [TYPENAME] Identifier {TYPEMOD} ['=' EXPR] } ')'

local function parseSourceFunctionDefinitionParameters( session )
	local lexer = session.lexer
	local parameters = {}
	local typename

	if session.lexer:consume( "Symbol", ")" ) then
		return {}
	end

	while true do
		typename = parseSourceTypename( session ) or typename or lexer:throw "expected typename for first parameter"

		local name = lexer:test "Identifier" and lexer:next().value or lexer:throw "expected parameter name"
		local modifiers = parseSourceTypeModifiers( session )
		local default = lexer:consume( "Symbol", "=" ) and parseSourceExpression( session )

		parameters[#parameters + 1] = { typename = typename, modifiers = modifiers, name = name, default = default }

		if lexer:consume( "Symbol", ")" ) then
			return parameters
		elseif not lexer:consume( "Symbol", "," ) then
			return lexer:throw "expected ')'"
		end
	end
end
