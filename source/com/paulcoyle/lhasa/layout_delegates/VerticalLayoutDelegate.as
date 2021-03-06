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
	* the <code>alignVertical</code> attribute on the LayoutElements
	* it arranges positioning them relative to the container's height.
	*
	* @author Paul Coyle &lt;paul.b.coyle&64;gmail.com&gt;
	*
	* @see com.paulcoyle.lhasa.LayoutElement LayoutElement
	* @see com.paulcoyle.lhasa.LayoutElement#alignVertical LayoutElement.alignVertical
	*/
	public class VerticalLayoutDelegate implements ILayoutDelegate {
		// PUBLIC
		/**
		* @inheritDoc
		*/
		public function performLayout(container:LayoutContainer):void {
			// Find the total fixed height and the total relative height
			var children:Array = container.layoutChildren;
			var totalFixedHeight:Number = container.verticalSpacing * (children.length - 1);
			var totalRelativeHeight:Number = 0;// Sum of scalars
			var child:LayoutElement;
			for each (child in children) {
				if (child.definedHeightFixed) totalFixedHeight += child.definedHeight;
				else totalRelativeHeight += child.definedHeight;
			}
			
			// Is there any remaining relative height?
			var relative_height:Number = 0;// In actual pixels, what remains after fixed values
			if (container.paddedHeight > totalFixedHeight) relative_height = container.paddedHeight - totalFixedHeight;
			
			// Resize and position children
			var yOffset:Number = container.paddedOffset.y;
			var totalHeight:Number = container.verticalSpacing * (children.length - 1);
			var maxWidth:Number = 0;
			for each (child in children) {
				// If the child's height is relative calculate it as a percent
				// of the total divided by all relative elements and set it,
				// otherwise set its defined height
				if (!child.definedHeightFixed) child.totalHeight = relative_height * (child.definedHeight / totalRelativeHeight);
				else child.totalHeight = child.definedHeight;
				
				// Add to the total height calculation
				totalHeight += child.totalHeight;
				
				// If the child's width is relative calculate it as a percent
				// of the whole of this container's width
				if (!child.definedWidthFixed) child.totalWidth = container.paddedWidth * child.definedWidth;
				else child.totalWidth = child.definedWidth;
				
				// Set the maxmimum width value
				maxWidth = Math.max(maxWidth, child.totalWidth);
				
				// Position the child and increment the vertical offset tally
				child.y = yOffset;
				yOffset += child.totalHeight + container.verticalSpacing;
				
				// Align the child according to its alignment settings
				switch (child.alignHorizontal) {
					case Align.LEFT:
						child.x = container.paddedOffset.x;
						break;
					
					case Align.MIDDLE:
						child.x = (container.totalWidth / 2) - (child.totalWidth / 2);
						break;
					
					case Align.RIGHT:
						child.x = container.totalWidth - child.totalWidth - container.margin.right - container.padding.right;
						break;
				}
			}
			
			container.contentWidth = maxWidth;
			container.contentHeight = totalHeight;
			
			if (container.sizeToContentWidth) {
				container.definedWidth = container.contentWidth + container.padding.horizontal + container.margin.horizontal;
			}
			
			if (container.sizeToContentHeight) {
				container.definedHeight = container.contentHeight + container.padding.vertical + container.margin.vertical;
			}
		}
	}
}