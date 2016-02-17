
 -- 'switch' EXPR ';' { ( 'case' EXPR BLOCK ) | ( 'case' '(' EXPR ')' BLOCK ) } [ 'default' BLOCK ]

local function parseSourceSwitchStatement( session, source, line )
	local lexer = session.lexer
	local expr = parseSourceExpression( session )
	local cases = {}

	lexer:consume( "Symbol", ";" )

	while lexer:consume( "Keyword", "case" ) do
		local needsClosingBracket = lexer:consume( "Symbol", "(" )
		local case = parseSourceExpression( session )
		local block = ( not needsClosingBracket or lexer:consume( "Symbol", ")" ) or lexer:throw "expected ')'" ) and parseSourceBlock( session )

		cases[#cases + 1] = { case = case, block = block }
	end

	local default = lexer:consume( "Keyword", "default" ) and parseSourceBlock( session )

	return {
		source = source, line = line;
		type = "switch";
		value = expr;
		cases = cases;
		default = default;
	}
end
