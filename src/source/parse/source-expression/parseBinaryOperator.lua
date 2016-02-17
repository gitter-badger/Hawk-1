
local operators = {
	[ "=" ]		= true;
	[ "+" ]		= true;
	[ "-" ]		= true;
	[ "*" ]		= true;
	[ "/" ]		= true;
	[ "%" ]		= true;
	[ "**" ]	= true;
	[ "+=" ]	= true;
	[ "-=" ]	= true;
	[ "*=" ]	= true;
	[ "/=" ]	= true;
	[ "%=" ]	= true;
	[ "**=" ]	= true;
	[ "&" ]		= true;
	[ "|" ]		= true;
	[ "^" ]		= true;
	[ "<<" ]	= true;
	[ ">>" ]	= true;
	[ "&=" ]	= true;
	[ "|=" ]	= true;
	[ "^=" ]	= true;
	[ "<<=" ]	= true;
	[ ">>=" ]	= true;
	[ "==" ]	= true;
	[ "!=" ]	= true;
	[ "<" ]		= true;
	[ ">" ]		= true;
	[ "<=" ]	= true;
	[ ">=" ]	= true;
	["||"]		= true;
	["&&"]		= true;
	[ ".." ]	= true;
}

local function parseSourceBinaryOperator( lexer )
	local token = lexer:consume "Symbol"
	return token and ( operators[token.value] and token or lexer:back() )
end
