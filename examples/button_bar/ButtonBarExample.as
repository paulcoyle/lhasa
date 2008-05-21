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
  import com.paulcoyle.lhasa.utils.StageLayoutContainer;
  import com.paulcoyle.lhasa.layout_delegates.HorizontalLayoutDelegate;
  import com.paulcoyle.lhasa.layout_delegates.VerticalLayoutDelegate;
  
  import flash.events.KeyboardEvent;
  import flash.ui.Keyboard;

  /**
  * ButtonBarExample
  * A basic example creating a resizing button bar.  This example makes use of
  * the utility class StageLayoutContainer which is useful for building your
  * main application classes from.
  *
  * @author Paul Coyle &lt;paul.b.coyle&64;gmail.com&gt;
  */
  public class ButtonBarExample extends StageLayoutContainer {
    private var _bar:Bar;
    
    public function ButtonBarExample() {
      super();
      
      _bar = new Bar();
      _bar.addChild(new Button());
      _bar.addChild(new Button());
      _bar.addChild(new Button());
      _bar.addChild(new Button());
      addChild(_bar);
      
      stage.addEventListener(KeyboardEvent.KEY_DOWN, on_stage_key_down, false, 0, true);
    }
    
    // PRIVATE
    /**
    * Handles keypresses at the stage.
    */
    private function on_stage_key_down(event:KeyboardEvent):void {
      if (event.keyCode == 86)
        _bar.layout_delegate = new VerticalLayoutDelegate();
      else if (event.keyCode == 72)
        _bar.layout_delegate = new HorizontalLayoutDelegate();
    }
  }
}