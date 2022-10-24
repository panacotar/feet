class Object
  def self.const_missing(c)
    warn "Missing constant #{c.inspect}!"
  end
end

Bobo
