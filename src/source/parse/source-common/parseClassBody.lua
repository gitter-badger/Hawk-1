
	-- ['override' NAME] {'public' | 'private' | 'static'} DEFINITION
	-- 'private' ':'
	-- 'public' ':'

local function parseSourceClassBody( session, classname )
	local lexer = session.lexer
	local mode = "public"
	local private = {}
	local public = {}
	local static_private = {}
	local static_public = {}

	while not lexer:consume( "Symbol", "}" ) do
		local this_mode = mode
		local consumed

		if lexer:consume( "Keyword", "public" ) then
			this_mode = "public"
			consumed = true
		elseif lexer:consume( "Keyword", "private" ) then
			this_mode = "private"
			consumed = true
		end

		if lexer:consume( "Symbol", ":" ) then
			mode = this_mode
		else
			local overrides = {}
			local static = false

			if not consumed and lexer:consume( "Keyword", "override" ) then
				overrides = parseSourceImplementationList( session )
			end
			
			if not consumed and lexer:consume( "Keyword", "public" ) then
				this_mode = "public"
			elseif not consumed and lexer:consume( "Keyword", "private" ) then
				this_mode = "private"
			end

			if lexer:consume( "Keyword", "static" ) then
				static = true
			end

			local t = this_mode == "public" and ( static and static_public or public )
											or ( static and static_private or private )

			local start = lexer:mark()
			local source = lexer:get().source
			local line = lexer:get().line

			if this_mode == "public" then
				session.environment:push()
				session.environment:definelocal "self"
			end

			if parseSourceName( session ) == classname and lexer:consume( "Symbol", "(" ) then
				t[#t + 1] = parseSourceFunctionDefinition( session, source, line, classname, classname, {} )
				t[#t].overrides = overrides
			else
				lexer:home()
				t[#t + 1] = parseSourceDefinition( session, true )
				t[#t].overrides = overrides
			end

			if this_mode == "public" then
				session.environment:pop()
			end
		end
	end

	return {
		public, private, static_public, static_private
	}
end
