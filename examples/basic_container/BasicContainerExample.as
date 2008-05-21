/**
* Copyright (c) 2008 Paul Coyle
*
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without
* restriction, including without limitation the rights to use,
* copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the
* Software is furnished to do so, subject to the following
* conditions:
*
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
* OTHER DEALINGS IN THE SOFTWARE.
*/
package {
  import com.paulcoyle.lhasa.LayoutContainer;
  import com.paulcoyle.lhasa.layout_delegates.HorizontalLayoutDelegate;
  import com.paulcoyle.lhasa.layout_delegates.VerticalLayoutDelegate;
  
  import flash.display.Sprite;
  import flash.display.StageAlign;
  import flash.display.StageScaleMode;
  import flash.events.Event;
  import flash.events.KeyboardEvent;
  import flash.ui.Keyboard;

  /**
  * BasicContainerExample
  * A basic example for using LayoutContainers.  This example operates similar
  * to the BasicElementExample.
  *
  * @author Paul Coyle &lt;paul.b.coyle&64;gmail.com&gt;
  */
  public class BasicContainerExample extends Sprite {
    private var _container:LayoutContainer;
    
    public function BasicContainerExample() {
      stage.align = StageAlign.TOP_LEFT;
      stage.scaleMode = StageScaleMode.NO_SCALE;
      
      _container = new LayoutContainer(new HorizontalLayoutDelegate());
      _container.horizontal_spacing = 10;
      _container.vertical_spacing = 10;
      _container.padding.all = 10;
      addChild(_container);
      
      update_container_size();
      
      add_box_to_container();
      add_box_to_container();
      add_box_to_container();
      
      stage.addEventListener(Event.RESIZE, on_stage_resize, false, 0, true);
      stage.addEventListener(KeyboardEvent.KEY_DOWN, on_stage_key_down, false, 0, true);
    }
    
    // PRIVATE
    /**
    * Adds a SampleBox to the container.
    */
    private function add_box_to_container():void {
      var new_box:SampleBox = new SampleBox();
          new_box.defined_width = (Math.random() * 28 + 5).toString() + '%';
          new_box.defined_height = (Math.random() * 28 + 5).toString() + '%';
      _container.addChild(new_box);
    }
    
    /**
    * Updates the container to fit the stage.
    */
    private function update_container_size():void {
      _container.total_width = stage.stageWidth;
      _container.total_height = stage.stageHeight;
    }
    
    /**
    * Handles the stage resizing and updates the container dimensions.
    */
    private function on_stage_resize(event:Event):void {
      update_container_size();
    }
    
    /**
    * Handles keypresses at the stage.
    */
    private function on_stage_key_down(event:KeyboardEvent):void {
      if (event.keyCode == 86) {
        _container.horizontal_spacing = Math.random() * 40;
        _container.vertical_spacing = Math.random() * 40;
        _container.layout_delegate = new VerticalLayoutDelegate();
      }
      else if (event.keyCode == 72) {
        _container.horizontal_spacing = Math.random() * 40;
        _container.vertical_spacing = Math.random() * 40;
        _container.layout_delegate = new HorizontalLayoutDelegate();
      }
    }
  }
}