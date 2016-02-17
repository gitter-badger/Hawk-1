
local function isFile( path )
	return fs.exists( path ) and not fs.isDir( path )
end

local function resolveFilename( root, path, name )
	if fs.isDir( root .. "/" .. name ) and isFile( root .. "/" .. name .. "/" .. name .. ".hwk" ) then
		return root .. "/" .. name .. "/" .. name .. ".hwk"
	elseif isFile( root .. "/" .. name .. ".hwk" ) then
		return root .. "/" .. name .. ".hwk"
	elseif fs.isDir( path .. "/" .. name ) and isFile( path .. "/" .. name .. "/" .. name .. ".hwk" ) then
		return path .. "/" .. name .. "/" .. name .. ".hwk"
	elseif isFile( path .. "/" .. name .. ".hwk" ) then
		return path .. "/" .. name .. ".hwk"
	end
end

local function newSourceSession( path )
	local lexers = {}
	local paths = { "" }
	local imported = {}
	local importlist = {}
	local session = {}

	session.environment = newSourceEnvironment()

	function session:import( filename )
		local file = resolveFilename( path, paths[#paths], filename )
			or error( "cannot find file '" .. filename .. "'", 0 )

		paths[#paths + 1] = file:match "^.+/" or ""

		if imported[file] then return end
		imported[file] = true

		local h = fs.open( file, "r" )
		local content = h.readAll()
		local body

		h.close()
		body = self:addstr( content, filename )
		paths[#paths] = nil

		return body
	end

	function session:addstr( str, src )
		local body
		local lexer = newSourceLexer( str, src or "string" )

		lexers[#lexers + 1] = lexer
		self.lexer = lexer

		body = parseSourceBody( self )
		lexers[#lexers] = nil
		self.lexer = lexers[#lexers]

		importlist[#importlist + 1] = body

		return body
	end

	function session:getimportlist()
		return importlist
	end

	function session:getFileListing( dir )
		return fs.isDir( path .. "/" .. dir ) and fs.list( path .. "/" .. dir ) or {}
	end

	return session
end
