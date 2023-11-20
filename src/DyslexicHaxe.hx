import feathers.controls.Application;
import feathers.controls.TextArea;

class DyslexicHaxe extends Application {

  public static var ME : DyslexicHaxe;

	public function new() {
		super();
    ME = this;
    
    Fonts.init();

		addChild(new TextEditor());
	}
}
