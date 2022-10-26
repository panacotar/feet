require_relative 'test_helper'

class TestNamespace < Namespace
end

class FeetTestUtils < Minitest::Test
  include Rack::Test::Methods

  def namespace_util
    TestNamespace.new
  end

  def test_namespace
    namespace = namespace_util

    assert namespace.to_snake_case('CamelCase') == 'camel_case'
    assert namespace.to_snake_case('Camel2Case') == 'camel2_case'
    assert namespace.to_snake_case('CAMEL2Case') == 'camel2_case'
    assert namespace.to_snake_case('Subdirectory::Case') == 'subdirectory/case'
  end
end