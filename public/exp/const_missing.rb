class Object
  def self.const_missing(c)
    # STDERR.puts "Missing constant #{c.inspect}!"
    require "./bobo.rb"
    Bobo
  end
end

Bobo.new.print_bobo
