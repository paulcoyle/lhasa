/**
* Copyright (c) 2008 Paul Coyle
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*/
package com.paulcoyle.lhasa.layout_delegates {
  import com.paulcoyle.lhasa.LayoutContainer;
  import com.paulcoyle.lhasa.LayoutElement;
  
  /**
  * A layout delegate that concerns itself only with the sizing of its
  * contained elements.  We also diregard sizing to the content width and
  * height though this may be useful to implement in the future.
  *
  * @author Paul Coyle &lt;paul.b.coyle&64;gmail.com&gt;
  */
  public class FreeLayoutDelegate implements ILayoutDelegate {
    // PUBLIC
		/**
		* @inheritDoc
		*/
		public function perform_layout(container:LayoutContainer):void {
		  var children:Array = container.layout_element_children;
		  var child:LayoutElement;
		  for each (child in children) {
		    // Set the width
		    if (child.defined_width_fixed) child.total_width = child.defined_width;
		    else child.total_width = container.padded_width * child.defined_width;
		    
		    // Set the height
		    if (child.defined_height_fixed) child.total_height = child.defined_height;
		    else child.total_height = container.padded_height * child.defined_height;
		  }
	  }
  }
}