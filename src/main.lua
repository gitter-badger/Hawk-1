
@include common

@if TEST_SOURCE
	@include source
@elif TEST_BYTECODE
	@include bytecode
@elif TEST_VM
	@include VM
@endif

local session = newSourceSession "Hawk/example"
local ast = session:addstr [[
namespace A {
	namespace B {
		namespace C {
			class X;
		}
	}
}
]]
local h = fs.open( "Hawk/log", "w" )
h.write( textutils.serialize( ast ) )
h.close()
