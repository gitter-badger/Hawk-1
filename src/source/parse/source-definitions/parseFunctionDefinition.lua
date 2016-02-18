
 -- TYPENAME Identifier {TYPEMOD} FDEFARGS ';'
 -- TYPENAME Identifier {TYPEMOD} FDEFARGS '=' EXPR ';'
 -- TYPENAME Identifier {TYPEMOD} FDEFARGS BLOCK
 -- TYPENAME Identifier {TYPEMOD} FDEFARGS ~~ BYTECODE ~~

 -- FDEFARGS:
 -- dsagfsdghjk

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

	if namegiven == nil then namegiven = true end

	if lexer:consume( "Symbol", "=" ) then
		if not namegiven then
			lexer:throw "cannot parse source block with un-named parameters"
		end
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
		lexer:bytecode()
		local environment, instructions = parseBytecodeBody( lexer )
		lexer:source()

		return {
			source = source, line = line;
			type = "bfuncdef";
			typename = typename;
			modifiers = modifiers;
			name = name;
			parameters = parameters;
			environment = environment;
			instructions = instructions;
		}
	end

	session.environment:push()

	for i = 1, #parameters do
		session.environment:definelocal( parameters[i].name )
	end

	local body = not lexer:consume( "Symbol", ";" ) and ( namegiven and parseSourceBlock( session ) or lexer:throw "cannot parse block with un-named parameters" )

	session.environment:pop()
	session.environment:definelocal( name )

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
