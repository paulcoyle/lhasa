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
  import flash.events.Event;
  import flash.events.EventDispatcher;
  
	/**
	* Describes the values for the four sides of an element.  Used for defining
	* the <code>margin</code> and <code>padding</code> properties of
	* LayoutElements.
	*
	* @author Paul Coyle &lt;paul.b.coyle&64;gmail.com&gt;
	* @see com.paulcoyle.lhasa.LayoutElement#margin LayoutElement.margin
	* @see com.paulcoyle.lhasa.LayoutElement#padding LayoutElement.padding
	*/
	public class Box extends EventDispatcher {
		private var _top:Number;
		private var _right:Number;
		private var _bottom:Number;
		private var _left:Number;
		
		/**
		* Creates a new Box.
		* 
		* @param top The value for the top of the box.
		* @param right The value for the right side of the box.
		* @param bottom The value for the bottom of the box.
		* @param left The value for the left side of the box.
		*/
		public function Box(top:Number = 0, right:Number = 0, bottom:Number = 0,
		                left:Number = 0) {
			_top = top;
			_right = right;
			_bottom = bottom;
			_left = left;
		}
		
		// PUBLIC
		/**
		* The value for the top of the box.
		*/
		public function get top():Number { return _top }
		/**
		* @private
		*/
		public function set top(value:Number):void {
		  if (value != _top) {
		    _top = value;
		    dispatchEvent(new Event(Event.CHANGE));
		  }
		}
		
		/**
		* The value for the right side of the box.
		*/
		public function get right():Number { return _right }
		/**
		* @private
		*/
		public function set right(value:Number):void {
		  if (value != _right) {
		    _right = value
		    dispatchEvent(new Event(Event.CHANGE));
		  }
		}
		
		/**
		* The value for the bottom of the box.
		*/
		public function get bottom():Number { return _bottom }
		/**
		* @private
		*/
		public function set bottom(value:Number):void {
		  if (value != _bottom) {
		    _bottom = value;
		    dispatchEvent(new Event(Event.CHANGE));
		  }
		}
		
		/**
		* The value for the left side of the box.
		*/
		public function get left():Number { return _left }
		/**
		* @private
		*/
		public function set left(value:Number):void {
		  if (value != _left) {
		    _left = value;
		    dispatchEvent(new Event(Event.CHANGE));
		  }
		}
		
		/**
		* Sets all properties (<code>top</code>, <code>right</code>,
		* <code>bottom</code> and <code>left</code>) to the supplied value.
		*/
		public function set all(value:Number):void {
		  top = right = bottom = left = value;
		}
		
		/**
		* The sum of the <code>right</code> and <code>left</code> values.  Setting
		* this property applies the given value to both <code>right</code> and
		* <code>left</code> equally.
		* 
		* <p><span class="label">Example</span>
		* <pre>
		* var box:Box = new Box(1, 2, 3, 4);
		* trace(box.right, box.left, box.horizontal);// (2 4 6)
		* 
		* box.horizontal = 10;
		* trace(box.right, box.left, box.horizontal);// (10 10 20)
		* </pre>
		* </p>
		* 
		* @see #right
		* @see #left
		*/
		public function get horizontal():Number { return left + right }
		/**
		* @private
		*/
		public function set horizontal(value:Number):void { left = right = value }
		
		
		/**
		* The sum of the <code>top</code> and <code>bottom</code> values.  Setting
		* this property applies the given value to both <code>top</code> and
		* <code>bottom</code> equally.
		* 
		* <p><span class="label">Example</span>
		* <pre>
		* var box:Box = new Box(1, 2, 3, 4);
		* trace(box.top, box.bottom, box.vertical);// (1 3 4)
		* 
		* box.vertical = 10;
		* trace(box.top, box.bottom, box.vertical);// (10 10 20)
		* </pre>
		* </p>
		* 
		* @see #top
		* @see #bottom
		*/
		public function get vertical():Number { return top + bottom }
		/**
		* @private
		*/
		public function set vertical(value:Number):void { top = bottom = value }
	}
}