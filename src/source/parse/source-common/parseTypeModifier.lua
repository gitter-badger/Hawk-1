
 -- '{' TYPE '}'
 -- '[' ']'

local strindex = {
	name = "string";
	source = "";
	line = 0;
}

local function parseSourceTypeModifier( session )
	local lexer = session.lexer
	if lexer:consume( "Symbol", "[" ) then
		return lexer:consume( "Symbol", "]" ) and { type = "array" } or lexer:throw "expected ']'"
	elseif lexer:consume( "Symbol", "{" ) then
		if lexer:consume( "Symbol", "}" ) then
			return { type = "table", index = strindex }
		end
		local index = parseSourceType( session )
		return lexer:consume( "Symbol", "}" ) and { type = "table", index = index } or lexer:throw "expected '}'"
	end
end

local function parseSourceTypeModifiers( session )
	local t = {}
	local mod = parseSourceTypeModifier( session )

	while mod do
		t[#t + 1] = mod
		mod = parseSourceTypeModifier( session )
	end

	return t
end
