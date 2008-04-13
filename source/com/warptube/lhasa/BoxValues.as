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
	* BoxValues
	* Describes the values for the four sides of an element.
	*
	* @author Paul Coyle <paul.b.coyle@gmail.com>
	*/
	public class BoxValues {
		private var _top:Number;
		private var _right:Number;
		private var _bottom:Number;
		private var _left:Number;
		
		public function BoxValues(top:Number = 0, right:Number = 0, bottom:Number = 0, left:Number = 0) {
			_top = top;
			_right = right;
			_bottom = bottom;
			_left = left;
		}
		
		// PUBLIC
		/**
		* Gets and sets the top property.
		*/
		public function get top():Number { return _top }
		public function set top(value:Number):void { _top = value }
		
		/**
		* Gets and sets the right property.
		*/
		public function get right():Number { return _right }
		public function set right(value:Number):void { _right = value }
		
		/**
		* Gets and sets the bottom property.
		*/
		public function get bottom():Number { return _bottom }
		public function set bottom(value:Number):void { _bottom = value }
		
		/**
		* Gets and sets the left property.
		*/
		public function get left():Number { return _left }
		public function set left(value:Number):void { _left = value }
		
		/**
		* Sets all properties.
		*/
		public function set all(value:Number):void { _top = _right = _bottom = _left = value }
		
		/**
		* Gets the sum of the left and right properties.  Setting assigns the
		* value given to both properties.
		*/
		public function get horizontal():Number { return _left + _right }
		public function set horizontal(value:Number):void { _left = _right = value }
		
		
		/**
		* Gets the sum of the top and bottom properties.  Setting assigns the
		* value given to both properties.
		*/
		public function get vertical():Number { return _top + _bottom }
		public function set vertical(value:Number):void { _top = _bottom = value }
	}
}