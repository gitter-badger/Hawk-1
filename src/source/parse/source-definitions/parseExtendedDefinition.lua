
 -- TYPENAME Identifier {TYPEMOD} ['=' EXPR] {',' Identifier {TYPEMOD} ['=' EXPR]} ';'
 -- TYPENAME Identifier {TYPEMOD} FDEFARGS ';'
 -- TYPENAME Identifier {TYPEMOD} FDEFARGS '=' EXPR ';'
 -- TYPENAME Identifier {TYPEMOD} FDEFARGS BLOCK
 -- 'class' ['extends' NAMESPACE] ['implements' INTERFACELIST] CLASSBODY
 -- 'interface' ['implements' INTERFACELIST] CLASSBODY
 -- 'enum' Identifier '{' Identifier { ( ',' | ';' ) Identifier } '}'

local function parseSourceExtendedDefinition( session )
	local lexer = session.lexer
	local start = lexer:mark()

	if parseSourceTypename( session ) then
		lexer:home()
		return parseSourceDefinition( session )
		
	elseif lexer:consume( "Keyword", "class" ) then
		return parseSourceClassDefinition( session )

	elseif lexer:consume( "Keyword", "interface" ) then
		return parseSourceInterfaceDefinition( session )

	elseif lexer:consume( "Keyword", "enum" ) then
		return parseSourceEnumDefinition( session )

	else
		lexer:throw "expected typename, 'class', 'enum' or 'interface'"

	end

end
