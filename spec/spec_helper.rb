require 'csv'
require 'rspec'
require 'rspec/its'
require 'geo_hex'

GeoHex::Unit.cache = true

RSpec.configure do |c|
  c.expect_with :rspec do |c|
    c.syntax = [:expect, :should]
  end
  c.mock_with :rspec do |c|
    c.syntax = [:expect, :should]
  end
end
