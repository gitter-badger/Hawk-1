
@include common

@include VM
@include bytecode
@include source

local session = newSourceSession "Hawk/example"
print "---------------------------"
local ast = session:addstr [[
namespace A {
	class X {}
}

using A;

namespace A::B {
	class X {}
}

void f() {
	console::print "hi";
}
]]
local h = fs.open( "Hawk/log", "w" )
h.write( textutils.serialize( ast ) )
h.close()
