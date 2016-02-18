
 -- {STATEMENT}

function parseSourceBody( session )
	local statements = {}
	local lexer = session.lexer
	while not lexer:isEOF() do
		if lexer:consume( "Keyword", "namespace" ) then
			for i, v in ipairs( parseSourceNamespace( session ) ) do
				statements[#statements + 1] = v
			end
		elseif lexer:consume( "Keyword", "using" ) then
			statements[#statements + 1] = parseSourceUsingStatement( session )
		elseif lexer:consume( "Keyword", "import" ) then
			statements[#statements + 1] = parseSourceImportStatement( session )
		else
			statements[#statements + 1] = parseSourceExtendedDefinition( session )
		end
	end
	return statements
end
