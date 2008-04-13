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
package com.warptube.lhasa {
	/**
	* HorizontalBox
	* Arranges its UIElement children horizontally.
	*
	* @author Paul Coyle <paul.b.coyle@gmail.com>
	*/
	public class HorizontalBox extends UIContainer {
		public function HorizontalBox() { super() }
		
		// PROTECTED
		/**
		* Handles updating when the element changes size.
		*/
		override protected function update():void {
			super.update();
			
			// Find the total fixed width and the total relative width
			var children:Array = get_ui_element_children();
			var total_fixed_width:Number = horizontal_spacing * (children.length - 1);
			var total_relative_width:Number = 0;// Sum of scalars
			var child:UIElement;
			for each (child in children) {
				if (child.defined_width_fixed) total_fixed_width += child.defined_width;
				else total_relative_width += child.defined_width;
			}
			
			// Is there any remaining relative width?
			var relative_width:Number = 0;// In actual pixels, what remains after fixed values
			if (padded_width > total_fixed_width) relative_width = padded_width - total_fixed_width;
			
			// Resize and position children
			var x_offset:Number = padded_offset.x;
			var total_width:Number = horizontal_spacing * (children.length - 1);
			var max_height:Number = 0;
			for each (child in children) {
				// If the child's width is relative calculate it as a percent
				// of the total divided by all relative elements and set it,
				// otherwise set its defined width
				if (!child.defined_width_fixed) child.layout_width = relative_width * (child.defined_width / total_relative_width);
				else child.layout_width = child.defined_width;
				
				// Add to the total width calculation
				total_width += child.layout_width;
				
				// If the child's height is relative calculate it as a percent
				// of the whole of this container's height
				if (!child.defined_height_fixed) child.layout_height = padded_height * child.defined_height;
				else child.layout_height = child.defined_height;
				
				// Set the maxmimum height value
				max_height = Math.max(max_height, child.layout_height);
				
				// Position the child and increment the horizontal offset tally
				child.x = child.rounding_method(x_offset);
				x_offset += child.layout_width + horizontal_spacing;
				
				// Align the child according to its alignment settings
				switch (child.align_vertical) {
					case Align.TOP:
						child.y = child.rounding_method(padded_offset.y);
						break;
					
					case Align.MIDDLE:
						child.y = child.rounding_method(padded_offset.y + (padded_height / 2) - (child.layout_height / 2));
						break;
					
					case Align.BOTTOM:
						child.y = child.rounding_method(layout_height - child.layout_height - margins.bottom - padding.bottom);
						break;
				}
				
				child.render_if_pending();
			}
			
			_content_width = total_width;
			_content_height = max_height;
			
			if (size_to_content_width) {
				defined_width = rounding_method(_content_width + padding.horizontal + margins.horizontal);
			}
			
			if (size_to_content_height) {
				defined_height = rounding_method(_content_height + padding.vertical + margins.vertical);
			}
		}
	}
}