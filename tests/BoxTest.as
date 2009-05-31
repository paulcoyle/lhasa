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
package {
  import asunit.framework.TestCase;
  
  import com.paulcoyle.lhasa.types.Box;
  
  /**
  * Unit tests for the Box class.
  *
  * @author Paul Coyle &lt;paul.b.coyle@gmail.com&gt;
  */
  public class BoxTest extends TestCase {
    private var _box:Box;
    
    /**
    * Constructor.
    * 
    * @param testMethod Name of the method to test.
    */
    public function BoxTest(testMethod:String = null) {
      super(testMethod);
    }
    
    /**
    * Prepares for a test to be run.
    */
    override protected function setUp():void {
      _box = new Box();
    }
    
    /**
    * Cleans up after the test is run.
    */
    override protected function tearDown():void {
      _box = null;
    }
    
    /**
    * Tests to verify that the default values for the box sides are all 0.
    */
    public function testDefaultValues():void {
      assertEquals('Top default value is 0', _box.top, 0);
      assertEquals('Right default value is 0', _box.right, 0);
      assertEquals('Bottom default value is 0', _box.bottom, 0);
      assertEquals('Left default value is 0', _box.left, 0);
    }
    
    /**
    * Tests the getting and setting of the horizontal property.
    */
    public function testHorizontalProperty():void {
      _box.left = 1;
      _box.right = 2;
      assertEquals('Horizontal property is 3', _box.horizontal, 3);
      
      _box.horizontal = 42;
      assertEquals('Left is 42', _box.left, 42);
      assertEquals('Right is 42', _box.right, 42);
    }
    
    /**
    * Tests the getting and setting of the vertical property.
    */
    public function testVerticalProperty():void {
      _box.top = 1;
      _box.bottom = 2;
      assertEquals('Vertical property is 3', _box.vertical, 3);
      
      _box.vertical = 42;
      assertEquals('Top is 42', _box.top, 42);
      assertEquals('Bottom is 42', _box.bottom, 42);
    }
    
    /**
    * Tests the setting of the all property.
    */
    public function testAllProperty():void {
      _box.all = 42;
      assertEquals('Top is 42', _box.top, 42);
      assertEquals('Right is 42', _box.right, 42);
      assertEquals('Bottom is 42', _box.bottom, 42);
      assertEquals('Left is 42', _box.left, 42);
    }
  }
}