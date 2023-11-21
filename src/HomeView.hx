package;

import feathers.controls.Panel;
import feathers.controls.LayoutGroup;
import feathers.controls.Label;
import feathers.layout.AnchorLayout;

using ComponentBuilder;

// The Startup View for the App
class HomeView extends Panel {

  public function new() {
    super();
    autoSizeMode = STAGE;

    header = createHomeHeader(); 
  }

  private function createHomeHeader() : LayoutGroup {
    return new LayoutGroup().withFields({
      variant : LayoutGroup.VARIANT_TOOL_BAR,
      layout : new AnchorLayout()
    }).withChildren([
      new Label("Home")
    ]);
  }
}
