
 -- {STATEMENT}

function parseSourceBody( session )
	local statements = {}
	local lexer = session.lexer
	while not lexer:isEOF() do
		if lexer:consume( "Keyword", "namespace" ) then
			statements[#statements + 1] = parseSourceNamespace( session )
		elseif lexer:consume( "Keyword", "using" ) then
			statements[#statements + 1] = parseSourceUsingStatement( session )
		else
			statements[#statements + 1] = parseSourceExtendedDefinition( session )
		end
	end
	return statements
end
