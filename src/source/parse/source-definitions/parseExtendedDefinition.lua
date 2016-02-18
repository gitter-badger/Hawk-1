
 -- TYPENAME Identifier {TYPEMOD} ['=' EXPR] {',' Identifier {TYPEMOD} ['=' EXPR]} ';'
 -- TYPENAME Identifier {TYPEMOD} FDEFARGS ';'
 -- TYPENAME Identifier {TYPEMOD} FDEFARGS '=' EXPR ';'
 -- TYPENAME Identifier {TYPEMOD} FDEFARGS BLOCK
 -- 'class' ['extends' NAMESPACE] ['implements' INTERFACELIST] CLASSBODY
 -- 'interface' ['implements' INTERFACELIST] CLASSBODY
 -- 'enum' Identifier '{' Identifier { ( ',' | ';' ) Identifier } '}'

local function parseSourceExtendedDefinition( session )
	local lexer = session.lexer
	local source = lexer:next().source
	local line = lexer:get().line
	local start = lexer:mark()

	lexer:back()

	if parseSourceTypename( session ) then
		lexer:home()
		return parseSourceDefinition( session )

	elseif lexer:consume( "Keyword", "class" ) then
		return parseSourceClassDefinition( session, source, line )

	elseif lexer:consume( "Keyword", "interface" ) then
		return parseSourceInterfaceDefinition( session, source, line )

	elseif lexer:consume( "Keyword", "enum" ) then
		return parseSourceEnumDefinition( session, source, line )

	else
		lexer:throw "expected typename, 'class', 'enum' or 'interface'"

	end

end
