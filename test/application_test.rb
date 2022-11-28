require_relative 'test_helper'

class TestController < Feet::Controller
  def index
    "Hello!" # This is not rendering a view
  end
end

class TestApp < Feet::Application
  def get_controller_and_action(env)
    [TestController, "index"]
  end
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
    assert body['Hello']
  end

  def test_path
    get '/path'

    assert !last_response.ok?
    p last_response
  end

  def test_all_strings
    assert [1, '', nil].all_strings? == false
  end
end