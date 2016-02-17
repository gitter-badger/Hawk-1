
 -- 'import' ( Identifier | '*' )  {'.' ( Identifier | '*' ) } ';'
 -- TODO: 'import' String ';'

local function parseSourceImportStatement( session, source, line )
	local lexer = session.lexer
	local begin = lexer:consume "Identifier" or lexer:consume( "Symbol", "*" ) or lexer:throw "expected identifier filename"
	local s = { begin.value }

	while lexer:consume( "Symbol", "." ) do
		local object = lexer:consume "Identifier" or lexer:consume( "Symbol", "*" ) or lexer:throw "expected identifier filename"
		s[#s + 1] = object.value
	end

	local paths = { "" }

	for i = 1, #s do
		if s[i] == "*" then
			for n = #paths, 1, -1 do
				local files = session:getFileListing( paths[n] )
				if #files == 0 then
					table.remove( paths, n )
				else
					for m = 2, #files do
						paths[#paths + 1] = paths[n] .. "/" .. files[m]
					end
					paths[n] = paths[n] .. "/" .. files[1]
				end
			end
		else
			for n = 1, #paths do
				paths[n] = paths[n] .. "/" .. s[i]
			end
		end
	end

	for i = 1, #paths do
		session:import( paths[i] )
	end

	return {
		source = source, line = line;
		type = "import";
		value = paths;
	}
end
