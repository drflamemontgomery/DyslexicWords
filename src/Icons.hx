package;

import openfl.display.Shape;


// Class for Icons that are used in the project
class Icons {
 
  // Createst the classic three bar menu icon programmatically 
  public static function threeBarMenu(size : Int, color:Int) {
    var shape = new Shape();
    var padding = size / 16;
    var height = size / 4;
    var width = size - padding*2;
    var roundness = height / 2;
    
    shape.graphics.beginFill(color);
    for(i in 0...3) {
      shape.graphics.drawRoundRect(
          0,
          (padding + height)*i,
          width, height,
          roundness, roundness);
    }
    shape.graphics.endFill();

    return shape;
  }

}
