require_relative 'test_helper'

MATCH_ARGS = {
  plain_match: ['/', 'quotes#index'],
  plain_args_match: ['/:id', 'quotes#index']
}.freeze

class TestApp < Feet::Application
  def controller_and_action
    [TestController, 'index']
  end
end

class TestRoutesObj < Feet::RouteObject; end

class FeetTestRouting < Minitest::Test
  def app
    TestApp.new
  end

  def routes_obj
    TestRoutesObj.new
  end

  def init_routes
    app.route do
      match '', 'quotes#index'
      match 'sub-app', proc { [200, {}, ['Hello, sub-app!']] }
      # default routes
      match ':controller/:id/:action'
      match ':controller/:id', default: { 'action' => 'show' }
      match ':controller', default: { 'action' => 'index' }
    end
  end

  # def test_route
  #   # p routes.instance_variable_get :@rules
  #   routes = init_routes
  #   p routes
  #   assert_kind_of Array, routes.class, 'It should return an Array of rules'
  #   assert routes, 'It should include the @rules instance var'
  # end

  def test_match_plain
    plain_rule = routes_obj.match(*MATCH_ARGS[:plain_match]).first

    assert_equal %i[regexp vars dest options], plain_rule.keys, 'It should contain the necessary keys for rule'
    assert_empty plain_rule[:vars], 'It should have any vars'
    # Regexp /^\/$/
    assert_equal %r{^/$}, plain_rule[:regexp], 'It should return the right regexp'
    assert_equal 'quotes#index', plain_rule[:dest], 'It should return the right destination'

    # Test path with arguments ex: /:id
    plain_args_rule = routes_obj.match(*MATCH_ARGS[:plain_args_match]).first

    refute_empty plain_args_rule[:vars], 'Vars should not be empty'
    assert_equal ['id'], plain_args_rule[:vars], 'Vars should contain the id'
    # Regexp /^\/([a-zA-Z0-9]+)?$/
    assert_equal %r{^/([a-zA-Z0-9]+)?$}, plain_args_rule[:regexp]
  end
end
