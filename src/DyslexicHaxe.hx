package;

import feathers.controls.Application;

class DyslexicHaxe extends Application {

  public static var ME : DyslexicHaxe;

	public function new() {
		super();
    ME = this;
    
    Fonts.init();

    // Only for testing the Text Editor
    // Will be replaced with navigation
		addChild(new TextEditor());
	}
}
