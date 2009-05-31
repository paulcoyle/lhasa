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
  
  import com.paulcoyle.lhasa.LayoutElement;
  
  /**
  * Unit tests for the LayoutElement class.
  *
  * @author Paul Coyle &lt;paul.b.coyle@gmail.com&gt;
  */
  public class LayoutElementTest extends TestCase {
    private var _element:LayoutElement;
    
    /**
    * Constructor.
    * 
    * @param testMethod Name of the method to test.
    */
    public function LayoutElementTest(testMethod:String = null) {
      super(testMethod);
    }
    
    /**
    * Sets up the test.
    */
    override protected function setUp():void {
      _element = new LayoutElement();
    }
    
    /**
    * Cleans up after the test.
    */
    override protected function tearDown():void {
      _element = null;
    }
    
    /**
    * Tests the default values for definedWidth/height and their fixed
    * counterparts.
    */
    public function testDefinedWidthHeightDefaults():void {
      assertEquals('Element definedWidth is 1', _element.definedWidth, 1);
      assertFalse('Element definedWidthFixed is false',
        _element.definedWidthFixed);
      
      assertEquals('Element definedHeight is 1', _element.definedHeight, 1);
      assertFalse('Element definedHeightFixed is false',
        _element.definedHeightFixed);
    }
    
    /**
    * Tests the definedWidth property's textual parsing.
    */
    public function testDefinedWidthProperty():void {
      // Percentages
      _element.definedWidth = '12.34%';
      assertEquals('Element definedWidth is 0.1234',
        _element.definedWidth, 0.1234);
      assertFalse('Element definedWidthFixed is false',
        _element.definedWidthFixed);
      
      _element.definedWidth = '100%';
      assertEquals('Element definedWidth is 1',
        _element.definedWidth, 1);
      assertFalse('Element definedWidthFixed is false',
        _element.definedWidthFixed);
      
      // Absolute values
      _element.definedWidth = '56.78px';
      assertEquals('Element definedWidth is 56.78',
        _element.definedWidth, 56.78);
      assertTrue('Element definedWidthFixed is true',
        _element.definedWidthFixed);
      
      _element.definedWidth = '1978px';
      assertEquals('Element definedWidth is 1978',
        _element.definedWidth, 1978);
      assertTrue('Element definedWidthFixed is true',
        _element.definedWidthFixed);
    }
    
    /**
    * Tests the definedHeight property's textual parsing.
    */
    public function testDefinedHeightProperty():void {
      _element.definedHeight = '12.34%';
      assertEquals('Element definedHeight is 0.1234',
        _element.definedHeight, 0.1234);
      assertFalse('Element definedHeightFixed is false',
        _element.definedHeightFixed);
      
      _element.definedHeight = '100%';
      assertEquals('Element definedHeight is 1',
        _element.definedHeight, 1);
      assertFalse('Element definedHeightFixed is false',
        _element.definedHeightFixed);
      
      _element.definedHeight = '56.78px';
      assertEquals('Element definedHeight is 56.78',
        _element.definedHeight, 56.78);
      assertTrue('Element definedHeightFixed is true',
        _element.definedHeightFixed);
      
      _element.definedHeight = '1978px';
      assertEquals('Element definedHeight is 1978',
        _element.definedHeight, 1978);
      assertTrue('Element definedHeightFixed is true',
        _element.definedHeightFixed);
    }
  }
}