
local keywords = {
	[ "import" ]		= true;
	[ "if" ]			= true;
	[ "else" ]			= true;
	[ "while" ]			= true;
	[ "for" ]			= true;
	[ "foreach" ]		= true;
	[ "interface" ]		= true;
	[ "implements" ]	= true;
	[ "enum" ]			= true;
	[ "class" ]			= true;
	[ "extends" ]		= true;
	[ "super" ]			= true;
	[ "static" ]		= true;
	[ "public" ]		= true;
	[ "private" ]		= true;
	[ "override" ]		= true;
	[ "operator" ]		= true;
	[ "return" ]		= true;
	[ "break" ]			= true;
	[ "continue" ]		= true;
	[ "throw" ]			= true;
	[ "try" ]			= true;
	[ "catch" ]			= true;
	[ "default" ]		= true;
	[ "typename" ]		= true;
	[ "using" ]			= true;
	[ "namespace" ]		= true;
	[ "in" ]			= true;
	[ "range" ]			= true;
	[ "new" ]			= true;
	[ "repeat" ]		= true;
	[ "until" ]			= true;
	[ "and" ]			= true;
	[ "switch" ]		= true;
	[ "case" ]			= true;
}

local symbols = {
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
	[ "++" ]	= true;
	[ "--" ]	= true;
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
	[ "~" ]		= true;
	[ "#" ]		= true;
	[ "!" ]		= true;
	["||"]		= true;
	["&&"]		= true;
	[ "{" ]		= true;
	[ "}" ]		= true;
	[ "(" ]		= true;
	[ ")" ]		= true;
	[ "[" ]		= true;
	[ "]" ]		= true;
	[ "." ]		= true;
	[ "," ]		= true;
	[ ";" ]		= true;
	[ ":" ]		= true;
	[ "->" ]	= true;
	[ ".." ]	= true;
	[ "::" ]	= true;
}

