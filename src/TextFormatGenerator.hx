package;

import openfl.text.TextFormat;
import openfl.Assets;
import openfl.text.Font;

class TextFormatGenerator {
 
  public static var fonts : Array<String> = [];
  private static var initialized : Bool = false;

  public static function init() {
    if(initialized) return;
    initialized = true;
      
    fonts = [
      "Oswald",
      "SpaceGrotesk",
      "PTSerif",
      "DancingScript",
      /*Assets.getFont("fonts/Oswald-Regular.ttf").fontName,
      Assets.getFont("fonts/SpaceGrotesk-Regular.ttf").fontName,
      Assets.getFont("fonts/PTSerif-Regular.ttf").fontName,
      Assets.getFont("fonts/DancingScript-Regular.ttf").fontName,*/
    ];
  }

  private var size : Null<Int>;

  public function new(?size:Int) {
    init();

    this.size = size;
  }

  private function randomFont() {
    return fonts[Random.int(0, fonts.length-1)];
  }

  private function randomSize() {
    return size + Random.int(0, 8) - 4;
  }

  inline function abs(a:Int) {
    return a < 0 ? -a : a;
  }

  public function generateFormats(num:Int) :Array<TextFormat> {
    var formats :Array<TextFormat> = [];
    var lastFormat = new TextFormat(randomFont(), randomSize());
    formats.push(lastFormat);
   
    var bold = false; 
    for(i in 0...num) {
      var format = new TextFormat(randomFont(), randomSize(), null, bold);
      bold = !bold;

      while(format.font == lastFormat.font) {
        format.font = randomFont();
      }
      while(abs(format.size - lastFormat.size) < 2) {
        format.size = randomSize();
      }

      formats.push(format);
      lastFormat = format;
    }
    
    var firstFormat = formats[0];
    var prevFormat = formats[formats.length-2];
    while(lastFormat.font == firstFormat.font ||
        lastFormat.font == prevFormat.font) {
      lastFormat.font = randomFont();
    }
    while(abs(lastFormat.size - firstFormat.size) < 2 &&
        abs(lastFormat.size - prevFormat.size) < 2) {
      lastFormat.size = randomSize();
    }
    
    return formats;
  }
  
}
