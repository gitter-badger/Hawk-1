
 -- {STATEMENT}

function parseSourceBody( session )
	local statements = {}
	local lexer = session.lexer
	while not lexer:isEOF() do
		if lexer:consume( "Keyword", "namespace" ) then
			statements[#statements + 1] = parseSourceNamespace( session )
		else
			statements[#statements + 1] = parseSourceStatement( session )
		end
	end
	return statements
end
