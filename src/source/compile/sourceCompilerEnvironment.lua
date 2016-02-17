
local function newSourceCompilerEnvironment()
	local namespaces = {}
	local env = {}
	local using = { {} }
	local namespace_stack = {}
	local scope_stack = {}

	local function flattenNamespaces()
		local t = {}

		for i = #using, 1, -1 do
			for n = #using[i], 1, -1 do
				t[#t + 1] = using[i][n]
			end
		end

		if #namespace_stack > 0 then
			t[#t + 1] = table.concat( namespace_stack, "::" )
		end

		return t
	end

	function env:getNamespace()
		return table.concat( namespace_stack, "::" )
	end

	function env:inNamespace( name )
		namespace_stack[#namespace_stack + 1] = name
		using[#using + 1] = {}
		name = self:getNamespace()
		namespaces[name] = namespaces[name] or newSourceCompilerIndexable( {}, {} )
	end

	function env:using( name )
		if namespaces[name] then
			using[#using + 1] = name
			return true
		end
		return false
	end

	function env:outNamespace()
		namespace_stack[#namespace_stack] = nil
		using[#using] = nil
	end

	function env:addLoopScope()
		scope_stack[#scope_stack + 1] = {
			type = "loop";
			index = newSourceCompilerIndexable( {}, {} );
		}
	end

	function env:addFunctionScope()
		scope_stack[#scope_stack + 1] = {
			type = "function";
			index = newSourceCompilerIndexable( {}, {} );
		}
	end

	function env:addMethodScope( class )
		scope_stack[#scope_stack + 1] = {
			type = "method";
			index = newSourceCompilerIndexable( {}, {} );
			class = class;
		}
	end

	function env:addScope()
		scope_stack[#scope_stack + 1] = {
			type = "default";
			index = newSourceCompilerIndexable( {}, {} );
		}
	end

	function env:lookupNamespace( name )
		for i, v in ipairs( flattenNamespaces() ) do
			if namespaces[v .. "::" .. name] then
				return v .. "::" .. name
			end
		end

		return namespaces[name] or false
	end

	function env:lookupType( name )
		local v = self:lookup( name )
		return v and v.instance
	end

	function env:lookupInterface( name )
		local v = self:lookup( name )
		return v and v.isInterface and v
	end

	function env:lookup( name )
		if name:find "::" then
			local namespace = self:lookupNamespace( name:match "^(.+)::" )
			return namespace and namespaces[namespace]:lookup( name, true )
		else
			for i = #scope_stack, 1, -1 do
				local i, v = scope_stack[i]:lookup( name, true )
				if i then return i, v end
			end
			for i, v in ipairs( flattenNamespaces() ) do
				local i, v = namespaces[v]:lookup( name, true )
				if i then return i, v end
			end
		end
	end

	function env:call( name, params )
		if name:find "::" then
			local namespace = self:lookupNamespace( name:match "^(.+)::" )
			return namespace and namespaces[namespace]:call( name, true, params )
		else
			for i = #scope_stack, 1, -1 do
				local i, v = scope_stack[i]:call( name, true, params )
				if i then return i, v end
			end
			for i, v in ipairs( flattenNamespaces() ) do
				local i, v = namespaces[v]:call( name, true, params )
				if i then return i, v end
			end
		end
	end

	env:using "A"
	env:lookup "B::C"

end
