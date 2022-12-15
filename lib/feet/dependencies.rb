class Object
  def self.const_missing(c)
    @const_missing_called ||= {}
    return nil if @const_missing_called[c]

    @const_missing_called[c] = true
    require Feet.to_snake_case(c.to_s)
    klass = Object.const_get(c)
    @const_missing_called[c] = false

    klass
  end
end
