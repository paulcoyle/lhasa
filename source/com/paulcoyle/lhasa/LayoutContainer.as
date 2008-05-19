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
* HOLDERS BE LIABLE FOR ANY CL
* AIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR
*  OTHERWISE, ARISING
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
* OTHER DEALINGS IN THE SOFTWARE.
*/
package com.paulcoyle.lhasa {
	import com.paulcoyle.lhasa.events.LayoutElementEvent;
	import com.paulcoyle.lhasa.layout_delegates.ILayoutDelegate;
	
	import flash.display.DisplayObject;
	
	/**
	* LayoutContainer
	* A LayoutContainer is responsible for any children within it that subclass
	* LayoutElement and their positioning and sizing.
	*
	* @author Paul Coyle <paul.b.coyle@gmail.com>
	*/
	public class LayoutContainer extends LayoutElement {
		private var _size_to_content_width:Boolean;
		private var _size_to_content_height:Boolean;
		protected var _content_width:Number;
		protected var _content_height:Number;
		private var _horizontal_spacing:Number = 0;
		private var _vertical_spacing:Number = 0;
		private var _layout_delegate:ILayoutDelegate;
		
		public function LayoutContainer(layout_delegate:ILayoutDelegate) {
			super();
			_layout_delegate = layout_delegate;
		}
		
		// PUBLIC
		/**
		* Modification of addChild to check for LayoutElement additions and to
		* update when they are added.
		*/
		override public function addChild(child:DisplayObject):DisplayObject {
			super.addChild(child);
			
			if (child is LayoutElement) {
				child.addEventListener(LayoutElementEvent.DEFINITION_INVALIDATED,
				  on_layout_element_definition_invalidated, false, 0, true);
				
				update_next();
			}
			
			return child;
		}
		
		/**
		* Modification of addChildAt to check for LayoutElement additions and to
		* update when they are added.
		*/
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject {
			super.addChildAt(child, index);
			
			if (child is LayoutElement) {
				child.addEventListener(LayoutElementEvent.DEFINITION_INVALIDATED,
				  on_layout_element_definition_invalidated, false, 0, true);
				
				update_next();
			}
			
			return child;
		}
		
		/**
		* Modification of removeChild to check for LayoutElement additions and to
		* update when they are removed.
		*/
		override public function removeChild(child:DisplayObject):DisplayObject {
			super.removeChild(child);
			
			if (child is LayoutElement) {
				child.removeEventListener(LayoutElementEvent.DEFINITION_INVALIDATED,
				  on_layout_element_definition_invalidated);
				
				update_next();
			}
			
			return child;
		}
		
		/**
		* Modification of removeChildAt to check for LayoutElement additions and to
		* update when they are removed.
		*/
		override public function removeChildAt(index:int):DisplayObject {
		  var child:DisplayObject = getChildAt(index);
		  
			super.removeChildAt(index);
			
			if (child is LayoutElement) {
				child.removeEventListener(LayoutElementEvent.DEFINITION_INVALIDATED,
				  on_layout_element_definition_invalidated);
				
				update_next();
			}
			
			return child;
		}
		
		/**
		* Gets and sets the layout_delegate property.
		*/
		public function get layout_delegate():ILayoutDelegate { return _layout_delegate }
		public function set layout_delegate(value:ILayoutDelegate):void {
		  if (value != _layout_delegate) {
		    _layout_delegate = value;
		    update();
	    }
		}
		
		/**
		* Gets and sets the size_to_content_width property.
		*/
		public function get size_to_content_width():Boolean { return _size_to_content_width }
		public function set size_to_content_width(value:Boolean):void {
			if (value != _size_to_content_width) {
				_size_to_content_width = defined_width_fixed = value;
				update_next();
			}
		}
		
		/**
		* Gets and sets the size_to_content_height property.
		*/
		public function get size_to_content_height():Boolean { return _size_to_content_height }
		public function set size_to_content_height(value:Boolean):void {
			if (value != _size_to_content_height) {
				_size_to_content_height = defined_height_fixed = value;
				update_next();
			}
		}
		
		/**
		* Gets the content_width property.
		*/
		public function get content_width():Number { return _content_width }
		public function set content_width(value:Number):void { _content_width = value }
		
		/**
		* Gets the content_height property.
		*/
		public function get content_height():Number { return _content_height }
		public function set content_height(value:Number):void { _content_height = value }
		
		/**
		* Gets and sets the horizontal_spacing property.
		*/
		public function get horizontal_spacing():Number { return _horizontal_spacing }
		public function set horizontal_spacing(value:Number):void {
			if (value != _horizontal_spacing) {
				_horizontal_spacing = value;
				update_next();
			}
		}
		
		/**
		* Gets and sets the vertical_spacing property.
		*/
		public function get vertical_spacing():Number { return _vertical_spacing }
		public function set vertical_spacing(value:Number):void {
			if (value != _vertical_spacing) {
				_vertical_spacing = value;
				update_next();
			}
		}
		
		/**
		* Returns an array of all the children that subclass LayoutElement.
		*/
		public function get layout_element_children():Array {
			var output:Array = new Array();
			var c:uint = 0;
			var maxc:uint = numChildren;
			var child:DisplayObject;
			while (c < maxc) {
				child = getChildAt(c);
				if (child is LayoutElement) output.push(child);
				c += 1;
			}
			
			return output;
		}
		
		// PROTECTED
		/**
		* Updates this element then invokes the layout delegate to operate on the
		* children.
		*/
		override protected function update():void {
		  super.update();
		  _layout_delegate.perform_layout(this);
		}
		
		// PRIVATE
		/**
		* Handles layout updates by updating the layout.
		*/
		private function on_layout_element_definition_invalidated(event:LayoutElementEvent):void { update_next() }
	}
}