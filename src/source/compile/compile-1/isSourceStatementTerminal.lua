
local isBlockTerminal

local function isSourceStatementTerminal( statement )
	if statement.type == "return" then
		return true
	elseif statement.type == "if" then
		return statement.elsebody and ( isSourceBlockTerminal( statement.body ) and isSourceBlockTerminal( statement.elsebody ) )
	elseif statement.type == "switch" and statement.default and isSourceBlockTerminal( statement.default ) then
		for i = 1, #statement.cases do
			if not isSourceBlockTerminal( statement.cases[i] ) then
				return false
			end
		end
		return true
	end
	return false
end

function isSourceBlockTerminal( body, isLoop )
	for i = 1, #body do
		if isSourceStatementTerminal( body[i] ) then
			return true
		end
	end
	return false
end
