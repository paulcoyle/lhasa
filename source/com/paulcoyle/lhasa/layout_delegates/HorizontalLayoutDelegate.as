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
  import com.paulcoyle.lhasa.types.Align;
  
	/**
	* Arranges its LayoutElement children horizontally.  This delegate honours
	* the <code>align_vertical</code> attribute on the LayoutElements
	* it arranges positioning them relative to the container's height.
	*
	* @author Paul Coyle &lt;paul.b.coyle&64;gmail.com&gt;
	*
	* @see com.paulcoyle.lhasa.LayoutElement LayoutElement
	* @see com.paulcoyle.lhasa.LayoutElement#align_vertical LayoutElement.align_vertical
	*/
	public class HorizontalLayoutDelegate implements ILayoutDelegate  {
		// PUBLIC
		/**
		* @inheritDoc
		*/
		public function perform_layout(container:LayoutContainer):void {
			// Find the total fixed width and the total relative width
			var children:Array = container.layout_element_children;
			var total_fixed_width:Number = container.horizontal_spacing * (children.length - 1);
			var total_relative_width:Number = 0;// Sum of scalars
			var child:LayoutElement;
			for each (child in children) {
				if (child.defined_width_fixed) total_fixed_width += child.defined_width;
				else total_relative_width += child.defined_width;
			}
			
			// Is there any remaining relative width?
			var relative_width:Number = 0;// In actual pixels, what remains after fixed values
			if (container.padded_width > total_fixed_width) relative_width = container.padded_width - total_fixed_width;
			
			// Resize and position children
			var x_offset:Number = container.padded_offset.x;
			var total_width:Number = container.horizontal_spacing * (children.length - 1);
			var max_height:Number = 0;
			for each (child in children) {
				// If the child's width is relative calculate it as a percent
				// of the total divided by all relative elements and set it,
				// otherwise set its defined width
				if (!child.defined_width_fixed) child.total_width = relative_width * (child.defined_width / total_relative_width);
				else child.total_width = child.defined_width;
				
				// Add to the total width calculation
				total_width += child.total_width;
				
				// If the child's height is relative calculate it as a percent
				// of the whole of this container's height
				if (!child.defined_height_fixed) child.total_height = container.padded_height * child.defined_height;
				else child.total_height = child.defined_height;
				
				// Set the maxmimum height value
				max_height = Math.max(max_height, child.total_height);
				
				// Position the child and increment the horizontal offset tally
				child.x = x_offset;
				x_offset += child.total_width + container.horizontal_spacing;
				
				// Align the child according to its alignment settings
				switch (child.align_vertical) {
					case Align.TOP:
						child.y = container.padded_offset.y;
						break;
					
					case Align.MIDDLE:
						child.y = container.padded_offset.y + (container.padded_height / 2) - (child.total_height / 2);
						break;
					
					case Align.BOTTOM:
						child.y = container.total_height - child.total_height - container.margin.bottom - container.padding.bottom;
						break;
				}
			}
			
			container.content_width = total_width;
			container.content_height = max_height;
			
			if (container.size_to_content_width) {
				container.defined_width = container.content_width + container.padding.horizontal + container.margin.horizontal;
			}
			
			if (container.size_to_content_height) {
				container.defined_height = container.content_height + container.padding.vertical + container.margin.vertical;
			}
		}
	}
}