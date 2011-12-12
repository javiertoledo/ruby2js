require "rubygems"
require 'ruby2js'
require 'test/unit'

class TheTest < Test::Unit::TestCase
  def test_operators
    Ruby2js::JSCoder::SUPPORTED_OPERATORS.each_char do |op|
      assert_equal "1#{op.to_s}1", Ruby2js::Translator.new("1#{op.to_s}1").to_js
    end
  end
  
  def test_function_call
    assert_equal "alert(\"hello world\")", Ruby2js::Translator.new("alert(\"hello world\")").to_js
  end
  
  def test_block
    assert_equal "var a,b;\na=1+1;\nb=a+2;", Ruby2js::Translator.new("a = 1+1\n b = a+2").to_js    
  end
  
  def test_array
    assert_equal '[1,2,3,4]', Ruby2js::Translator.new("[1,2,3,4]").to_js  
    assert_equal '["a","b","c"]', Ruby2js::Translator.new("%w(a b c)").to_js
  end
  
  def test_function
    assert_equal "var foo=function(bar){\n\tvar a;\n\treturn a=bar+1;\n}", Ruby2js::Translator.new("def foo(bar)\na=bar+1\nend").to_js
  end
end