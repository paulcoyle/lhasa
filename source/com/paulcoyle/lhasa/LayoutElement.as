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
package com.paulcoyle.lhasa {
  import com.paulcoyle.lhasa.types.Box;
	import com.paulcoyle.lhasa.events.LayoutElementEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;

	/**
	* LayoutElement
	* Base class for all layout elements.
	*
	* @author Paul Coyle <paul.b.coyle@gmail.com>
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
		
		public function LayoutElement() {
			_margin = new Box();
			_padding = new Box();
			
			addEventListener(Event.RENDER, on_display_render, false, 0, true);
			
			_debug_rect_colour = Math.random() * 0xffffff;
			
			update_next();
		}
		
		// PUBLIC
		/**
		* Gets and sets the defined_width property.
		*/
		public function get defined_width():Number { return _defined_width }
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
  				dispatch_definition_invalidated();
  			}
		  }
		}
		
		/**
		* Gets and sets the defined_width_fixed property.
		*/
		public function get defined_width_fixed():Boolean { return _defined_width_fixed }
		public function set defined_width_fixed(value:Boolean):void {
			if (value != _defined_width_fixed) {
				_defined_width_fixed = value;
				dispatch_definition_invalidated();
			}
		}
		
		/**
		* Gets and sets the defined_height property.
		*/
		public function get defined_height():Number { return _defined_height }
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
  				dispatch_definition_invalidated();
  			}
		  }
		}
		
		/**
		* Gets and sets the defined_height_fixed property.
		*/
		public function get defined_height_fixed():Boolean { return _defined_height_fixed }
		public function set defined_height_fixed(value:Boolean):void {
			if (value != _defined_height_fixed) {
				_defined_height_fixed = value;
				dispatch_definition_invalidated();
			}
		}
		
		/**
		* Gets and sets the align_horizontal property.
		*/
		public function get align_horizontal():uint { return _align_horizontal }
		public function set align_horizontal(value:uint):void {
			if (value != _align_horizontal) {
				_align_horizontal = value;
				dispatch_definition_invalidated();
			}
		}
		
		/**
		* Gets and sets the layout_horizontal_align property.
		*/
		public function get align_vertical():uint { return _align_vertical }
		public function set align_vertical(value:uint):void {
			if (value != _align_vertical) {
				_align_vertical = value;
				dispatch_definition_invalidated();
			}
		}
		
		/**
		* Gets and sets the total_width property.
		*/
		public function get total_width():Number { return _total_width }
		public function set total_width(value:Number):void {
			if (value != _total_width) {
				_total_width = value;
				update_next();
			}
		}
		
		/**
		* Gets and sets the total_height property.
		*/
		public function get total_height():Number { return _total_height }
		public function set total_height(value:Number):void {
			if (value != _total_height) {
				_total_height = value;
				update_next();
			}
		}
		
		/**
		* Gets the margins property.
		*/
		public function get margin():Box { return _margin }
		
		/**
		* Gets the padding property.
		*/
		public function get padding():Box { return _padding }
		
		/**
		* Gets and sets the inner_width property.
		*/
		public function get inner_width():Number { return _total_width - _margin.left - _margin.right }
		public function set inner_width(value:Number):void { total_width = value + _margin.left + _margin.right }
		
		/**
		* Gets the inner_height property.
		*/
		public function get inner_height():Number { return _total_height - _margin.top - _margin.bottom }
		public function set inner_height(value:Number):void { total_height = value + _margin.top + _margin.bottom }
		
		/**
		* Gets the padded_width property.
		*/
		public function get padded_width():Number { return inner_width - _padding.left - _padding.right }
		public function set padded_width(value:Number):void { inner_width = value + _padding.left + _padding.right }
		
		/**
		* Gets the padded_height property.
		*/
		public function get padded_height():Number { return inner_height - _padding.top - _padding.bottom }
		public function set padded_height(value:Number):void { inner_height = value + _padding.top + _padding.bottom }
		
		/**
		* Gets the inner_offset property.
		*/
		public function get inner_offset():Point { return new Point(_margin.left, _margin.top) }
		
		/**
		* Gets the padded_offset property.
		*/
		public function get padded_offset():Point { return new Point(_margin.left + _padding.left, _margin.top + _padding.top) }
		
		// PROTECTED
		/**
		* Sets an internal flag causing the element to invalidate the stage if it
		* exists which will tridder the update method when the stage dispatches its
		* RENDER event.  If the stage is not available, a listener is added for the
		* ADDED_TO_STAGE event.  When that event fires an update is immediately
		* executed.
		*/
		protected function update_next():void {
		  if (_update_next == false) {
		    _update_next = true;
		    if (stage != null) stage.invalidate();
		    else addEventListener(Event.ADDED_TO_STAGE, on_added_to_stage_for_update_next, false, 0, true);
		  }
		}
		
		/**
		* Called when the inner_width or inner_height are changed.
		*/
		protected function update():void {
			if (DEBUG) {
				graphics.clear();
				graphics.beginFill(_debug_rect_colour, .2);
				graphics.drawRect(inner_offset.x, inner_offset.y, inner_width, inner_height);
				graphics.beginFill(_debug_rect_colour, 1);
				graphics.drawRect(inner_offset.x, inner_offset.y, inner_width, inner_height);
				graphics.drawRect(inner_offset.x + 1, inner_offset.y + 1, inner_width - 2, inner_height - 2);
			}
			dispatchEvent(new LayoutElementEvent(LayoutElementEvent.UPDATED));
		}
		
		/**
		* Updates if there is a pending render flag.
		*/
		protected function update_if_pending():void {
			if (_update_next) {
				update();
				_update_next = false;
			}
		}
		
		/**
		* Dispatches a LayoutElementEvent.DEFINITION_INVALIDATED event.
		*/
		protected function dispatch_definition_invalidated():void { dispatchEvent(new LayoutElementEvent(LayoutElementEvent.DEFINITION_INVALIDATED)) }
		
		// PRIVATE
		/**
		* Returns an object with two properties: value and fixed referring to
		* whether or not the value given is a percentage or a set value.  The two
		* possible formats are: '##.##%' and '##.##px'.  For example:
		* '12.34%' => {value:12.34, fixed:false}
		* '345px'  => {value:345, fixed:true}
		*/
		private function parse_numeric_string(value:String):Object {
		  var parse_expression:RegExp = /^([0-9]{1,})(\.[0-9]{0,})?(%|px)$/;
		  var parse_result:Array = value.match(parse_expression);
		  
		  if (parse_result != null) {
		    var is_fixed:Boolean = (parse_result[3] == 'px');
		    var parsed_value:Number = parseFloat(value);
		    return {
		      value: (is_fixed) ? parsed_value : parsed_value / 100,// percentages are converted to scalar values
		      fixed: is_fixed
		    };
		  }
		  else return {value:parseFloat(value), fixed:true};// Do our best with what we're given
		}
		
		/**
		* Handles the event indicating that a render is about to occur.  If the
		* _update_next property is set, the update() method is invoked.
		*/
		private function on_display_render(event:Event):void { update_if_pending() }
		
		/**
		* Handles an added to stage event that was listeneed for when attempting
		* an update_next call and the stage was, at that time, unavailable.
		*/
		private function on_added_to_stage_for_update_next(event:Event):void {
		  removeEventListener(Event.ADDED_TO_STAGE, on_added_to_stage_for_update_next);
		  update_if_pending();
		}
	}
}