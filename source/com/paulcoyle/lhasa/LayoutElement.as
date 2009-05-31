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
  import flash.geom.Rectangle;

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
    private var _definedWidth:Number = 1;
    private var _definedHeight:Number = 1;
    private var _definedWidthFixed:Boolean;
    private var _definedHeightFixed:Boolean;
    
    /*
    * These values define alignment and when set will invalidate the
    * element just like the defined_* properties will.
    */
    private var _alignHorizontal:uint;
    private var _alignVertical:uint;
    
    /*
    * These values represent how the parent or external object is
    * instructing the object to be drawn.  This usually happnes in the
    * update method of containers where layout calculations are done.
    */
    private var _totalWidth:Number = 0;
    private var _totalHeight:Number = 0;
    
    /*
    * These object contain values for the four sides of the element and
    * represent the margin and padding.  When the total(Width|Height) is
    * set, the margins are subtracted and set as the inner(Width|Height).
    * Similarily, the padded(Width|Height) is the inner(Width|Height)
    * minus the padding values.
    */
    private var _margin:Box;
    private var _padding:Box;
    
    /*
    * Indicates whether or not the element should update when the next
    * render event is received from the stage.
    */
    private var _updateNext:Boolean;
    
    /*
    * Some values for debugging.
    */
    private static const DEBUG:Boolean = false;
    private var _debugRectColour:uint;
    
    /**
    * Creates a new LayoutElement.
    */
    public function LayoutElement() {
      _margin = new Box();
      _margin.addEventListener(Event.CHANGE, onMarginChange, false, 0, true);
      _padding = new Box();
      _padding.addEventListener(Event.CHANGE, onPaddingChange, false, 0, true);
      
      _debugRectColour = Math.random() * 0xffffff;
      
      addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
      addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, false, 0, true);
      
      updateNext();
    }
    
    // PUBLIC
    /**
    * The declared width that this element should be.  Works in concert with
    * the <code>definedWidthFixed</code> property.
    *
    * <p>This property can be set in two separate ways: numerically and
    * textually.  Setting the value numerically will simply set the value and
    * dispatch an event.  By passing a string to this property both the values
    * for <code>definedWidth</code> and <code>definedWidthFixed</code> can
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
    * element.definedWidth = '34.5px';
    * trace(element.definedWidth, element.definedWidthFixed);// (34.5 true)
    * 
    * element.definedWidth = '55.123%';
    * trace(element.definedWidth, element.definedWidthFixed);// (0.55123 false)
    * </pre>
    *   It is important to note that non-fixed values are converted to
    *   scalars.
    * </p>
    *
    * @default 1
    *
    * @see #definedWidthFixed
    */
    public function get definedWidth():Number { return _definedWidth }
    /**
    * @private
    */
    public function set definedWidth(value:*):void {
      if (value is String) {
        var values:Object = parseNumericString(value as String);
        definedWidth = values.value;
        definedWidthFixed = values.fixed;
        return;
      }
      else if (value is Number) {
        value = value as Number;
        if (value != _definedWidth) {
          _definedWidth = value;
          dispatchLayoutInvalidated();
        }
      }
    }
    
    /**
    * Indicates whether or not the value for <code>definedWidth</code> should
    * be treated as a fixed or variable value.
    *
    * @default false
    *
    * @see #definedWidth
    */
    public function get definedWidthFixed():Boolean { return _definedWidthFixed }
    /**
    * @private
    */
    public function set definedWidthFixed(value:Boolean):void {
      if (value != _definedWidthFixed) {
        _definedWidthFixed = value;
        dispatchLayoutInvalidated();
      }
    }
    
    /**
    * The declared width that this element should be.  Works in concert with
    * the <code>definedWidthFixed</code> property.  For details on how to set
    * values textually see the definition for <code><a href="#definedWidth">definedWidth</a></code>.
    *
    * @default 1
    *
    * @see #definedHeightFixed
    */
    public function get definedHeight():Number { return _definedHeight }
    /**
    * @private
    */
    public function set definedHeight(value:*):void {
      if (value is String) {
        var values:Object = parseNumericString(value as String);
        definedHeight = values.value;
        definedHeightFixed = values.fixed;
        return;
      }
      else if (value is Number) {
        value = value as Number;
        if (value != _definedHeight) {
          _definedHeight = value;
          dispatchLayoutInvalidated();
        }
      }
    }
    
    /**
    * Indicates whether or not the value for <code>definedHeight</code> should
    * be treated as a fixed or variable value.
    *
    * @default false
    *
    * @see #definedHeight
    */
    public function get definedHeightFixed():Boolean {
      return _definedHeightFixed;
    }
    /**
    * @private
    */
    public function set definedHeightFixed(value:Boolean):void {
      if (value != _definedHeightFixed) {
        _definedHeightFixed = value;
        dispatchLayoutInvalidated();
      }
    }
    
    /**
    * The horizontal alignment for the element.
    *
    * @default 0 (MIDDLE)
    *
    * @see com.paulcoyle.lhasa.types.Align
    */
    public function get alignHorizontal():uint { return _alignHorizontal }
    /**
    * @private
    */
    public function set alignHorizontal(value:uint):void {
      if (value != _alignHorizontal) {
        _alignHorizontal = value;
        dispatchLayoutInvalidated();
      }
    }
    
    /**
    * The vertical alignment for the element.
    *
    * @default 0 (MIDDLE)
    *
    * @see com.paulcoyle.lhasa.types.Align
    */
    public function get alignVertical():uint { return _alignVertical }
    /**
    * @private
    */
    public function set alignVertical(value:uint):void {
      if (value != _alignVertical) {
        _alignVertical = value;
        dispatchLayoutInvalidated();
      }
    }
    
    /**
    * The total width assigned <em>to</em> the element.  This is usually set by
    * the element container's layout delegate.  This values affects the values
    * for: <code>innerOffset</code>, <code>innerWidth</code>,
    * <code>paddedOffset</code> and <code>paddedWidth</code>.
    *
    * @default 0
    *
    * @see #innerOffset
    * @see #innerWidth
    * @see #paddedOffset
    * @see #paddedWidth
    */
    public function get totalWidth():Number { return _totalWidth }
    /**
    * @private
    */
    public function set totalWidth(value:Number):void {
      if (value != _totalWidth) {
        _totalWidth = value;
        updateNext();
      }
    }
    
    /**
    * The total height assigned <em>to</em> the element.  This is usually set by
    * the element container's layout delegate.  This values affects the values
    * for: <code>innerOffset</code>, <code>innerHeight</code>,
    * <code>paddedHeight</code> and <code>paddedHeight</code>.
    *
    * @default 0
    *
    * @see #innerOffset
    * @see #innerHeight
    * @see #paddedOffset
    * @see #paddedHeight
    */
    public function get totalHeight():Number { return _totalHeight }
    /**
    * @private
    */
    public function set totalHeight(value:Number):void {
      if (value != _totalHeight) {
        _totalHeight = value;
        updateNext();
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
    * Defines the local coordinates that represent the top left corner of the
    * element where the inner area (without margin) begins.
    */
    public function get innerOffset():Point {
      return new Point(_margin.left, _margin.top);
    }
    
    /**
    * Defines the width of the element without margins.
    */
    public function get innerWidth():Number {
      return _totalWidth - _margin.left - _margin.right;
    }
    /**
    * @private
    */
    public function set innerWidth(value:Number):void {
      totalWidth = value + _margin.left + _margin.right;
    }
    
    /**
    * Defines the height of the element without margins.
    */
    public function get innerHeight():Number {
      return _totalHeight - _margin.top - _margin.bottom;
    }
    /**
    * @private
    */
    public function set innerHeight(value:Number):void {
      totalHeight = value + _margin.top + _margin.bottom;
    }
    
    /**
    * Returns a Rectangle representing the inner area.
    */
    public function get innerRect():Rectangle {
      var offset:Point = innerOffset;
      return new Rectangle(offset.x, offset.y, innerWidth, innerHeight);
    }
    
    /**
    * Defines the local coordinates that represent the top left corner of the
    * element where the padded area (without margin and with padding) begins.
    */
    public function get paddedOffset():Point {
      return new Point(_margin.left + _padding.left, _margin.top + _padding.top);
    }
    
    /**
    * Defines the width of the element without margins and with padding.
    */
    public function get paddedWidth():Number {
      return innerWidth - _padding.left - _padding.right;
    }
    /**
    * @private
    */
    public function set paddedWidth(value:Number):void {
      innerWidth = value + _padding.left + _padding.right;
    }
    
    /**
    * Defines the height of the element without margins and with padding.
    */
    public function get paddedHeight():Number {
      return innerHeight - _padding.top - _padding.bottom;
    }
    /**
    * @private
    */
    public function set paddedHeight(value:Number):void {
      innerHeight = value + _padding.top + _padding.bottom;
    }
    
    /**
    * Returns a Rectangle representing the padded area.
    */
    public function get paddedRect():Rectangle {
      var offset:Point = paddedOffset;
      return new Rectangle(offset.x, offset.y, paddedWidth, paddedHeight);
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
    protected function updateNext():void { _updateNext = true }
    
    /**
    * Called after the stage has been invalidated due to a call to
    * <code>updateNext()</code> which indicates that a value that could
    * warrant a graphical update has changed.
    *
    * @see #updateNext()
    */
    protected function update():void {
      if (DEBUG) {
        graphics.clear();
        graphics.beginFill(_debugRectColour, .2);
        graphics.drawRect(innerOffset.x, innerOffset.y, innerWidth, innerHeight);
        graphics.beginFill(_debugRectColour, 1);
        graphics.drawRect(innerOffset.x, innerOffset.y, innerWidth, innerHeight);
        graphics.drawRect(innerOffset.x + 1, innerOffset.y + 1, innerWidth - 2,
          innerHeight - 2);
      }
      
      dispatchEvent(new LayoutElementEvent(LayoutElementEvent.UPDATED));
    }
    
    /**
    * Updates if there is a pending update flag set by <code>update()</code>.
    *
    * @see #update()
    * @see #updateNext()
    */
    protected function updateIfPending():void {
      if (_updateNext) {
        _updateNext = false;
        update();
      }
    }
    
    /**
    * Dispatches a LayoutElementEvent.INVALIDATED event.
    */
    protected function dispatchLayoutInvalidated():void {
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
    private function parseNumericString(value:String):Object {
      var parseExpression:RegExp = /^([0-9]{1,})(\.[0-9]{0,})?(%|px)$/;
      var parseResult:Array = value.match(parseExpression);
      
      if (parseResult != null) {
        var isFixed:Boolean = (parseResult[3] == 'px');
        var parsedValue:Number = parseFloat(value);
        return {value: (isFixed) ? parsedValue : parsedValue / 100,
          fixed: isFixed};
      }
      else return {value:parseFloat(value), fixed:true};// Do our best
    }
    
    /**
    * Handles changes on the margin Box.  Invalidates the element.
    */
    private function onMarginChange(event:Event):void {
      dispatchLayoutInvalidated();
    }
    
    /**
    * Handles changes on the padding Box.  Invalidates the element.
    */
    private function onPaddingChange(event:Event):void {
      dispatchLayoutInvalidated();
    }
    
    /**
    * Handles the element being added to the stage and performs an update if one
    * is pending.  The element will now listen for enter frame events.
    */
    private function onAddedToStage(event:Event):void {
      addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
      updateIfPending();
    }
    
    /**
    * Handles the element being removed from the stage.  We quit listening for
    * enter frame events since they will not be received and are not needed.
    */
    private function onRemovedFromStage(event:Event):void {
      removeEventListener(Event.ENTER_FRAME, onEnterFrame);
    }
    
    /**
    * Handles an enter frame event and performs and update if one is pending.
    */
    private function onEnterFrame(event:Event):void {
      updateIfPending();
    }
  }
}
