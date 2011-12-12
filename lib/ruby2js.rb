require 'ruby_parser'

module Ruby2js
  
  module JSCoder
    SUPPORTED_OPERATORS = "+-*/%"
    
    class UnsupportedLanguageConstructionException < Exception
    end
    
    class Scope
      def initialize
        @vars = []    
        @args = []
      end
      def add_arg(name)
        @args << name unless (@args+@vars).include?(name)
        name
      end
      def add_var(name)
        @vars << name unless (@args+@vars).include?(name)
        name
      end
      def to_s
        "var " + @vars.map { |e| e.to_s }.join(',') unless @vars.empty?
      end
    end
    
    def encode_js(the_code, scope = nil)
      case the_code[0]       
      when :lit,:lvar
        the_code[1].to_s
      when :str
        "\"#{the_code[1]}\""  
      when :array
        '['+the_code.slice(1..-1).map { |e| encode_js(e) }.join(',')+']'
      when :lasgn
        encode_assign(the_code,scope)
      when :block
        scope||=Scope.new
        the_block = the_code.slice(1..-1).map { |e| encode_js(e,scope) }
        ([scope.to_s] + the_block).compact.join(";\n")+';' 
      when :scope
        the_block = the_code[1].slice(1..-1).map { |e| encode_js(e,scope) }
        the_block[-1] = 'return '+the_block[-1]
        "\t"+([scope.to_s] + the_block).compact.join(";\n\t")+';'
      when :call
        encode_call(the_code)
      when :arglist
        the_code.slice(1..-1).map { |e| encode_js(e) }.join(',')  
      when :defn
        encode_function(the_code)
      else
        raise UnsupportedLanguageConstructionException.new("Unsupported language construction (#{the_code[0].to_s})")
      end       
    end
    
    def encode_assign(the_code,scope)
      k, var_name, expr = the_code
      scope.add_var(var_name)
      var_name.to_s+'='+encode_js(expr,scope)
    end
    
    def encode_call(call_code)
      k, receiver, method, arguments = call_code
      if SUPPORTED_OPERATORS.include?(method.to_s)
        encode_js(receiver)+method.to_s+encode_js(arguments)
      else
        ((receiver) ? encode_js(receiver)+'.' : '')+"#{method.to_s}(#{encode_js(arguments)})"
      end
    end
    
    def encode_function(fun_code)
      k,fname,args,body = fun_code
      scope = Scope.new
      args = args.slice(1..-1).map { |arg| scope.add_arg(arg).to_s }.join(',')
      "var #{fname.to_s}=function(#{args}){\n#{encode_js(body,scope)}\n}"
    end
  end
  
  class Translator
    include JSCoder
    
    def initialize(the_code)
      @the_code = RubyParser.new.parse(the_code)
    end
    
    def to_js
      encode_js(@the_code)
    end
    
    def to_s
      @the_code.to_s
    end     
  end                       
end
