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
	import com.warptube.lhasa.UIElement;
	import com.warptube.lhasa.events.UIElementEvent;
	
	import flash.display.DisplayObject;
	
	/**
	* UIContainer
	* A UIContainer is responsible for any children within it that subclass
	* UIElement and their positioning and sizing.
	*
	* @author Paul Coyle <paul.b.coyle@gmail.com>
	*/
	public class UIContainer extends UIElement {
		private var _size_to_content_width:Boolean;
		private var _size_to_content_height:Boolean;
		protected var _content_width:Number;
		protected var _content_height:Number;
		private var _horizontal_spacing:Number = 0;
		private var _vertical_spacing:Number = 0;
		
		public function UIContainer() {
			super();
			size_to_content_height = true;// Mimicks the HTML Box Model - containers grow to fill horizontally but compress to their content vertically
		}
		
		// PUBLIC
		/**
		* Modification of addChild to check for UIElement additions and to
		* update when they are added.
		*/
		override public function addChild(child:DisplayObject):DisplayObject {
			super.addChild(child);
			
			if (child is UIElement) {
				child.addEventListener(UIElementEvent.DEFINITION_INVALIDATED, on_ui_element_definition_invalidated, false, 0, true);
				// TODO: Figure out why this does some odd things and correct them so we don't update when many children are added
				render_next = true;
				//update();
			}
			
			return child;
		}
		
		/**
		* Modification of addChildAt to check for UIElement additions and to
		* update when they are added.
		*/
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject {
			super.addChildAt(child, index);
			
			if (child is UIElement) {
				child.addEventListener(UIElementEvent.DEFINITION_INVALIDATED, on_ui_element_definition_invalidated, false, 0, true);
				// TODO: Figure out why this does some odd things and correct them so we don't update when many children are added
				//render_next = true;
				update();
			}
			
			return child;
		}
		
		/**
		* Modification of removeChild to check for UIElement additions and to
		* update when they are removed.
		*/
		override public function removeChild(child:DisplayObject):DisplayObject {
			super.removeChild(child);
			
			if (child is UIElement) {
				child.removeEventListener(UIElementEvent.DEFINITION_INVALIDATED, on_ui_element_definition_invalidated);
				// TODO: Figure out why this does some odd things and correct them so we don't update when many children are added
				render_next = true;
				//update();
			}
			
			return child;
		}
		
		/**
		* Modification of removeChildAt to check for UIElement additions and to
		* update when they are removed.
		*/
		override public function removeChildAt(index:int):DisplayObject {
		  var child:DisplayObject = getChildAt(index);
		  
			super.removeChildAt(index);
			
			if (child is UIElement) {
				child.removeEventListener(UIElementEvent.DEFINITION_INVALIDATED, on_ui_element_definition_invalidated);
				// TODO: Figure out why this does some odd things and correct them so we don't update when many children are added
				render_next = true;
				//update();
			}
			
			return child;
		}
		
		/**
		* Gets and sets the size_to_content_width property.
		*/
		public function get size_to_content_width():Boolean { return _size_to_content_width }
		public function set size_to_content_width(value:Boolean):void {
			if (value != _size_to_content_width) {
				_size_to_content_width = defined_width_fixed = value;
				render_next = true;
			}
		}
		
		/**
		* Gets and sets the size_to_content_height property.
		*/
		public function get size_to_content_height():Boolean { return _size_to_content_height }
		public function set size_to_content_height(value:Boolean):void {
			if (value != _size_to_content_height) {
				_size_to_content_height = defined_height_fixed = value;
				render_next = true;
			}
		}
		
		/**
		* Gets the content_width property.
		*/
		public function get content_width():Number { return _content_width }
		
		/**
		* Gets the content_height property.
		*/
		public function get content_height():Number { return _content_height }
		
		/**
		* Gets and sets the horizontal_spacing property.
		*/
		public function get horizontal_spacing():Number { return _horizontal_spacing }
		public function set horizontal_spacing(value:Number):void {
			if (value != _horizontal_spacing) {
				_horizontal_spacing = value;
				render_next = true;
			}
		}
		
		/**
		* Gets and sets the vertical_spacing property.
		*/
		public function get vertical_spacing():Number { return _vertical_spacing }
		public function set vertical_spacing(value:Number):void {
			if (value != _vertical_spacing) {
				_vertical_spacing = value;
				render_next = true;
			}
		}
		
		// PROTECTED
		/**
		* Returns an array of all the children that subclass UIElement.
		*/
		protected function get_ui_element_children():Array {
			var output:Array = new Array();
			var c:uint = 0;
			var maxc:uint = numChildren;
			var child:DisplayObject;
			while (c < maxc) {
				child = getChildAt(c);
				if (child is UIElement) output.push(child);
				c += 1;
			}
			
			return output;
		}
		
		// PRIVATE
		/**
		* Handles layout updates by updating the layout.
		*/
		private function on_ui_element_definition_invalidated(event:UIElementEvent):void { update() }
	}
}