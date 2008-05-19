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
  import com.paulcoyle.lhasa.events.LayoutElementEvent;
  
  import flash.display.Sprite;
  import flash.display.StageAlign;
  import flash.display.StageScaleMode;
  import flash.events.Event;
  import flash.events.MouseEvent;

  /**
  * BasicElementExample
  * A basic element example.  This example is only concerned with a subclass of
  * LayoutElement: SampleBox.  You can see how to set the total width and
  * height of an element and how it affects its drawing.  The red area
  * represents the margin, the green area represents the element area and the
  * blue area represents the padded area.
  *
  * @author Paul Coyle <paul.b.coyle@gmail.com>
  */
  public class BasicElementExample extends Sprite {
    private var _box:SampleBox;
    public function BasicElementExample() {
      stage.align = StageAlign.TOP_LEFT;
      stage.scaleMode = StageScaleMode.NO_SCALE;
      
      _box = new SampleBox();
      _box.total_width = 200;
      _box.total_height = 140;
      _box.addEventListener(LayoutElementEvent.UPDATED, on_box_updated, false, 0, true);
      addChild(_box);
      
      stage.addEventListener(MouseEvent.CLICK, on_stage_click, false, 0, true);
      stage.addEventListener(Event.RESIZE, on_stage_resize, false, 0, true);
    }
    
    // PRIVATE
    /**
    * Handles clicks to the stage.
    */
    private function on_stage_click(event:MouseEvent):void {
      _box.total_width = Math.random() * (stage.stageWidth - 100) + 100 ;
      _box.total_height = Math.random() * (stage.stageHeight - 100) + 100;
      _box.margin.all = Math.random() * 20 + 2;
      _box.padding.all = Math.random() * 20 + 2;
    }
    
    /**
    * Handles the stage resizing.  Fills the stage area.
    */
    private function on_stage_resize(event:Event):void {
      _box.total_width = stage.stageWidth;
      _box.total_height = stage.stageHeight;
    }
    
    /**
    * Handles updated events from the box.  Shows that multiple property
    * changes only result in one update.
    */
    private function on_box_updated(event:LayoutElementEvent):void {
      trace('Box was updated and redrawn.');
    }
  }
}