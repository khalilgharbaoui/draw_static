require 'minitest/autorun'
require 'rails'
require 'draw_static'
require_relative 'draw_static_tests_controller'

class DrawStaticTest < Minitest::Test
  def test_route_from_action
    assert_equal "my-home-page", StaticRoutes.route_from_action("my_home_page")
    assert_equal "hyphenized-pages-are-great", StaticRoutes.route_from_action("hyphenized2pages$are(great")
    assert_equal "iFcknLove-hyphens", StaticRoutes.route_from_action("iFcknLove9hyphens")
  end

  def test_controller_from_action
    assert_equal DrawStaticTestsController, StaticRoutes.controller_from_chars(:draw_static_tests)
  end

  module DrawStaticTestApp
    # Creating a rails app for testing.
    class Application < Rails::Application
    end
  end

  def test_draw_static
    Rails.application.routes.draw do
      draw_static :draw_static_tests
    end
    assert_equal Rails.application.routes.set.count, 4
    test_if_router_includes_tests_controller_actions
  end

  private

  def test_if_router_includes_tests_controller_actions
    Rails.application.routes.set.each do |route|
      assert_includes DrawStaticTestsController.instance_methods(false), route.name.to_sym
    end
  end
end