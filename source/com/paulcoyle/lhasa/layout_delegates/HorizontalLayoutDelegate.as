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
	public class HorizontalLayoutDelegate implements ILayoutDelegate  {
		// PUBLIC
		/**
		* @inheritDoc
		*/
		public function performLayout(container:LayoutContainer):void {
			// Find the total fixed width and the total relative width
			var children:Array = container.layoutChildren;
			var totalFixedWidth:Number = container.horizontalSpacing * (children.length - 1);
			var totalRelativeWidth:Number = 0;// Sum of scalars
			var child:LayoutElement;
			for each (child in children) {
				if (child.definedWidthFixed) totalFixedWidth += child.definedWidth;
				else totalRelativeWidth += child.definedWidth;
			}
			
			// Is there any remaining relative width?
			var relativeWidth:Number = 0;// In actual pixels, what remains after fixed values
			if (container.paddedWidth > totalFixedWidth) relativeWidth = container.paddedWidth - totalFixedWidth;
			
			// Resize and position children
			var xOffset:Number = container.paddedOffset.x;
			var totalWidth:Number = container.horizontalSpacing * (children.length - 1);
			var maxHeight:Number = 0;
			for each (child in children) {
				// If the child's width is relative calculate it as a percent
				// of the total divided by all relative elements and set it,
				// otherwise set its defined width
				if (!child.definedWidthFixed) child.totalWidth = relativeWidth * (child.definedWidth / totalRelativeWidth);
				else child.totalWidth = child.definedWidth;
				
				// Add to the total width calculation
				totalWidth += child.totalWidth;
				
				// If the child's height is relative calculate it as a percent
				// of the whole of this container's height
				if (!child.definedHeightFixed) child.totalHeight = container.paddedHeight * child.definedHeight;
				else child.totalHeight = child.definedHeight;
				
				// Set the maxmimum height value
				maxHeight = Math.max(maxHeight, child.totalHeight);
				
				// Position the child and increment the horizontal offset tally
				child.x = xOffset;
				xOffset += child.totalWidth + container.horizontalSpacing;
				
				// Align the child according to its alignment settings
				switch (child.alignVertical) {
					case Align.TOP:
						child.y = container.paddedOffset.y;
						break;
					
					case Align.MIDDLE:
						child.y = container.paddedOffset.y + (container.paddedHeight / 2) - (child.totalHeight / 2);
						break;
					
					case Align.BOTTOM:
						child.y = container.totalHeight - child.totalHeight - container.margin.bottom - container.padding.bottom;
						break;
				}
			}
			
			container.contentWidth = totalWidth;
			container.contentHeight = maxHeight;
			
			if (container.sizeToContentWidth) {
				container.definedWidth = container.contentWidth + container.padding.horizontal + container.margin.horizontal;
			}
			
			if (container.sizeToContentHeight) {
				container.definedHeight = container.contentHeight + container.padding.vertical + container.margin.vertical;
			}
		}
	}
}