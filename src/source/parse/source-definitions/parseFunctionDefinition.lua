
 -- TYPENAME Identifier {TYPEMOD} FDEFARGS ';'
 -- TYPENAME Identifier {TYPEMOD} FDEFARGS '=' EXPR ';'
 -- TYPENAME Identifier {TYPEMOD} FDEFARGS BLOCK

local function parseSourceFunctionDefinition( session, typename, name, typemod )
	local lexer = session.lexer
	local parameters = parseSourceFunctionDefinitionParameters( session )

	if lexer:consume( "Symbol", "=" ) then
		local expr = parseSourceExpression( session );
		return lexer:consume( "Symbol", ";" ) and {
			type = "vfuncdef";
			typename = typename;
			modifiers = modifiers;
			name = name;
			parameters = parameters;
			expr = expr
		} or lexer:throw "expected ';'"
	end

	local body = not lexer:consume( "Symbol", ";" ) and parseSourceBlock( session )

	return {
		type = "funcdef";
		typename = typename;
		modifiers = modifiers;
		name = name;
		parameters = parameters;
		body = body;
	}
end
