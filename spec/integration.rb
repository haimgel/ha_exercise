
require 'capybara'
require 'capybara/dsl'
require 'rack/test'
require 'rack/unreloader'
require_relative 'spec_helper'

Unreloader = Rack::Unreloader.new(reload: false)

require_relative('../ha_exercise')

Capybara.app = App.app
App.plugin :error_handler do |e|
  raise e
end

App.freeze

class Minitest::HooksSpec
  include Rack::Test::Methods
  include Capybara::DSL

  def app
    App
  end

  # TODO: These tests are woefully inadequate to properly test the application, they are just a start.

  describe 'MobileApp' do

    specify 'display a list of devices' do
      visit('/')
      page.current_path.must_equal('/devices')
      page.all('a.ui.button.huge').map(&:text).must_equal(['Bedroom Apple TV', 'Livingroom Player', 'Livingroom Lights'])
    end

    specify 'display one device and its power button' do
      visit('/devices/1')
      page.current_path.must_equal('/devices/1')
      page.find('button.ui.primary').text.must_equal('Power')
    end

  end

  describe 'AdminApp' do

    specify 'display a list of devices' do
      visit('/admin/devices')
      page.current_path.must_equal('/admin/devices')
      page.all('.item .left.content a').map(&:text).must_equal(['Bedroom Apple TV', 'Livingroom Player', 'Livingroom Lights'])
    end

    specify 'display a list of device types' do
      visit('/admin/device_types')
      page.current_path.must_equal('/admin/device_types')
      page.all('.item .left.content').map(&:text).must_equal(['Samsung Audio', 'Sony Audio', 'Apple TV', 'Citrus Lights'])
    end

  end

end
