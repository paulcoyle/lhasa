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
package com.paulcoyle.lhasa.types {
	/**
	* Defines alignment settings on LayoutElements.  Used on the
	* <code>align_horizontal</code> and <code>align_vertical</code>
	* properties.
	*
	* @author Paul Coyle &lt;paul.b.coyle&64;gmail.com&gt;
	* @see com.paulcoyle.lhasa.LayoutElement#align_vertical LayoutElement.align_vertical
	* @see com.paulcoyle.lhasa.LayoutElement#align_horizontal LayoutElement.align_horizontal
	*/
	public class Align {
	  /**
	  * Aligns to the middle either horizontally or vertically.
	  */
		public static const MIDDLE:uint = 0;
		
		/**
	  * Aligns to the left.
	  */
		public static const LEFT:uint = 1;
		
		/**
	  * Aligns to the right.
	  */
		public static const RIGHT:uint = 2;
		
		/**
	  * Aligns to the top.
	  */
		public static const TOP:uint = 3;
		
		/**
	  * Aligns to the bottom.
	  */
		public static const BOTTOM:uint = 4;
	}
}