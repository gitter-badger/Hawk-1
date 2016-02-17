
 -- NAMESPACE
 -- NAMESPACE {',' NAMESPACE} 'and' NAMESPACE

local function interface( session )
	local start = session.lexer:mark()
	local name = parseSourceName( session )

	local name_resolved = session.environment:resolve( name )
	
	if not name_resolved then
		session.lexer:home()
		session.lexer:throw "undefined reference"
	elseif session.environment:getEnvironmentType( name_resolved ) == "interface" then
		return name
	else
		session.lexer:home()
		session.lexer:throw "invalid interface name"
	end
end

local function parseSourceImplementationList( session )
	local lexer = session.lexer
	local list = { interface( session ) }

	while lexer:consume( "Symbol", "," ) do
		list[#list + 1] = interface( session )
	end

	if lexer:consume( "Keyword", "and" ) then
		list[#list + 1] = interface( session )
	end

	return list
end
