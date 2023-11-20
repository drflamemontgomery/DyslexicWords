package;

import openfl.text.Font;
import openfl.text.FontStyle;

class Fonts {
  

  static private var initialized = false;
  public static function init() {
    if(initialized) return;
    initialized = true;

    createFont("Oswald");
    createFont("SpaceGrotesk");
    createFont("PTSerif");
    createFont("DancingScript");
    
  }

  static function __createFont(name:String, style:FontStyle) {

    var font :Font = 
      switch(style) {
        case BOLD:
          Font.fromFile('fonts/$name-Bold.ttf');
        case BOLD_ITALIC:
          Font.fromFile('fonts/$name-BoldItalic.ttf');
        case ITALIC:
          Font.fromFile('fonts/$name-Italic.ttf');
        case REGULAR:
          Font.fromFile('fonts/$name-Regular.ttf');
      };

    if(font == null) return;
    font.fontName = name;
    font.fontStyle = style;
    Font.registerFont(font);
  }
  
  static function createFont(name:String) {
    __createFont(name, FontStyle.BOLD);
    __createFont(name, FontStyle.BOLD_ITALIC);
    __createFont(name, FontStyle.ITALIC);
    __createFont(name, FontStyle.REGULAR);
  }

}
