package;

import feathers.controls.Panel;
import feathers.controls.LayoutGroup;
import feathers.controls.Label;
import feathers.controls.Button;
import feathers.controls.Drawer;
import feathers.controls.Header;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.layout.VerticalLayout;
import feathers.layout.VerticalListFixedRowLayout;
import feathers.skins.RectangleSkin;
import feathers.graphics.FillStyle;
import feathers.events.TriggerEvent;

import openfl.display.DisplayObject;

using ComponentBuilder;

// The Startup View for the App
class HomeView extends Panel {

  private var _container : Drawer;

  public function new() {
    super();
    autoSizeMode = STAGE;
    
    addChild(_container = _createHomeDrawer());
    header = _createHomeHeader(); 
  }

  private inline function _createHomeHeader() : Header {
    return new Header().withFields({
      text : "Home",
      leftView : new Button().withFields({
        icon : Icons.threeBarMenu(24, 0x2e2e2e)
      }).apply(
        setPadding(6),
        addEventListener(
          TriggerEvent.TRIGGER, (event) -> {
            _container.opened = !_container.opened;
          })
        )
    });
  }

  private inline function _createHomeDrawer() : Drawer {
    return new Drawer().withFields({
      content : new LayoutGroup().withFields({
        layout : new VerticalLayout().withFields({
          horizontalAlign : CENTER,
          verticalAlign : MIDDLE,
        })
      }),
      drawer : _createDrawerContent(),
    });
  }

  private inline function _createDrawerContent() : LayoutGroup {
    return new LayoutGroup().withFields({
      layout : new VerticalListFixedRowLayout().withFields({
        paddingTop: 6.0,
        paddingBottom: 6.0,
        paddingLeft: 20.0,
        paddingRight: 20.0,

        gap: 12.0,
      }),
      backgroundSkin: new RectangleSkin(FillStyle.SolidColor(0xffffff)),
    }).withChildren([
      new Button("I am TEXT!!!"),
      new Button("I am also TEXT!!!"),
    ]);
  }

  private inline function _wrapDrawerItem(content:DisplayObject) : DisplayObject {
    return content;
  }
}
