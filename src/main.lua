
@include common

@if TEST_SOURCE
	@include source
@elif TEST_BYTECODE
	@include bytecode
@elif TEST_VM
	@include VM
@endif
