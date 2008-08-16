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
package com.paulcoyle.lhasa.events {
	import flash.events.Event;

	/**
	* Describes events occuring on LayoutElements.
	*
	* @author Paul Coyle &lt;paul.b.coyle&64;gmail.com&gt;
	*/
	public class LayoutElementEvent extends Event {
	  /**
	  * Dispatched when a LayoutElement's measurement values are changed in some
	  * way that would affects its layout within a container.
	  *
	  * @eventType com.paulcoyle.lhasa.events.LayoutElementEvent.INVALIDATED
	  */
		public static const INVALIDATED:String = 'layout invalidated';
		
		/**
		* Dispatched when a LayoutElement has been internally updated.
		*
		* @eventType com.paulcoyle.lhasa.events.LayoutElementEvent.UPDATED
		*/
		public static const UPDATED:String = 'layout updated';
		
		public function LayoutElementEvent(type:String) { super(type) }
	}
}
