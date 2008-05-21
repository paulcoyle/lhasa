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
  
  /**
  * Bar
  * A bar that contains buttons.
  *
  * @author Paul Coyle &lt;paul.b.coyle&64;gmail.com&gt;
  */
  public class Bar extends LayoutContainer {
    public function Bar() {
      super(new HorizontalLayoutDelegate());
      
      size_to_content_width = true;
      size_to_content_height = true;
      
      horizontal_spacing = vertical_spacing = 5;
      margin.all = 5;
      padding.all = 5;
    }
    
    // PROTECTED
    /**
    * Updates the graphics on the bar.
    */
    override protected function update():void {
      super.update();
      
      graphics.clear();
      graphics.beginFill(0, .8);
      graphics.drawRoundRect(inner_offset.x, inner_offset.y, inner_width, inner_height, 10, 10);
      graphics.beginFill(0, 1);
      graphics.drawRoundRect(inner_offset.x, inner_offset.y, inner_width, inner_height, 10, 10);
      graphics.drawRoundRect(inner_offset.x + 1, inner_offset.y + 1, inner_width - 2, inner_height - 2, 8, 8);
    }
  }
}