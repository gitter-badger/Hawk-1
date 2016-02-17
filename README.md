
## Hawk

Hawk is a programming language somewhat like C but focussed slightly more around OOP.

An example of its syntax is shown below:

```
import graphics;
import keyboard;

namespace UI {
	enum TextAlignment {
		Top, Bottom;
		Left, Right;
		Center;
	}

	interface IPosition {
		private int x, y;

		void setPosition(int x, y) {
			self.x = x; self.y = y;
		}
	}

	class Button implements IPosition {
		string text;
		TextAlignment alignment;

		Button(int x, y, string text) {
			self.x = x; self.y = y;
			self.text = text;
		}

		void draw() {
			try {
				graphics::Display:getActive():drawRectangle(self.x, self.y, 100, 50);
				graphics::Display:getActive():drawText(self.text, self.x, self.y);
			}
			catch NoActiveDisplay e
				print( e );
		}

		static Button random() {
			return Button(int:random(), int:random(), ""); // whoops, forgot I took out the width/height parameters above
		}
	}
}

Button buttons[];
bool running = true;

for i in 1 .. 10
	buttons[i] = Button.random();

new keyboard::KeyPressCallback callback;

void callback:onPress(int keycode) {
	switch keycode
	case keyboard::Keycode.a
		print "w was pressed";
	default
		print "another key was pressed";
}

keyboard::addCallback(callback);

while running {
	for int i = 0, i < #buttons, i++
		buttons[i]:draw();
}
```
