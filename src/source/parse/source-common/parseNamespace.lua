
 -- 'namespace' Identifier NAMESPACEDEF

local function parseSourceNamespace( session )
	local lexer = session.lexer
	local name = lexer:test "Identifier" and lexer:next().value or lexer:throw "expected namespace name"
	local definitions = { type = "namespace", name = name }

	session.environment:pushNamespace( name )

	if lexer:consume( "Symbol", "{" ) then
		while not lexer:consume( "Symbol", "}" ) do
			if lexer:isEOF() then lexer:throw "expected '}'" end
			if lexer:consume( "Keyword", "namespace" ) then
				definitions[#definitions + 1] = parseSourceNamespace( session )
			else
				definitions[#definitions + 1] = parseSourceExtendedDefinition( session )
			end
		end
	else
		return lexer:throw "expected '{'"
	end

	session.environment:popNamespace()

	return definitions
end
