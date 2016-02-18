
 -- 'namespace' Identifier NAMESPACEDEF

local function parseSourceNamespace( session )
	local lexer = session.lexer
	local name = parseSourceName( session )
	local definitions = { type = "namespace", name = name }

	session.environment:pushNamespace( name )

	if lexer:consume( "Symbol", "{" ) then
		while not lexer:consume( "Symbol", "}" ) do
			if lexer:isEOF() then lexer:throw "expected '}'" end
			if lexer:consume( "Keyword", "namespace" ) then
				for i, v in ipairs( parseSourceNamespace( session ) ) do
					definitions[#definitions + 1] = v
				end
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
