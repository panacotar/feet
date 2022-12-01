require_relative 'test_helper'

class FeetTestUtils < Minitest::Test
  include Rack::Test::Methods

  def test_namespace
    assert Feet.to_snake_case('CamelCase') == 'camel_case'
    assert Feet.to_snake_case('Camel2Case') == 'camel2_case'
    assert Feet.to_snake_case('CAMEL2Case') == 'camel2_case'
    assert Feet.to_snake_case('Subdirectory::Case') == 'subdirectory/case'
  end
end
