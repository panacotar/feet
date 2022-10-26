class Object
  def self.const_missing(c)
    # STDERR.puts "Missing constant #{c.inspect}!"
    require_relative "./bobo.rb"
    Bobo
  end
end

Bobo.new.print_bobo
