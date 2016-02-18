
@include common

@include VM
@include bytecode
@include source

local session = newSourceSession "Hawk/example"

session:addstr [[
void f(int a, b) ~~ body: addi 1 2 0 }
]]

local h = fs.open( "Hawk/log", "w" )
for i, v in ipairs( session:getDefinitions() ) do
	h.writeLine( textutils.serialize( v ) )
end
h.close()
