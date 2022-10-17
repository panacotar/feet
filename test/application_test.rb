require_relative 'test_helper'

class TestApp < Feet::Application
end

class FeetTestApp < Minitest::Test
  include Rack::Test::Methods

  def app
    TestApp.new
  end

  def test_request
    get '/'

    assert last_response.ok?
    body = last_response.body
    p body
    p last_response
    assert body['Hello']
  end
