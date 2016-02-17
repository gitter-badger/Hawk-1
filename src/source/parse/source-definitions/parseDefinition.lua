
 -- TYPENAME Identifier {TYPEMOD} ['=' EXPR] {',' Identifier {TYPEMOD} ['=' EXPR]} ';'
 -- TYPENAME Identifier {TYPEMOD} FDEFARGS ';'
 -- TYPENAME Identifier {TYPEMOD} FDEFARGS '=' EXPR ';'
 -- TYPENAME Identifier {TYPEMOD} FDEFARGS BLOCK

local isOperator = {
	[ "=" ]		= true;
	[ "+" ]		= true;
	[ "-" ]		= true;
	[ "*" ]		= true;
	[ "/" ]		= true;
	[ "%" ]		= true;
	[ "**" ]	= true;
	[ "+=" ]	= true;
	[ "-=" ]	= true;
	[ "*=" ]	= true;
	[ "/=" ]	= true;
	[ "%=" ]	= true;
	[ "**=" ]	= true;
	[ "&" ]		= true;
	[ "|" ]		= true;
	[ "^" ]		= true;
	[ "<<" ]	= true;
	[ ">>" ]	= true;
	[ "&=" ]	= true;
	[ "|=" ]	= true;
	[ "^=" ]	= true;
	[ "<<=" ]	= true;
	[ ">>=" ]	= true;
	[ "==" ]	= true;
	[ "!=" ]	= true;
	[ "<" ]		= true;
	[ ">" ]		= true;
	[ "<=" ]	= true;
	[ ">=" ]	= true;
	["||"]		= true;
	["&&"]		= true;
	[ ".." ]	= true;
	[ "#" ]		= true;
	[ "!" ]		= true;
	[ "~" ]		= true;
	[ "++" ]	= true;
	[ "--" ]	= true;
}

local function parseSourceDefinition( session, operatorNameAllowed )
	local lexer = session.lexer
	local typename = parseSourceTypename( session ) or lexer:throw "expected typename"
	local name, objectIsOperator

	if lexer:test "Identifier" then
		name = lexer:next().value
	elseif operatorNameAllowed and lexer:consume( "Keyword", "operator" ) then
		local operator = lexer:test "Symbol" and lexer:next().value or lexer:throw "expected operator"
		if isOperator[operator] then
			name = "operator" .. operator
			objectIsOperator = true
		else
			lexer:back()
			lexer:throw "expected operator"
		end
	else
		return lexer:throw "expected name"
	end

	local modifiers = typename.name == "auto" and {} or parseSourceTypeModifiers( session )

	if lexer:consume( "Symbol", "(" ) then
		return parseSourceFunctionDefinition( session, typename, name, modifiers )

	elseif objectIsOperator then
		return lexer:throw "expected '('"

	else
		return parseSourceDefinitions( session, typename, name, modifiers )

	end
end
