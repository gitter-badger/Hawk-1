
 -- 'import' Identifier {'.' Identifier} ';'
 -- 'if' EXPR BLOCK ['else' BLOCK]
 -- 'while' EXPR ( BLOCK | ';' )
 -- 'for' DEFINITION (';' | ',') EXPR (';' | ',') EXPR ( BLOCK | ';' )
 -- 'for' '(' DEFINITION (';' | ',') EXPR (';' | ',') EXPR ')' ( BLOCK | ';' )
 -- 'foreach' Identifier [',' Identifier] 'in' EXPR BLOCK
 -- 'foreach' '(' Identifier [',' Identifier] 'in' EXPR ')' BLOCK
 -- 'super' [ '(' EXPRLIST ')' ] ';'
 -- 'return' [EXPR] ';'
 -- 'break' ';'
 -- 'continue' ';'
 -- 'throw' Identifier EXPR ';'
 -- 'try' BLOCK {'catch' Identifier Identifier BLOCK} ['default' BLOCK]
 -- 'typename' Identifier '=' TYPE ';'
 -- 'using' NAMESPACE ';'
 -- 'namespace' Identifier NAMESPACEDEF
 -- 'new' TYPENAME Identifier [ '(' EXPRLIST ')' ] ';'
 -- 'repeat' [BLOCK] ['until' EXPR ';']
 -- TYPENAME Identifier {TYPEMOD} ['=' EXPR] {Identifier {TYPEMOD} ['=' EXPR]} ';'
 -- TYPENAME Identifier {TYPEMOD} FDEFARGS ';'
 -- TYPENAME Identifier {TYPEMOD} FDEFARGS '=' EXPR ';'
 -- TYPENAME Identifier {TYPEMOD} FDEFARGS BLOCK
 -- EXPR

function parseSourceStatement( session )
	local lexer = session.lexer

	if lexer:test "Keyword" then
		local token = lexer:next()
		local keyword = token.value

		if statements[keyword] then
			return statements[keyword]( session, token.source, token.line )
		else
			lexer:back()
			lexer:throw "unexpected keyword"
		end
	else
		local start = lexer:mark()

		if parseSourceTypename( session ) then
			lexer:home()
			return parseSourceDefinition( session )
		else
			local token = lexer:next()
			lexer:home()
			local expr = parseSourceExpression( session )

			if lexer:test "Identifier" and expr.type == "Identifier" then
				lexer:throw( "invalid type name '" .. expr.value .. "'" )
			end

			return lexer:consume( "Symbol", ";" ) and {
				source = token.source, line = token.line;
				type = "expression";
				value = expr;
			} or lexer:throw "expected ';'"
		end
	end
end
