class Object
  def self.const_missing(c)
    # STDERR.puts "Missing constant #{c.inspect}!"
    require_relative "./bobo.rb"
    Bobo
  end
end

Bobo.new.print_bobo

def to_snake_case(s)
  # p s.gsub(/([a-z\d])([A-Z])/,'\1_\2')
  p s.gsub(/::/, '/')
     .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
     .gsub(/([a-z\d])([A-Z][a-z])/, '\1_\2')
     .tr('-', '_')
     .downcase
end

a = ["CAMELCase", "CamelCase", "ExtremeCamelCase", "Camel2Case", "Not-Friendly", "Name::SPACE"]

a.each { |s| to_snake_case(s) }
