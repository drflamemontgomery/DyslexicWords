package;

import openfl.text.TextFormat;
import openfl.Assets;
import openfl.text.Font;

// A helper class for generating text formats
class TextFormatGenerator {
 
  //==================================================--
  // Static Fields
  //==================================================--

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
    ];
  }

  //==================================================--
  // Instance Fields
  //==================================================--

  private var _size : Null<Int>;

  public function new(?size:Int) {
    init();

    this._size = size;
  }

  public function generateFormats(num:Int) :Array<TextFormat> {
    var formats :Array<TextFormat> = [];
    var lastFormat = new TextFormat(randomFont(), randomSize());
    formats.push(lastFormat);
   
    var bold = false; 
    for(i in 0...num) {
      
      var format = generateContrastingFormat(lastFormat, bold);
      bold = !bold;
      formats.push(format);
      lastFormat = format;
    }
    
    makeFormatContrast(lastFormat, formats[0], formats[formats.length-2]); 
    return formats;
  }

  //==================================================--
  // Random Generatiion Functions
  //==================================================--

  // Ensure that the last format contrasts with the previous and the next format
  private function makeFormatContrast(targetFormat:TextFormat, format1:TextFormat, format2:TextFormat):Void {
    while(targetFormat.font == format1.font ||
        targetFormat.font == format2.font) {
      targetFormat.font = randomFont();
    }

    while(abs(targetFormat.size - format1.size) < 2 &&
        abs(targetFormat.size - format2.size) < 2) {
      targetFormat.size = randomSize();
    }
  }

  // Generate a Format that is distinguishable from neighbouring Formats
  private function generateContrastingFormat(lastFormat:TextFormat, bold:Bool) :TextFormat {
    var format = new TextFormat(randomFont(), randomSize(), null, bold);

    while(format.font == lastFormat.font) {
      format.font = randomFont();
    }
    while(abs(format.size - lastFormat.size) < 2) {
      format.size = randomSize();
    }

    return format;
  }

  private function randomFont() {
    return fonts[Random.int(0, fonts.length-1)];
  }

  private function randomSize() {
    return _size + Random.int(0, 8) - 4;
  }

  inline function abs(a:Int) {
    return a < 0 ? -a : a;
  }

}
