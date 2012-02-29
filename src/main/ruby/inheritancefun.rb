require "json"
require "PStore"

class Class
  alias_method :old_new,  :new
  def new(*args)
    result = old_new(*args)
    puts "created #{self}"
    return result
  end
  def self.method_added(method)
    puts method.to_s()
  end
end

class Odd
  odd="bob"
  
  def bob()
    puts "bob"
  end
end

o = Odd.new

module Mixin
  
  def hello()
    puts "hellow world #{self}"
  end
  
  def bob()
    puts "override bob"
  end
end

module MixinTwo
  
  def bob()
    puts "last override bob"
    getters = self.public_methods(false).reject { |m| m =~ /=$/ }
    getters.each do  |m|
      if(m.to_s() != "bob")
        puts self.send(m)  
      end
    end  
  end
  
  ## load up a directory and then add a mixin based on type?

end



def intercept obj
  meth = obj.methods - %w{__send__ __id__}
  klass, name = class << obj; self; end, obj.class.name
  meth.each do |m|
    klass.module_eval %[
    def #{m} *a,&b
      puts 'in #{name}##{m}'
      super
      puts 'out #{name}##{m}'
    end]
  end
  obj
end


## good way to unit test
#intercept o
o.extend(Mixin)
o.extend(MixinTwo)
o.hello()
o.bob()

### End fun here, start pstore


class SuggestionBox
  def initialize(filename="suggestions.pstore")
    @filename = filename
  end
  def store
    @store ||= PStore.new(@filename)
  end
  def add_reply(reply)
    initialize()
    store.transaction do
    store[:replies] ||= []
    store[:replies] << reply
    end
  end
  def replies(readonly=true)
    store.transaction do
    store[:replies]
    end
  end
  def clear_replies
    store.transaction do
    store[:replies] = []
    end
  end
end

box = SuggestionBox.new
box.add_reply(:question1 => "question1",
              :question2 => "question2")


## start json testing
hash = { "Foo" => [Math::PI, 1, "kittens"],
"Bar" => [false, nil, true], "Baz" => { "X" => "Y" } }
puts hash.to_json
hash = JSON.parse(hash.to_json)
puts hash["Foo"]

