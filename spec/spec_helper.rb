unless ENV['CI']
  require 'simplecov'

  SimpleCov.start do
    add_filter 'spec'
    add_filter '.bundle'
  end
end

require 'venice'
require 'rspec'
require 'rspec/its'
require 'webmock/rspec'

WebMock.disable_net_connect!

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.yield_receiver_to_any_instance_implementation_blocks = false
  end
end
