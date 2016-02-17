
 -- TYPENAME Identifier {TYPEMOD} FDEFARGS ';'
 -- TYPENAME Identifier {TYPEMOD} FDEFARGS '=' EXPR ';'
 -- TYPENAME Identifier {TYPEMOD} FDEFARGS BLOCK
 -- TYPENAME Identifier {TYPEMOD} FDEFARGS ~~ BYTECODE ~~

 -- FDEFARGS:
 -- 

local function parseSourceFunctionDefinition( session, source, line, typename, name, typemod )
	local lexer = session.lexer
	local parameters = {}
	local paramtypename
	local namegiven = nil

	if not session.lexer:consume( "Symbol", ")" ) then
		while true do
			paramtypename = parseSourceTypename( session ) or paramtypename or lexer:throw "expected typename for first parameter"

			local name = lexer:test "Identifier" and lexer:next().value

			if name and namegiven == false then
				lexer:back()
				lexer:throw "unexpected name (name not given to previous argument)"
			elseif not name and namegiven then
				lexer:throw "expected parameter name"
			else
				namegiven = not not name
			end

			local modifiers = parseSourceTypeModifiers( session )
			local default = lexer:consume( "Symbol", "=" ) and parseSourceExpression( session )


			parameters[#parameters + 1] = { typename = paramtypename, modifiers = modifiers, name = name, default = default }

			if lexer:consume( "Symbol", ")" ) then
				break
			elseif not lexer:consume( "Symbol", "," ) then
				return lexer:throw "expected ')'"
			end
		end
	end

	if lexer:consume( "Symbol", "=" ) then
		local expr = parseSourceExpression( session );
		return lexer:consume( "Symbol", ";" ) and {
			source = source, line = line;
			type = "vfuncdef";
			typename = typename;
			modifiers = modifiers;
			name = name;
			parameters = parameters;
			expr = expr
		} or lexer:throw "expected ';'"
	elseif lexer:consume( "Symbol", "~~" ) then
		-- parse bytecode body
		-- return
	end

	local body = not lexer:consume( "Symbol", ";" ) and ( namegiven and parseSourceBlock( session ) or lexer:throw "cannot parse block with un-named parameters" )

	return {
		source = source, line = line;
		type = "funcdefinition";
		typename = typename;
		modifiers = modifiers;
		name = name;
		parameters = parameters;
		body = body;
	}
end
