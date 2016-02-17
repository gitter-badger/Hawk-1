
 -- TYPENAME {TYPEMOD}

function parseSourceType( session )
	local typename = parseSourceTypename( session ) or session.lexer:throw "expected typename"
	local modifiers = parseSourceTypeModifiers( session )

	return { typename, modifiers }
end
