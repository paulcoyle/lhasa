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
  import com.paulcoyle.lhasa.events.LayoutElementEvent;
  import com.paulcoyle.lhasa.layout_delegates.ILayoutDelegate;
  
  import flash.display.DisplayObject;
  
  /**
  * A LayoutContainer is responsible for any children within it that subclass
  * LayoutElement and their positioning and sizing.
  *
  * <p>LayoutContainers delegate the actual task of performing the layout
  * calculations to their <code>layoutDelegate</code>.  Layout delegates can
  * be changed at run-time.</p>
  *
  * @author Paul Coyle &lt;paul.b.coyle&64;gmail.com&gt;
  */
  public class LayoutContainer extends LayoutElement {
    private var _sizeToContentWidth:Boolean;
    private var _sizeToContentHeight:Boolean;
    private var _contentWidth:Number;
    private var _contentHeight:Number;
    private var _horizontalSpacing:Number = 0;
    private var _verticalSpacing:Number = 0;
    private var _layoutDelegate:ILayoutDelegate;
    
    /**
    * Creates a new LayoutContainer.
    * 
    * @param layoutDelegate An instance of a class that implements the
    * <code>ILayoutDelegate</code> interface.
    * 
    * @see com.paulcoyle.lhasa.layoutDelegates.ILayoutDelegate ILayoutDelegate
    */
    public function LayoutContainer(layoutDelegate:ILayoutDelegate) {
      super();
      _layoutDelegate = layoutDelegate;
    }
    
    // PUBLIC
    /**
    * Modification of addChild to check for LayoutElement additions and to
    * update when they are added.
    * 
    * @private
    */
    override public function addChild(child:DisplayObject):DisplayObject {
      super.addChild(child);
      
      if (child is LayoutElement) {
        child.addEventListener(LayoutElementEvent.INVALIDATED,
          onLayoutDefinitionInvalidated, false, 0, true);
        
        updateNext();
      }
      
      return child;
    }
    
    /**
    * Modification of addChildAt to check for LayoutElement additions and to
    * update when they are added.
    * 
    * @private
    */
    override public function addChildAt(child:DisplayObject, index:int):DisplayObject {
      super.addChildAt(child, index);
      
      if (child is LayoutElement) {
        child.addEventListener(LayoutElementEvent.INVALIDATED,
          onLayoutDefinitionInvalidated, false, 0, true);
        
        updateNext();
      }
      
      return child;
    }
    
    /**
    * Modification of removeChild to check for LayoutElement additions and to
    * update when they are removed.
    * 
    * @private
    */
    override public function removeChild(child:DisplayObject):DisplayObject {
      super.removeChild(child);
      
      if (child is LayoutElement) {
        child.removeEventListener(LayoutElementEvent.INVALIDATED,
          onLayoutDefinitionInvalidated);
        
        updateNext();
      }
      
      return child;
    }
    
    /**
    * Modification of removeChildAt to check for LayoutElement additions and to
    * update when they are removed.
    * 
    * @private
    */
    override public function removeChildAt(index:int):DisplayObject {
      var child:DisplayObject = getChildAt(index);
      
      super.removeChildAt(index);
      
      if (child is LayoutElement) {
        child.removeEventListener(LayoutElementEvent.INVALIDATED,
          onLayoutDefinitionInvalidated);
        
        updateNext();
      }
      
      return child;
    }
    
    // TODO: Override the rest of the child manipulation methods that cause
    //       reordering or any change in the display order of children.
    
    /**
    * The layout delegate responsible for this container.
    * 
    * @see com.paulcoyle.lhasa.layoutDelegates.ILayoutDelegate ILayoutDelegate
    * @see com.paulcoyle.lhasa.layoutDelegates.FreeLayoutDelegate FreeLayoutDelegate
    * @see com.paulcoyle.lhasa.layoutDelegates.HorizontalLayoutDelegate HorizontalLayoutDelegate
    * @see com.paulcoyle.lhasa.layoutDelegates.VerticalLayoutDelegate VerticalLayoutDelegate
    */
    public function get layoutDelegate():ILayoutDelegate { return _layoutDelegate }
    /**
    * @private
    */
    public function set layoutDelegate(value:ILayoutDelegate):void {
      if (value != _layoutDelegate) {
        _layoutDelegate = value;
        update();
      }
    }
    
    /**
    * Indicates whether or not this container should resize itself to match the
    * width of its contained elements.
    *
    * @default false
    */
    public function get sizeToContentWidth():Boolean {
      return _sizeToContentWidth;
    }
    /**
    * @private
    */
    public function set sizeToContentWidth(value:Boolean):void {
      if (value != _sizeToContentWidth) {
        _sizeToContentWidth = definedWidthFixed = value;
        updateNext();
      }
    }
    
    /**
    * Indicates whether or not this container should resize itself to match the
    * height of its contained elements.
    *
    * @default false
    */
    public function get sizeToContentHeight():Boolean {
      return _sizeToContentHeight;
    }
    /**
    * @private
    */
    public function set sizeToContentHeight(value:Boolean):void {
      if (value != _sizeToContentHeight) {
        _sizeToContentHeight = definedHeightFixed = value;
        updateNext();
      }
    }
    
    /**
    * The calculated width of the contained elements.
    */
    public function get contentWidth():Number {
      return _contentWidth;
    }
    /**
    * @private
    */
    public function set contentWidth(value:Number):void {
      _contentWidth = value;
    }
    
    /**
    * The calculated height of the contained elements.
    */
    public function get contentHeight():Number {
      return _contentHeight;
    }
    /**
    * @private
    */
    public function set contentHeight(value:Number):void {
      _contentHeight = value;
    }
    
    /**
    * The amount of space in pixels to be placed horizontally between elements.
    *
    * @default 0
    */
    public function get horizontalSpacing():Number {
      return _horizontalSpacing;
    }
    /**
    * @private
    */
    public function set horizontalSpacing(value:Number):void {
      if (value != _horizontalSpacing) {
        _horizontalSpacing = value;
        updateNext();
      }
    }
    
    /**
    * The amount of space in pixels to be placed vertically between elements.
    *
    * @default 0
    */
    public function get verticalSpacing():Number { return _verticalSpacing }
    /**
    * @private
    */
    public function set verticalSpacing(value:Number):void {
      if (value != _verticalSpacing) {
        _verticalSpacing = value;
        updateNext();
      }
    }
    
    /**
    * An array of all the children in this container that subclass
    * LayoutElement.
    * 
    * @see com.paulcoyle.lhasa.LayoutElement LayoutElement
    */
    public function get layoutChildren():Array {
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
      _layoutDelegate.performLayout(this);
    }
    
    // PRIVATE
    /**
    * Handles layout updates by updating the layout.
    */
    private function onLayoutDefinitionInvalidated(event:LayoutElementEvent):void {
      updateNext();
    }
  }
}