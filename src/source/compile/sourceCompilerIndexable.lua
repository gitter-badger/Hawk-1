
 -- keeps a track of function calling and variable lookup for both scopes and classes

local function matchParameter( desired, given )
	if desired.class == given.class then
		return 2
	elseif desired.class:castsTo( given.class ) then
		return 1
	end
	return 0
end

local function matchParameters( desired, given )
	if #given > #desired then return 0 end

	local total = 0

	for i = 1, #desired do
		if given[i] then
			local addition = matchParameter( desired[i], given[i] )
			if addition == 0 then
				return 0 -- no match
			else
				total = total + addition -- partial or full match
			end
		elseif desired[i].default then
			total = total + 2 -- exact match
		else
			return 0
		end
	end

	return total
end

local function newSourceCompilerIndexable( members, methods )
	local index = {}

	function index:addPrivateMember( name, data )
		members[#members + 1] = { false, name, data }
	end

	function index:addPublicMember( name, data )
		members[#members + 1] = { true, name, data }
	end

	function index:addPrivateMethod( name, data, params )
		methods[#methods + 1] = { false, name, data, params }
	end

	function index:addPublicMethod( name, data, params )
		methods[#methods + 1] = { true, name, data, params }
	end

	function index:lookup( name, private_access )
		for i = #members, 1, -1 do
			if private_access or members[i][1] then -- has access or is public
				if members[i][2] == name then -- name matches
					return i, members[i][3]
				end
			end
		end
	end

	function index:call( name, private_access, parameters )
		local match, maxweight = nil, 0
		local matchi

		for i = #methods, 1, -1 do
			if private_access or methods[i][1] then -- has access or is public
				if methods[i][2] == name then -- name matches
					local weight = matchParameters( methods[i][4], parameters )
					if weight > maxweight then
						match, matchi = methods[i][3], i
					end
				end
			end
		end

		return matchi, match
	end

	return index
end
