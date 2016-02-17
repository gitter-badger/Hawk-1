
 -- 'for' DEFINITION (';' | ',') EXPR (';' | ',') EXPR ( BLOCK | ';' )
 -- 'for' '(' DEFINITION (';' | ',') EXPR (';' | ',') EXPR ')' ( BLOCK | ';' )

local function parseSourceForStatement( session, source, line )
	local lexer = session.lexer
	local needsClosingBracket = lexer:consume( "Symbol", "(" )
	local typename = parseSourceTypename( session ) or lexer:throw "expected typename"
	local varname = lexer:test "Identifier" and lexer:next().value or lexer:throw "expected variable name"
	local value = lexer:consume( "Symbol", "=" ) and parseSourceExpression( session ) or lexer:throw "expected '='"
	local split = lexer:consume( "Symbol", "," ) or lexer:consume( "Symbol", ";" ) or lexer:throw "expected ';' after for initialiser"
	local test = parseSourceExpression( session )
	local split = lexer:consume( "Symbol", "," ) or lexer:consume( "Symbol", ";" ) or lexer:throw "expected ';' after for conditional"
	local update = parseSourceExpression( session )
	local block = ( not needsClosingBracket or lexer:consume( "Symbol", ")" ) or lexer:throw "expected ')'" ) and ( lexer:consume( "Symbol", ";" ) and {} or parseSourceBlock( session ) )

	return {
		source = source, line = line;
		type = "for";
		typename = typename;
		varname = varname;
		value = value;
		test = test;
		update = update;
		block = block;
	}
end
