
 -- {UNARY_OPERATOR_LEFT} PRIMARY {UNARY_OPERATOR_RIGHT}

local function parseSourceTerm( session )
	local lexer = session.lexer
	local left = {}

	repeat
		local token = parseSourceUnaryOperatorLeft( lexer )
		left[#left + 1] = token
	until not token

	local object = parseSourcePrimaryExpression( session )
	local new = object

	repeat
		object = new
		new = parseSourceUnaryOperatorRight( session, object )
	until not new

	for i = #left, 1, -1 do
		object = {
			source = left[i].source, line = left[i].line;
			type = "operator-left";
			operator = object[i].value;
			value = object;
		}
	end

	return object
end
