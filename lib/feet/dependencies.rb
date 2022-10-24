class Object
  def self.const_missing(c)
    require_relative '../utils/namespace.rb'
    namesp = Namespace.new
    formatted_c = namesp.to_snake_case(c.to_s)
    Object.const_get(formatted_c)
  end
end