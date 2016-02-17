
 -- NAMESPACE
 -- NAMESPACE {',' NAMESPACE} 'and' NAMESPACE

local function namespace( session )
	local start = session.lexer:mark()
	local name = parseSourceName( session )
	
	if session.environment:isInterface( name ) then
		return name
	else
		session.lexer:home()
		session.lexer:throw "invalid namespace"
	end
end

local function parseSourceImplementationList( session )
	local lexer = session.lexer
	local list = { namespace( session ) }

	while lexer:consume( "Symbol", "," ) do
		list[#list + 1] = namespace( session )
	end

	if lexer:consume( "Keyword", "and" ) then
		list[#list + 1] = namespace( session )
	end

	return list
end
