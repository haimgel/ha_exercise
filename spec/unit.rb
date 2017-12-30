
require_relative 'spec_helper'
require_relative '../config/environment'
Dir['./models/**/*.rb'].each { |rb| require rb }

# TODO: Scaffold some data, put real tests here

describe Device do

  before do
    @device = Device[1]
  end

  it 'should have correct controls' do
    @device.controls.length.must_equal 3
    @device.controls[0].name.must_equal 'Power'
  end

end
