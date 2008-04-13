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
	import com.warptube.lhasa.event.UIElementEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;

	/**
	* UIElement
	* Base class for all UI elements.
	*
	* @author Paul Coyle <paul.b.coyle@gmail.com>
	*/
	public class UIElement extends Sprite {
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
		private var _layout_width:Number = 0;
		private var _layout_height:Number = 0;
		
		/*
		* These object contain values for the four sides of the element and
		* represent the margin and padding.  When the layout_(width|height) is
		* set, the margins are subtracted and set as the draw_(width|height).
		* Similarily, the padded_(width|height) is the draw_(width|height)
		* minus the padding values.
		*/
		private var _margins:BoxValues;
		private var _padding:BoxValues;
		
		/*
		* Indicates whether or not the element should render when the next
		* render event is received.
		*/
		private var _render_next:Boolean;
		
		/*
		* Provides a function for determining how positioning and sizing is rounded
		* for this element.
		*/
		private var _rounding_method:Function;
		
		/*
		* Some values for debugging.
		*/
		private static const DEBUG:Boolean = false;
		private var _debug_rect_colour:uint;
		
		public function UIElement() {
			_margins = new BoxValues();
			_padding = new BoxValues();
			_rounding_method = UIElement.round_none;
			addEventListener(Event.RENDER, on_display_render, false, 0, true);
			addEventListener(Event.ADDED_TO_STAGE, on_added_to_stage, false, 0, true);
			
			_debug_rect_colour = Math.random() * 0xffffff;
		}
		
		// PUBLIC
		/**
		* Gets and sets the defined_width property.
		*/
		public function get defined_width():Number { return _defined_width }
		public function set defined_width(value:Number):void {
			if (value != _defined_width) {
				_defined_width = value;
				dispatch_definition_invalidated();
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
		public function set defined_height(value:Number):void {
			if (value != _defined_height) {
				_defined_height = value;
				dispatch_definition_invalidated();
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
		* Gets and sets the layout_width property.
		*/
		public function get layout_width():Number { return _layout_width }
		public function set layout_width(value:Number):void {
			if (value != _layout_width) {
				_layout_width = value;
				render_next = true;
			}
		}
		
		/**
		* Gets and sets the layout_height property.
		*/
		public function get layout_height():Number { return _layout_height }
		public function set layout_height(value:Number):void {
			if (value != _layout_height) {
				_layout_height = value;
				render_next = true;
			}
		}
		
		/**
		* Gets the margins property.
		*/
		public function get margins():BoxValues { return _margins }
		
		/**
		* Gets the padding property.
		*/
		public function get padding():BoxValues { return _padding }
		
		/**
		* Gets and sets the rounding_method property.
		*/
		public function get rounding_method():Function { return _rounding_method }
		public function set rounding_method(value:Function):void { _rounding_method = value }
		
		/**
		* Gets and sets the draw_width property.
		*/
		public function get draw_width():Number { return _layout_width - _margins.left - _margins.right }
		public function set draw_width(value:Number):void { layout_width = value + _margins.left + _margins.right }
		
		/**
		* Gets the draw_height property.
		*/
		public function get draw_height():Number { return _layout_height - _margins.top - _margins.bottom }
		public function set draw_height(value:Number):void { layout_height = value + _margins.top + _margins.bottom }
		
		/**
		* Gets the padded_width property.
		*/
		public function get padded_width():Number { return draw_width - _padding.left - _padding.right }
		public function set padded_width(value:Number):void { draw_width = value + _padding.left + _padding.right }
		
		/**
		* Gets the padded_height property.
		*/
		public function get padded_height():Number { return draw_height - _padding.top - _padding.bottom }
		public function set padded_height(value:Number):void { draw_height = value + _padding.top + _padding.bottom }
		
		/**
		* Gets the draw_offset property.
		*/
		public function get draw_offset():Point { return new Point(_margins.left, _margins.top) }
		
		/**
		* Gets the padded_offset property.
		*/
		public function get padded_offset():Point { return new Point(_margins.left + _padding.left, _margins.top + _padding.top) }
		
		/**
		* Gets and sets the render_next property.
		*/
		public function get render_next():Boolean { return _render_next }
		public function set render_next(value:Boolean):void {
			if (value != _render_next) {
				_render_next = value;
				if ((_render_next) && (stage != null)) stage.invalidate();
			}
		}
		
		/**
		* Renders if there is a pending render flag.
		*/
		public function render_if_pending():void {
			if (_render_next) {
				update();
				_render_next = false;
			}
		}
		
		/**
		* Performs no rounding.
		*/
		public static function round_none(value:Number):Number { return Math.round(value) }
		
		// PROTECTED
		/**
		* Called when the draw_width or draw_height are changed.
		*/
		protected function update():void {
			if (DEBUG) {
				graphics.clear();
				graphics.beginFill(_debug_rect_colour, .2);
				graphics.drawRect(draw_offset.x, draw_offset.y, draw_width, draw_height);
				graphics.beginFill(_debug_rect_colour, 1);
				graphics.drawRect(draw_offset.x, draw_offset.y, draw_width, draw_height);
				graphics.drawRect(draw_offset.x + 1, draw_offset.y + 1, draw_width - 2, draw_height - 2);
			}
			dispatchEvent(new UIElementEvent(UIElementEvent.UPDATED));
		}
		
		// PRIVATE
		/**
		* Handles the event indicating that a render is about to occur.  If the
		* _render_next property is set, the update() method is invoked.
		*/
		private function on_display_render(event:Event):void { render_if_pending() }
		
		/**
		* Forcibly updates when added to stage.
		*/
		private function on_added_to_stage(event:Event):void { update() }
		
		/**
		* Dispatches a UIElementEvent.DEFINITION_INVALIDATED event.
		*/
		private function dispatch_definition_invalidated():void { dispatchEvent(new UIElementEvent(UIElementEvent.DEFINITION_INVALIDATED)) }
	}
}