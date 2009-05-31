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
  import com.paulcoyle.lhasa.LayoutElement;
  
  /**
  * SampleBox
  * An example layout element.
  *
  * @author Paul Coyle &lt;paul.b.coyle&64;gmail.com&gt;
  */
  public class SampleBox extends LayoutElement {
    public function SampleBox() {
      super();
      
      margin.all = 10;
      padding.all = 10;
    }
    
    // PROTECTED
    /**
    * Updates this element.
    */
    override protected function update():void {
      super.update();
      graphics.clear();
      graphics.beginFill(0xff0000, 1);
      graphics.drawRect(0, 0, totalWidth, totalHeight);
      graphics.beginFill(0x00ff00, 1);
      graphics.drawRect(innerOffset.x, innerOffset.y, innerWidth, innerHeight);
      graphics.beginFill(0x0000ff, 1);
      graphics.drawRect(paddedOffset.x, paddedOffset.y, paddedWidth, paddedHeight);
    }
  }
}