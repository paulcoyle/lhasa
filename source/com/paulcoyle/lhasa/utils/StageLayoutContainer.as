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
package com.paulcoyle.lhasa.utils {
  import com.paulcoyle.lhasa.LayoutContainer;
  import com.paulcoyle.lhasa.layout_delegates.ILayoutDelegate;
  import com.paulcoyle.lhasa.layout_delegates.FreeLayoutDelegate;
  
  import flash.display.StageAlign;
  import flash.display.StageScaleMode;
  import flash.events.Event;
  
  /**
  * A container that manages its own total_width and total_height to match that
  * of the stage.  Your application class should extend this class and invoke
  * <code>super()</code> immediately in the constructor.  This class defaults to
  * using the <code>FreeLayoutDelegate</code> so that subsequent containers can
  * be placed manually but this is by no means the only way to use this class.
  *
  * @author Paul Coyle &lt;paul.b.coyle&64;gmail.com&gt;
  * @see com.paulcoyle.lhasa.LayoutContainer LayoutContainer
  * @see com.paulcoyle.lhasa.layout_delegates FreeLayoutDelegate
  */
  public class StageLayoutContainer extends LayoutContainer {
    /**
    * Creates a new StageLayoutContainer.
    *
    * @param layout_delegate A layout delegate to be used for this container.
    * Defaults to the FreeLayoutDelegate.
    */
    public function StageLayoutContainer(layout_delegate:ILayoutDelegate = null) {
      super((layout_delegate == null) ? new FreeLayoutDelegate() : layout_delegate);
      
      stage.align = StageAlign.TOP_LEFT;
      stage.scaleMode = StageScaleMode.NO_SCALE;
      
      update_metrics_from_stage();
      
      stage.addEventListener(Event.RESIZE, on_stage_resize, false, 0, true);
    }
    
    // PRIVATE
    /**
    * Handles the stage resizing.
    */
    private function on_stage_resize(event:Event):void {
      update_metrics_from_stage();
    }
    
    /**
    * Resizes this container to match the stage.
    */
    private function update_metrics_from_stage():void {
      total_width = stage.stageWidth;
      total_height = stage.stageHeight;
    }
  }
}