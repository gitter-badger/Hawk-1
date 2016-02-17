
@include common

@include VM
@include bytecode
@include source

local session = newSourceSession "Hawk/example"
local ast = session:addstr [[
int a[], b;
int f();
]]
local h = fs.open( "Hawk/log", "w" )
h.write( textutils.serialize( ast ) )
h.close()
