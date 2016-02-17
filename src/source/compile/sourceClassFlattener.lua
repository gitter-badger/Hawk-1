
 --[[

	Need to 'flatten classes':

	A) start off with super class (if any)
	B) merge interfaces
	C) merge class members (private/public static/instance need to go into a single list)

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
			int a = 1;
			int b = 2;
			int c = 4;
		}

	Note, order of class variables:

		public_members
		private_members
		public_functions
		private_functions
		static_public_members
		static_private_members
		static_public_functions
		static_private_functions

 ]]

local function flattenSourceClass( class )

end
