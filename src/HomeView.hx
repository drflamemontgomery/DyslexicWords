package;

import feathers.controls.Panel;
import feathers.controls.LayoutGroup;
import feathers.controls.Label;
import feathers.controls.Button;
import feathers.controls.Drawer;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.events.TriggerEvent;

using ComponentBuilder;

// The Startup View for the App
class HomeView extends Panel {

  private var _container : Drawer;

  public function new() {
    super();
    autoSizeMode = STAGE;
    
    _container = new Drawer();
    _container.drawer = new LayoutGroup();
    addChild(_container);
    header = createHomeHeader(); 
  }

  private function createHomeHeader() : LayoutGroup {
    return new LayoutGroup().withFields({
      variant : LayoutGroup.VARIANT_TOOL_BAR,
      layout : new AnchorLayout()
    }).withChildren([
      new Button("File", ).apply(addEventListener(
          TriggerEvent.TRIGGER, (event) -> {
            _container.opened = true;
          })
        ),
      new Label("Home").withFields({
        layoutData: AnchorLayoutData.center()
      })
    ]);
  }

}
