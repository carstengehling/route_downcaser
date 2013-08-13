require 'test_helper'

class MockApp
  attr_accessor :env

  def call(env)
    @env = env
  end
end

class DowncaseRedirectorTest < ActiveSupport::TestCase
  test "REQUEST_URI path-part is downcased" do
    app = MockApp.new
    env = { 'REQUEST_URI' => "HELLO/WORLD" }
    DowncaseRedirector::DowncaseRedirectorMiddleware.new(app).call(env)

    assert_equal("hello/world", env['REQUEST_URI'])
  end

  test "REQUEST_URI querystring parameters are not touched" do
    app = MockApp.new
    env = { 'REQUEST_URI' => "HELLO/WORLD?FOO=BAR" }
    DowncaseRedirector::DowncaseRedirectorMiddleware.new(app).call(env)

    assert_equal("hello/world?FOO=BAR", env['REQUEST_URI'])
  end

  test "entire PATH_INFO is downcased" do
    app = MockApp.new
    env = { 'PATH_INFO' => "HELLO/WORLD" }
    DowncaseRedirector::DowncaseRedirectorMiddleware.new(app).call(env)

    assert_equal("hello/world", env['PATH_INFO'])
  end

  test "asset filenames are not touched" do
    app = MockApp.new
    env = { 'PATH_INFO' => "/ASSETS/IMAges/SpaceCat.jpeg" }
    DowncaseRedirector::DowncaseRedirectorMiddleware.new(app).call(env)
    assert_equal("/assets/images/SpaceCat.jpeg", env['PATH_INFO'])
  end
end
