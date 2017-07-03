require_relative 'spec_helper'

require 'rack/test'
ENV['RACK_ENV'] = 'test'

module DeliveryCenterWepAppTesting
  include Rack::Test::Methods

  def app
    DeliveryCenter::App
  end
end

RSpec.configure { |c| c.include DeliveryCenterWepAppTesting }
