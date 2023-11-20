import openfl.events.Event;

import feathers.controls.TextArea;
import feathers.core.ValidatingSprite;
import openfl.text.TextFormat;
import openfl.text.TextField;

// A wrapper class for the TextArea to implement
// changing fonts for individual words
//
// TODO optimize rendering with bitmap caching
class TextEditor extends ValidatingSprite {

  private var _textArea : TextArea;
  private var _wordLength : Int = 0;
  private var _styles : Array<TextFormat> = [];

  private function generateStyles() {
    var textGenerator = new TextFormatGenerator(20);
    _styles = textGenerator.generateFormats(20);
    _textArea = new TextArea();
    _textArea.addEventListener(Event.CHANGE, onTextChange);
  }

  private function setupListeners() {
    if(stage != null) {
      _onAddedToStage();
    } else {
      addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }
  }

  public function new() {
    super();
    
    generateStyles();
    setupListeners();

    addChild(_textArea);
  }

  //==================================================--
  // Resize Event Listeners
  //==================================================--

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

  //==================================================--
  // Text Event Listeners
  //==================================================--

  private function onTextChange(event:Event) {
    var textArea = cast(event.currentTarget, TextArea);
    
    // early exit if word length has not changed
    var wordLength = wordLengthChanged(textArea);
    if(wordLength == -1) return;
    _wordLength = wordLength;
    
    formatText(textArea);
  }

  //==================================================--
  // Text Helper Functions 
  //==================================================--

  // returns -1 if length is the same
  private function wordLengthChanged(textArea : TextArea) : Int {
    var words = textArea.text.split(' ');
   
    // removes all empty strings 
    // TODO implement proper whitespace 
    while(words.remove('')) {};

    return _wordLength == words.length ? -1 : words.length;
  }

  private function getStyleIndex(textArea : TextArea) : Int {
    var words = textArea.text.split(' ');
    
    var styleIndex = 0;
    
    var curPos :Int = @:privateAccess getTextField(textArea).__prevCaretIndex;
    var _index = 0;
    var pos = 0;

    while(_index < words.length) {
      var endPos = pos + words[_index].length;
      _index++;

      if(endPos >= curPos) break;
      pos = endPos + 1;
      if(words[_index] != '') styleIndex++;
    }

    return styleIndex;
  }

  private function formatText(textArea:TextArea) {
    var styleIndex = getStyleIndex(textArea); 
    var curPos = @:privateAccess getTextField(textArea).__prevCaretIndex;
  
    while(curPos < textArea.text.length) {
      var endPos :Int = curPos;
      while(endPos < textArea.text.length
          && StringTools.fastCodeAt(textArea.text, endPos) == ' '.code) {
        endPos++;
        continue;
      }
      while(endPos < textArea.text.length
          && StringTools.fastCodeAt(textArea.text, endPos) != ' '.code) {
        endPos++;
      }
      getTextField(textArea).setTextFormat(_styles[styleIndex % _styles.length], curPos, endPos);
      curPos = endPos;
      styleIndex++;
    }
  }

  inline function getTextField(textArea:TextArea) {
    return @:privateAccess textArea.textFieldViewPort.textField;
  }
}
