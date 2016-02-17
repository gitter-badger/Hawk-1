
 -- 'try' BLOCK {'catch' Identifier Identifier BLOCK} ['default' BLOCK]

local function parseSourceTryStatement( session, source, line )
	local lexer = session.lexer
	local block = parseSourceBlock( session )
	local catches = {}

	while lexer:consume( "Keyword", "catch" ) do
		local catchtype = lexer:test "Identifier" and lexer:next().value or lexer:throw "expected exception type"
		local catchname = lexer:test "Identifier" and lexer:next().value or lexer:throw "expected variable name"
		local block = parseSourceBlock( session )

		catches[#catches + 1] = { type = catchtype, name = catchname, block = block }
	end

	local default = lexer:consume( "Keyword", "default" ) and parseSourceBlock( session )

	return {
		source = source, line = line;
		type = "try";
		block =  block;
		catches = catches;
		default = default;
	}
end
