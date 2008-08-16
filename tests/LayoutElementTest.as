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
    * @param test_method Name of the method to test.
    */
    public function LayoutElementTest(test_method:String = null) {
      super(test_method);
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
    * Tests the default values for defined_width/height and their fixed
    * counterparts.
    */
    public function test_defined_width_height_defaults():void {
      assertEquals('Element defined_width is 1', _element.defined_width, 1);
      assertFalse('Element defined_width_fixed is false',
        _element.defined_width_fixed);
      
      assertEquals('Element defined_height is 1', _element.defined_height, 1);
      assertFalse('Element defined_height_fixed is false',
        _element.defined_height_fixed);
    }
    
    /**
    * Tests the defined_width property's textual parsing.
    */
    public function test_defined_width_property():void {
      // Percentages
      _element.defined_width = '12.34%';
      assertEquals('Element defined_width is 0.1234',
        _element.defined_width, 0.1234);
      assertFalse('Element defined_width_fixed is false',
        _element.defined_width_fixed);
      
      _element.defined_width = '100%';
      assertEquals('Element defined_width is 1',
        _element.defined_width, 1);
      assertFalse('Element defined_width_fixed is false',
        _element.defined_width_fixed);
      
      // Absolute values
      _element.defined_width = '56.78px';
      assertEquals('Element defined_width is 56.78',
        _element.defined_width, 56.78);
      assertTrue('Element defined_width_fixed is true',
        _element.defined_width_fixed);
      
      _element.defined_width = '1978px';
      assertEquals('Element defined_width is 1978',
        _element.defined_width, 1978);
      assertTrue('Element defined_width_fixed is true',
        _element.defined_width_fixed);
    }
    
    /**
    * Tests the defined_height property's textual parsing.
    */
    public function test_defined_height_property():void {
      _element.defined_height = '12.34%';
      assertEquals('Element defined_height is 0.1234', _element.defined_height, 0.1234);
      assertFalse('Element defined_height_fixed is false', _element.defined_height_fixed);
      
      _element.defined_height = '100%';
      assertEquals('Element defined_height is 1', _element.defined_height, 1);
      assertFalse('Element defined_height_fixed is false', _element.defined_height_fixed);
      
      _element.defined_height = '56.78px';
      assertEquals('Element defined_height is 56.78', _element.defined_height, 56.78);
      assertTrue('Element defined_height_fixed is true', _element.defined_height_fixed);
      
      _element.defined_height = '1978px';
      assertEquals('Element defined_height is 1978', _element.defined_height, 1978);
      assertTrue('Element defined_height_fixed is true', _element.defined_height_fixed);
    }
  }
}