ENV['RACK_ENV'] = 'test'

require 'rspec'
require 'factory_girl'
require 'delivery_center'
require 'database_rewinder'
require "rspec/json_matcher"

FactoryGirl.define do
  factory :application, class: 'DeliveryCenter::Application' do
    sequence(:name) { |i| "deploy-application-#{i}" }
  end

  factory :deploy, class: 'DeliveryCenter::Deploy' do
    association :application
    association :revision
    current { false }
  end

  factory :revision, class: 'DeliveryCenter::Revision' do
    association :application
    value { Digest::SHA1.hexdigest(rand(64).to_s) }
  end

  factory :api_key, class: 'DeliveryCenter::ApiKey' do
    sequence(:title) { |i| "deploy bot #{i}" }
    sequence(:description) { |i| "deploy bot #{i}" }
    value { Digest::SHA256.hexdigest(rand(64).to_s) }
  end
end

RSpec.configure { |c| c.include FactoryGirl::Syntax::Methods }

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include RSpec::JsonMatcher

  config.before(:suite) do
    DatabaseRewinder.database_configuration = { 'test' => DeliveryCenter.database_config }
    DatabaseRewinder.clean_all
  end

  config.after(:each) do
    DatabaseRewinder.clean
  end
end
