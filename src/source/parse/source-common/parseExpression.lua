
 -- TERM {BINARY_OPERATOR TERM}

local LEFT_ASSOC = 0
local RIGHT_ASSOC = 1

local precedence = {
	[ "=" ]		= 1;
	[ "+" ]		= 11;
	[ "-" ]		= 11;
	[ "*" ]		= 12;
	[ "/" ]		= 12;
	[ "%" ]		= 12;
	[ "**" ]	= 13;
	[ "+=" ]	= 1;
	[ "-=" ]	= 1;
	[ "*=" ]	= 1;
	[ "/=" ]	= 1;
	[ "%=" ]	= 1;
	[ "**=" ]	= 1;
	[ "&" ]		= 9;
	[ "|" ]		= 7;
	[ "^" ]		= 8;
	[ "<<" ]	= 10;
	[ ">>" ]	= 10;
	[ "&=" ]	= 1;
	[ "|=" ]	= 1;
	[ "^=" ]	= 1;
	[ "<<=" ]	= 1;
	[ ">>=" ]	= 1;
	[ "==" ]	= 4;
	[ "!=" ]	= 4;
	[ "<" ]		= 5;
	[ ">" ]		= 5;
	[ "<=" ]	= 5;
	[ ">=" ]	= 5;
	["||"]		= 2;
	["&&"]		= 3;
	[ ".." ]	= 6;
}

local association = {
	RIGHT_ASSOC; -- = etc
	 LEFT_ASSOC; -- ||
	 LEFT_ASSOC; -- &&
	 LEFT_ASSOC; -- == etc
	 LEFT_ASSOC; -- > etc
	 LEFT_ASSOC; -- ..
	 LEFT_ASSOC; -- |
	 LEFT_ASSOC; -- ^
	 LEFT_ASSOC; -- &
	 LEFT_ASSOC; -- >> etc
	 LEFT_ASSOC; -- + etc
	 LEFT_ASSOC; -- * etc
	RIGHT_ASSOC; -- **
}

function parseSourceExpression( session )
	local lexer = session.lexer

	local operands = { parseSourceTerm( session ) }
	local operators = {}
	local pstack = {}

	local function collapse()
		operands[#operands - 1] = {
			lvalue = operands[#operands - 1];
			rvalue = operands[#operands];
			operator = operators[#operators];
		}
		operands[#operands] = nil
		operators[#operators] = nil
		pstack[#pstack] = nil
	end

	repeat
		local operator = parseSourceBinaryOperator( lexer )
		if operator then
			local p = precedence[operator.value]
			local rvalue = parseSourceTerm( session )

			while true do
				local ptop = pstack[#pstack] or 0
				if ptop > p or ptop == p and association[p] == LEFT_ASSOC then
					collapse()
				else
					break
				end
			end

			pstack[#pstack + 1] = p
			operators[#operators + 1] = operator
			operands[#operands + 1] = rvalue
		end
	until not operator

	while #operands > 1 do
		collapse()
	end

	return operands[1]
end
