import openfl.events.Event;

import feathers.controls.TextArea;
import feathers.controls.Label;
import feathers.controls.LayoutGroup;
import feathers.layout.FlowRowsLayout;
import feathers.core.ValidatingSprite;
import openfl.text.TextFormat;
import openfl.text.TextField;
import openfl.Assets;

class TextEditor extends ValidatingSprite {

  private var _textArea : TextArea;
  private var _textField(get, never) : TextField;

  private var _wordLength : Int = 0;
  private var _styles : Array<TextFormat> = [];

  inline function get__textField() {
    return @:privateAccess _textArea.textFieldViewPort.textField;
  }

  public function new() {
    super();

    var textGenerator = new TextFormatGenerator(20);
    _styles = textGenerator.generateFormats(20);
    _textArea = new TextArea();
    _textArea.addEventListener(Event.CHANGE, onTextChange);
    
    if(stage != null) {
      _onAddedToStage();
    } else {
      addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    addChild(_textArea);
  }

  private function _onAddedToStage() {
    stage.addEventListener(Event.RESIZE, onResize, false, 0, true);
    addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
  }

  private function onAddedToStage(event:Event) {
    _onAddedToStage();
  }

  private function onResize(event:Event) {
    _textArea.width = stage.stageWidth;
    _textArea.height = stage.stageHeight;
  }

  private function onRemovedFromStage(event:Event) {
    removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
    stage.removeEventListener(Event.RESIZE, onResize);
    addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
  }


  private function onTextChange(event:Event) {
    var textArea = cast(event.currentTarget, TextArea);
   
     
    var allWords = textArea.text.split(' ');
    var words = allWords.copy();
    
    while(words.remove('')) {
      // do not do anything
    };

    if(_wordLength ==  words.length) return;


    _wordLength = words.length;

    var styleIndex = 0;
    var curPos :Int = @:privateAccess _textField.__prevCaretIndex;
    
    {
      var _index = 0;
      var pos = 0;

      while(_index < allWords.length) {
        var endPos = pos + allWords[_index].length;
        _index++;

        if(endPos >= curPos) break;
        pos = endPos + 1;
        if(allWords[_index] != '') styleIndex++;
      }
    }
    
    curPos -= 1;
  
    while(curPos < textArea.text.length) {
      var endPos :Int = curPos;
      while(endPos < textArea.text.length && StringTools.fastCodeAt(textArea.text, endPos) == ' '.code) {
        endPos++;
        continue;
      }
      while(endPos < textArea.text.length && StringTools.fastCodeAt(textArea.text, endPos) != ' '.code) {
        endPos++;
      }
      _textField.setTextFormat(_styles[styleIndex % _styles.length], curPos, endPos);
      curPos = endPos;
      styleIndex++;
    }
  }

  override private function update():Void {
    super.update();
  }
}
