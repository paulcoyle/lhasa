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
package com.paulcoyle.lhasa {
  import com.paulcoyle.lhasa.types.Box;
	import com.paulcoyle.lhasa.events.LayoutElementEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;

	/**
	* Base class for all layout elements.
	*
	* @author Paul Coyle &lt;paul.b.coyle&64;gmail.com&gt;
	*/
	public class LayoutElement extends Sprite {
		/*
		* These fixed values determine if the width or height are fixed at
		* their values or are a scalar 0 ≤ n ≤ 1 representing a percentage of
		* the free space in a container.  Essentially these are the desired
		* dimensions of the element.
		*/
		private var _defined_width:Number = 1;
		private var _defined_height:Number = 1;
		private var _defined_width_fixed:Boolean;
		private var _defined_height_fixed:Boolean;
		
		/*
		* These values define alignment and when set will invalidate the
		* element just like the defined_* properties will.
		*/
		private var _align_horizontal:uint;
		private var _align_vertical:uint;
		
		/*
		* These values represent how the parent or external object is
		* instructing the object to be drawn.  This usually happnes in the
		* update method of containers where layout calculations are done.
		*/
		private var _total_width:Number = 0;
		private var _total_height:Number = 0;
		
		/*
		* These object contain values for the four sides of the element and
		* represent the margin and padding.  When the total_(width|height) is
		* set, the margins are subtracted and set as the inner_(width|height).
		* Similarily, the padded_(width|height) is the inner_(width|height)
		* minus the padding values.
		*/
		private var _margin:Box;
		private var _padding:Box;
		
		/*
		* Indicates whether or not the element should update when the next
		* render event is received from the stage.
		*/
		private var _update_next:Boolean;
		
		/*
		* Some values for debugging.
		*/
		private static const DEBUG:Boolean = false;
		private var _debug_rect_colour:uint;
		
		/**
		* Creates a new LayoutElement.
		*/
		public function LayoutElement() {
			_margin = new Box();
			_margin.addEventListener(Event.CHANGE, on_margin_change, false, 0, true);
			_padding = new Box();
			_padding.addEventListener(Event.CHANGE, on_padding_change, false, 0, true);
			
			_debug_rect_colour = Math.random() * 0xffffff;
			
			addEventListener(Event.ADDED_TO_STAGE, on_added_to_stage,
			  false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, on_removed_from_stage,
			  false, 0, true);
			
			update_next();
		}
		
		// PUBLIC
		/**
		* The declared width that this element should be.  Works in concert with
		* the <code>defined_width_fixed</code> property.
		*
		* <p>This property can be set in two separate ways: numerically and
		* textually.  Setting the value numerically will simply set the value and
		* dispatch an event.  By passing a string to this property both the values
		* for <code>defined_width</code> and <code>defined_width_fixed</code> can
		* be set simultaneously. To set these values textually you may use the
		* formats:
		*   <ul>
		*     <li>##.##px</li>
		*     <li>##.##%</li>
		*   </ul></p>
		*
		* <p><span class="label">Example</span>
		*    <pre>
		* var element:LayoutElement = new LayoutElement();
		*    
		* element.defined_width = '34.5px';
		* trace(element.defined_width, element.defined_width_fixed);// (34.5 true)
		* 
		* element.defined_width = '55.123%';
		* trace(element.defined_width, element.defined_width_fixed);// (0.55123 false)
		* </pre>
		*   It is important to note that non-fixed values are converted to
		*   scalars.
		* </p>
		*
		* @default 1
		*
		* @see #defined_width_fixed
		*/
		public function get defined_width():Number { return _defined_width }
		/**
		* @private
		*/
		public function set defined_width(value:*):void {
		  if (value is String) {
		    var values:Object = parse_numeric_string(value as String);
		    defined_width = values.value;
		    defined_width_fixed = values.fixed;
		    return;
		  }
		  else if (value is Number) {
  		  value = value as Number;
  			if (value != _defined_width) {
  				_defined_width = value;
  				dispatch_layout_invalidated();
  			}
		  }
		}
		
		/**
		* Indicates whether or not the value for <code>defined_width</code> should
		* be treated as a fixed or variable value.
		*
		* @default false
		*
		* @see #defined_width
		*/
		public function get defined_width_fixed():Boolean { return _defined_width_fixed }
		/**
		* @private
		*/
		public function set defined_width_fixed(value:Boolean):void {
			if (value != _defined_width_fixed) {
				_defined_width_fixed = value;
				dispatch_layout_invalidated();
			}
		}
		
		/**
		* The declared width that this element should be.  Works in concert with
		* the <code>defined_width_fixed</code> property.  For details on how to set
		* values textually see the definition for <code><a href="#defined_width">defined_width</a></code>.
		*
		* @default 1
		*
		* @see #defined_height_fixed
		*/
		public function get defined_height():Number { return _defined_height }
		/**
		* @private
		*/
		public function set defined_height(value:*):void {
		  if (value is String) {
		    var values:Object = parse_numeric_string(value as String);
		    defined_height = values.value;
		    defined_height_fixed = values.fixed;
		    return;
		  }
		  else if (value is Number) {
  		  value = value as Number;
  			if (value != _defined_height) {
  				_defined_height = value;
  				dispatch_layout_invalidated();
  			}
		  }
		}
		
		/**
		* Indicates whether or not the value for <code>defined_height</code> should
		* be treated as a fixed or variable value.
		*
		* @default false
		*
		* @see #defined_height
		*/
		public function get defined_height_fixed():Boolean { return _defined_height_fixed }
		/**
		* @private
		*/
		public function set defined_height_fixed(value:Boolean):void {
			if (value != _defined_height_fixed) {
				_defined_height_fixed = value;
				dispatch_layout_invalidated();
			}
		}
		
		/**
		* The horizontal alignment for the element.
		*
		* @default 0 (MIDDLE)
		*
		* @see com.paulcoyle.lhasa.types.Align
		*/
		public function get align_horizontal():uint { return _align_horizontal }
		/**
		* @private
		*/
		public function set align_horizontal(value:uint):void {
			if (value != _align_horizontal) {
				_align_horizontal = value;
				dispatch_layout_invalidated();
			}
		}
		
		/**
		* The vertical alignment for the element.
		*
		* @default 0 (MIDDLE)
		*
		* @see com.paulcoyle.lhasa.types.Align
		*/
		public function get align_vertical():uint { return _align_vertical }
		/**
		* @private
		*/
		public function set align_vertical(value:uint):void {
			if (value != _align_vertical) {
				_align_vertical = value;
				dispatch_layout_invalidated();
			}
		}
		
		/**
		* The total width assigned <em>to</em> the element.  This is usually set by
		* the element container's layout delegate.  This values affects the values
		* for: <code>inner_offset</code>, <code>inner_width</code>,
		* <code>padded_offset</code> and <code>padded_width</code>.
		*
		* @default 0
		*
		* @see #inner_offset
		* @see #inner_width
		* @see #padded_offset
		* @see #padded_width
		*/
		public function get total_width():Number { return _total_width }
		/**
		* @private
		*/
		public function set total_width(value:Number):void {
			if (value != _total_width) {
				_total_width = value;
				update_next();
			}
		}
		
		/**
		* The total height assigned <em>to</em> the element.  This is usually set by
		* the element container's layout delegate.  This values affects the values
		* for: <code>inner_offset</code>, <code>inner_height</code>,
		* <code>padded_height</code> and <code>padded_height</code>.
		*
		* @default 0
		*
		* @see #inner_offset
		* @see #inner_height
		* @see #padded_offset
		* @see #padded_height
		*/
		public function get total_height():Number { return _total_height }
		/**
		* @private
		*/
		public function set total_height(value:Number):void {
			if (value != _total_height) {
				_total_height = value;
				update_next();
			}
		}
		
		/**
		* The margin values for this element.
		*
		* @see com.paulcoyle.lhasa.types.Box
		*/
		public function get margin():Box { return _margin }
		
		/**
		* The padding values for this element.
		*
		* @see com.paulcoyle.lhasa.types.Box
		*/
		public function get padding():Box { return _padding }
		
		/**
		* Defines the width of the element without margins.
		*/
		public function get inner_width():Number {
		  return _total_width - _margin.left - _margin.right;
		}
		/**
		* @private
		*/
		public function set inner_width(value:Number):void {
		  total_width = value + _margin.left + _margin.right;
		}
		
		/**
		* Defines the height of the element without margins.
		*/
		public function get inner_height():Number {
		  return _total_height - _margin.top - _margin.bottom;
		}
		/**
		* @private
		*/
		public function set inner_height(value:Number):void {
		  total_height = value + _margin.top + _margin.bottom;
		}
		
		/**
		* Defines the width of the element without margins and with padding.
		*/
		public function get padded_width():Number {
		  return inner_width - _padding.left - _padding.right;
		}
		/**
		* @private
		*/
		public function set padded_width(value:Number):void {
		  inner_width = value + _padding.left + _padding.right;
		}
		
		/**
		* Defines the height of the element without margins and with padding.
		*/
		public function get padded_height():Number {
		  return inner_height - _padding.top - _padding.bottom;
		}
		/**
		* @private
		*/
		public function set padded_height(value:Number):void {
		  inner_height = value + _padding.top + _padding.bottom;
		}
		
		/**
		* Defines the local coordinates that represent the top left corner of the
		* element where the inner area (without margin) begins.
		*/
		public function get inner_offset():Point {
		  return new Point(_margin.left, _margin.top);
		}
		
		/**
		* Defines the local coordinates that represent the top left corner of the
		* element where the padded area (without margin and with padding) begins.
		*/
		public function get padded_offset():Point {
		  return new Point(_margin.left + _padding.left, _margin.top + _padding.top);
		}
		
		// PROTECTED
		/**
		* Sets an internal flag indicating that the element needs to update on the
		* next render.  We use the <code>ENTER_FRAME</code> event to trigger renders
		* since the <code>RENDER</code> event is unreliable
		* (see <a href="http://www.actionscript.org/forums/archive/index.php3/t-143158.html">
		* this forum post for details</a>).
		*
		* @see #update()
		*/
		protected function update_next():void { _update_next = true }
		
		/**
		* Called after the stage has been invalidated due to a call to
		* <code>update_next()</code> which indicates that a value that could
		* warrant a graphical update has changed.
		*
		* @see #update_next()
		*/
		protected function update():void {
			if (DEBUG) {
				graphics.clear();
				graphics.beginFill(_debug_rect_colour, .2);
				graphics.drawRect(inner_offset.x, inner_offset.y, inner_width,
				  inner_height);
				graphics.beginFill(_debug_rect_colour, 1);
				graphics.drawRect(inner_offset.x, inner_offset.y, inner_width,
				  inner_height);
				graphics.drawRect(inner_offset.x + 1, inner_offset.y + 1,
				  inner_width - 2, inner_height - 2);
			}
			dispatchEvent(new LayoutElementEvent(LayoutElementEvent.UPDATED));
		}
		
		/**
		* Updates if there is a pending update flag set by <code>update()</code>.
		*
		* @see #update()
		* @see #update_next()
		*/
		protected function update_if_pending():void {
			if (_update_next) {
			  _update_next = false;
				update();
			}
		}
		
		/**
		* Dispatches a LayoutElementEvent.INVALIDATED event.
		*/
		protected function dispatch_layout_invalidated():void {
		  dispatchEvent(new LayoutElementEvent(LayoutElementEvent.INVALIDATED));
		}
		
		// PRIVATE
		/**
		* Returns an object with two properties: value and fixed referring to
		* whether or not the value given is a percentage or a set value.  The two
		* possible formats are: '##.##%' and '##.##px'.  For example:
		* '12.34%' => {value:0.1234, fixed:false}
		* '345px'  => {value:345, fixed:true}
		* 
		* Note that percentages are converted to scalar (0≤n≤1) values.
		*/
		private function parse_numeric_string(value:String):Object {
		  var parse_expression:RegExp = /^([0-9]{1,})(\.[0-9]{0,})?(%|px)$/;
		  var parse_result:Array = value.match(parse_expression);
		  
		  if (parse_result != null) {
		    var is_fixed:Boolean = (parse_result[3] == 'px');
		    var parsed_value:Number = parseFloat(value);
		    return {
		      value: (is_fixed) ? parsed_value : parsed_value / 100,
		      fixed: is_fixed
		    };
		  }
		  else return {value:parseFloat(value), fixed:true};// Do our best with what we're given
		}
		
		/**
		* Handles changes on the margin Box.  Invalidates the element.
		*/
		private function on_margin_change(event:Event):void {
		  dispatch_layout_invalidated();
		}
		
		/**
		* Handles changes on the padding Box.  Invalidates the element.
		*/
		private function on_padding_change(event:Event):void {
		  dispatch_layout_invalidated();
		}
		
		/**
		* Handles the element being added to the stage and performs an update if one
		* is pending.  The element will now listen for enter frame events.
		*/
		private function on_added_to_stage(event:Event):void {
		  addEventListener(Event.ENTER_FRAME, on_enter_frame, false, 0, true);
		  update_if_pending();
		}
		
		/**
		* Handles the element being removed from the stage.  We quit listening for
		* enter frame events since they will not be received and are not needed.
		*/
		private function on_removed_from_stage(event:Event):void {
		  removeEventListener(Event.ENTER_FRAME, on_enter_frame);
		}
		
		/**
		* Handles an enter frame event and performs and update if one is pending.
		*/
		private function on_enter_frame(event:Event):void { update_if_pending() }
	}
}
