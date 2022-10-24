class Object
  def self.const_missing(c)
    require_relative '../utils/namespace.rb'
    namesp = Namespace.new
    namesp.to_snake_case(c.to_s)
    Object.const_get(c)
  end
end