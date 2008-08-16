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
package {
  import asunit.framework.TestCase;
  
  import com.paulcoyle.lhasa.LayoutContainer;
  import com.paulcoyle.lhasa.LayoutElement;
  import com.paulcoyle.lhasa.layout_delegates.FreeLayoutDelegate;
  import com.paulcoyle.lhasa.layout_delegates.VerticalLayoutDelegate;
  
  /**
  * Unit tests for the LayoutContainer class.
  *
  * @author Paul Coyle &lt;paul.b.coyle@gmail.com&gt;
  */
  public class LayoutContainerTest extends TestCase {
    private var _container:LayoutContainer;
    
    /**
    * Constructor
    */
    public function LayoutContainerTest(test_method:String = null) {
      super(test_method);
    }
    
    /**
    * Sets up the test.
    */
    override protected function setUp():void {
      _container = new LayoutContainer(new FreeLayoutDelegate());;
    }
    
    /**
    * Cleans up after the test.
    */
    override protected function tearDown():void {
      while (_container.numChildren > 0) _container.removeChildAt(0);
      _container = null;
    }
    
    /**
    * Tests the constructor setting the correct layout delegate and having the
    * delegator set afterwards.
    */
    public function test_layout_delegate_setting():void {
      assertTrue('Initial layout delegate is a FreeLayoutDelegate',
        _container.layout_delegate is FreeLayoutDelegate);
      
      _container.layout_delegate = new VerticalLayoutDelegate();
      assertTrue('Layout delegate is a VerticalLayoutDelegate',
        _container.layout_delegate is VerticalLayoutDelegate);
    }
    
    /**
    * Tests that the array returned by layout_element_children has matching
    * indexes for the order added through the usual display methods.
    */
    public function test_layout_element_children_property():void {
      var first_child:LayoutElement = new LayoutElement();
      var second_child:LayoutElement = new LayoutElement();
      
      _container.addChild(first_child);
      _container.addChild(second_child);
      
      var children:Array = _container.layout_element_children;
      assertSame('Element at index 0 should be first child',
        children[0], first_child);
      assertSame('Element at index 1 should be second child',
        children[1], second_child);
    }
  }
}