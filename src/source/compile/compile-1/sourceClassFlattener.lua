
 --[[

	Need to 'flatten' classes:
	
	A) merge interfaces, taking overrides into account
	B) merge class members (private/public static/instance need to go into a single list)
	C) append to super class, if any

	so...

		interface A {
			int a = 1;
			int b = 1;
		}
		interface B {
			override A int b = 2;
		}
		class C {
			int c = 3;
		}
		class D extends C implements A and B {
			int c = 4;
		}

	goes to...

		class D {
			int c = 3;
			int a = 1;
			int b = 2;
			int c = 4;
		}

	Note, order of class variables:

		:super stuff:
		public_members
		private_members
		public_functions
		private_functions
		static_public_members
		static_private_members
		static_public_functions
		static_private_functions

 ]]

local function throw( object, err )
	return error( object.source .. "[" .. object.line .. "]: " .. err )
end

local function comptype

local function compmodifiers( a, b )
	if #a == #b then
		for i = 1, #a do
			if a[i].type == "array" and b[i].type ~= "array" then
				return false
			elseif a[i].type == "table" and ( b[i].type ~= "table" or not comptype( a[i].index, b[i].index ) ) then
				return false
			end
		end
		return true
	end
	return false
end

function comptype( a, b )
	return a[1] == b[1] and compmodifiers( a[2], b[2] )
end

local function compparameters( a, b )
	if #a ~= #b then return false end
	for i = 1, #a do
		if not comptype( { a[i].typename, a[i].modifiers }, { b[i].typename, b[i].modifiers } ) then
			return false
		end
	end
	return true
end

local function compmethod( a, b )
	return a.typename == b.typename and compmodifiers( a.modifiers, b.modifiers )
	and compparameters( a.parameters, b.parameters )
end

local function modifiers( type, modifiers )
	for i = 1, #modifiers do
		if modifiers[i].type == 
	end
end

local function newtype( environment, name, mod )
	local type = environment:lookupType( definition.typename )
	for i = 1, #mod do
		if mod[i].type == "array" then
			type = arrayOf( type )
		elseif mod[i].type == "table" then
			type = tableOf( type, newtype( environment, mod[i].index[1], mod[i].index[2] ) )
		end
	end
	return type
end

local function canOverride( data, definition, overrides, adder )
	if not data[2][definition.name] then return true end

	for i = 1, #overrides do
		if overrides[i] == data[4] then
			return true
		end
	end

	for i = 1, #name[2] do
		if name[2][i] == adder then
			return false
		end
	end

	throw( definition, "conflict over name '" .. definition.name .. "' between " .. adder .. " and " .. data[4] )
end

local function merge( environment, data, definition, adder )
	if definition.type == "funcdefinition" then
		if canOverride( data, definition, definition.overrides, adder ) then

			local returntype = newtype( environment, definition.returntype, definition.modifiers )
			local parameters = {}

			for i = 1, #definition.parameters do
				local d = definition.parameters[i]
				parameters[i] = {
					paramtype = newtype( environment, d.typename, d.modifiers ), default = d.default, name = d.name
				}
			end

			data[3][definition.name] = data[3][definition.name] or #data[1] + 1
			data[1][data[3][definition.name]] = { type = "function", returntype = returntype, parameters = parameters, body = definition.body }
		end
	else
		for i = 1, #definition do
			if canOverride( data, definition[i], definition.overrides, adder ) then
				local vartype = newtype( environment, definition[i].typename, definition[i].modifiers )

				data[3][definition.name] = data[3][definition.name] or #data[1] + 1
				data[1][data[3][definition.name]] = { type = "other", vartype = vartype, value = definition[i].value }
			end
		end
	end
end

local function flattenSourceClass( class, environment )
	local public, private, static_public, static_private = {
		{}, {}, {} -- current, override lookup, name lookup
	}, {
		{}, {}, {}
	}, {
		{}, {}, {}
	}, {
		{}, {}, {}
	}

	local function implement( list )
		if #list == 0 then return end

		for i = 1, #list do
			local body = list[i].body
			local name = list[i].name

			implement( list[i].implements )

			for i = 1, #body[1] do
				merge( environment, public, body[1][i], name )
			end
		end
	end

	for i = 1, #class.implements do

	end
end

 --[[
		source = source, line = line;
		type = "class";
		name = name;
		extends = extends;
		implements = implements;
		body = {
			public, private, static_public, static_private
		}
]]