local function newSourceLexer( text, source )
	local lexer = {}
	local line = 1
	local position = 1
	local buffer = {}
	local bIndex = 0
	local getNextToken
	local stack = {}

	local function skip()
		while true do
			local match = text:match( "^%s+", position )
			if match then
				position = position + #match
				line = line + select( 2, match:gsub( "\n", "" ) )
			elseif text:sub( position, position + 1 ) == "//" then
				position = ( text:find( "\n", position + 2 ) or #text ) + 1
				line = line + 1
			elseif text:sub( position, position + 1 ) == "/*" then
				local match = text:match( "/%*.-%*/", position )
				if match then
					position = position + #match
					line = line + select( 2, match:gsub( "\n", "" ) )
				else
					return error( source .. "[" .. line .. "]: end of comment /* not found", 0 )
				end
			else
				break
			end
		end
	end

	local function consumePattern( pat )
		local match = text:match( "^" .. pat, position )
		position = position + #match
		return match
	end

	local function consumeIdentifier()
		local ident = text:match( "^[A-Za-z_]+", position )
		local object = { type = "Identifier", value = ident, line = line, source = source }

		position = position + #ident

		if keywords[ident] then
			object.type = "Keyword"
		elseif ident == "true" or ident == "false" then
			object.type = "Boolean"
		elseif ident == "null" then
			object.type = "Null"
		end

		return object
	end

	local function consumeString( open )
		local escaped = false
		local s = {}
		local sline = line

		for i = position + 1, #text do
			local char = text:sub( i, i )
			if escaped then
				s[#s + 1] = escape_characters[char] or char
				escaped = false
			elseif char == "\n" then
				s[#s + 1] = "\n"
				line = line + 1
			elseif char == "\\" then
				escaped = true
			elseif char == open then
				position = i + 1
				return { type = "String", value = table.concat( s ), source = source, line = sline }
			else
				s[#s + 1] = char
			end
		end

		return error( source .. "[" .. sline .. "]: end of string not found", 0 )
	end

	function getNextToken()
		bIndex = bIndex + 1
		if not buffer[bIndex] then
			if position > #text then
				return { type = "EOF", value = "EOF", source = source, line = line }
			end

			local l1 = text:sub( position, position )
			local l2 = text:sub( position, position + 1 )
			local l3 = text:sub( position, position + 2 )

			if l1 == "'" or l1 == '"' then
				buffer[bIndex] = consumeString( l1 )

			elseif text:find( "^[A-Za-z_]+", position ) then
				buffer[bIndex] = consumeIdentifier()

			elseif text:find( "^0b[01]+", position ) then
				buffer[bIndex] = { type = "BinaryNumber", value = consumePattern "0b[01]+", source = source, line = line }

			elseif text:find( "^0x[a-fA-F0-9]+", position ) then
				buffer[bIndex] = { type = "HexNumber", value = consumePattern "0x[a-fA-F0-9]+", source = source, line = line }

			elseif text:find( "^%d*%.%d+e[%+%-]?%d+f", position ) then
				buffer[bIndex] = { type = "FloatNumber", value = consumePattern "%d*%.%d+e[%+%-]?%d+f", source = source, line = line }

			elseif text:find( "^%d*%.%d+f", position ) then
				buffer[bIndex] = { type = "FloatNumber", value = consumePattern "%d*%.%d+f", source = source, line = line }

			elseif text:find( "^%d*%.%d+e[%+%-]?%d+", position ) then
				buffer[bIndex] = { type = "DoubleNumber", value = consumePattern "%d*%.%d+e[%+%-]?%d+", source = source, line = line }

			elseif text:find( "^%d*%.%d+", position ) then
				buffer[bIndex] = { type = "DoubleNumber", value = consumePattern "%d*%.%d+", source = source, line = line }

			elseif text:find( "^%d+e%+?%d+b", position ) then
				buffer[bIndex] = { type = "ByteNumber", value = consumePattern "%d+e%+?%d+b", source = source, line = line }

			elseif text:find( "^%d+b", position ) then
				buffer[bIndex] = { type = "ByteNumber", value = consumePattern "%d+b", source = source, line = line }

			elseif text:find( "^%d+e%+?%d+", position ) then
				buffer[bIndex] = { type = "IntegerNumber", value = consumePattern "%d+e%+?%d+", source = source, line = line }

			elseif text:find( "^%d+", position ) then
				buffer[bIndex] = { type = "IntegerNumber", value = consumePattern "%d+", source = source, line = line }

			elseif symbols[l3] then
				position = position + 3
				buffer[bIndex] = { type = "Symbol", value = l3, source = source, line = line }

			elseif symbols[l2] then
				position = position + 2
				buffer[bIndex] = { type = "Symbol", value = l2, source = source, line = line }

			elseif symbols[l1] then
				position = position + 1
				buffer[bIndex] = { type = "Symbol", value = l1, source = source, line = line }
			
			else
				return error( source .. "[" .. line .. "]: unexpected symbol '" .. l1 .. "'", 0 )
			end
			
			skip()
		end
		return buffer[bIndex]
	end

	local lexer = {}

	function lexer:next()
		return getNextToken()
	end

	function lexer:back()
		bIndex = bIndex - 1
	end

	function lexer:throw( err )
		local t = getNextToken()
		local near = t.type == "EOF" and "<EOF>" or t.type == "String" and "<string>" or "'" .. t.value .. "'"
		return error( source .. "[" .. t.line .. "]: " .. tostring( err ) .. " (near " .. near .. ")", 0 )
	end

	function lexer:test( type, value )
		local t = getNextToken()
		bIndex = bIndex - 1
		return t.type == type and ( not value or t.value == value ) and t
	end

	function lexer:consume( type, value )
		local t = getNextToken()
		if t.type == type and ( not value or t.value == value ) then
			return t
		end
		bIndex = bIndex - 1
	end

	function lexer:isEOF()
		return position > #text
	end

	function lexer:mark()
		stack[#stack + 1] = bIndex
	end

	function lexer:home()
		bIndex = table.remove( stack, #stack )
	end
	
	skip()

	return lexer
end
