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
	* VerticalBox
	* Arranges its UIElement children vertically.
	*
	* @author Paul Coyle <paul.b.coyle@gmail.com>
	*/
	public class VerticalBox extends UIContainer {
		public function VerticalBox() { super() }
		
		// PROTECTED
		/**
		* Handles updating when the element changes size.
		*/
		override protected function update():void {
			super.update();
			
			// Find the total fixed height and the total relative height
			var children:Array = get_ui_element_children();
			var total_fixed_height:Number = vertical_spacing * (children.length - 1);
			var total_relative_height:Number = 0;// Sum of scalars
			var child:UIElement;
			for each (child in children) {
				if (child.defined_height_fixed) total_fixed_height += child.defined_height;
				else total_relative_height += child.defined_height;
			}
			
			// Is there any remaining relative height?
			var relative_height:Number = 0;// In actual pixels, what remains after fixed values
			if (padded_height > total_fixed_height) relative_height = padded_height - total_fixed_height;
			
			// Resize and position children
			var y_offset:Number = padded_offset.y;
			var total_height:Number = vertical_spacing * (children.length - 1);
			var max_width:Number = 0;
			for each (child in children) {
				// If the child's height is relative calculate it as a percent
				// of the total divided by all relative elements and set it,
				// otherwise set its defined height
				if (!child.defined_height_fixed) child.layout_height = relative_height * (child.defined_height / total_relative_height);
				else child.layout_height = child.defined_height;
				
				// Add to the total height calculation
				total_height += child.layout_height;
				
				// If the child's width is relative calculate it as a percent
				// of the whole of this container's width
				if (!child.defined_width_fixed) child.layout_width = padded_width * child.defined_width;
				else child.layout_width = child.defined_width;
				
				// Set the maxmimum width value
				max_width = Math.max(max_width, child.layout_width);
				
				// Position the child and increment the vertical offset tally
				child.y = child.rounding_method(y_offset);
				y_offset += child.layout_height + vertical_spacing;
				
				// Align the child according to its alignment settings
				switch (child.align_horizontal) {
					case Align.LEFT:
						child.x = child.rounding_method(padded_offset.x);
						break;
					
					case Align.MIDDLE:
						child.x = child.rounding_method((layout_width / 2) - (child.layout_width / 2));
						break;
					
					case Align.RIGHT:
						child.x = child.rounding_method(layout_width - child.layout_width - margins.right - padding.right);
						break;
				}
				
				child.render_if_pending();
			}
			
			_content_width = max_width;
			_content_height = total_height;
			
			if (size_to_content_width) {
				defined_width = rounding_method(_content_width + padding.horizontal + margins.horizontal);
			}
			
			if (size_to_content_height) {
				defined_height = rounding_method(_content_height + padding.vertical + margins.vertical);
			}
		}
	}
}