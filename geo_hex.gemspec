# frozen_string_literal: true

require File.expand_path('lib/geo_hex/version', __dir__)

Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.5.0'
  s.required_rubygems_version = '>= 1.3.6'

  s.name        = 'geo_hex'
  s.summary     = 'GeoHex (V3)'
  s.description = 'Ruby implementation of GeoHex encoding algorithm'
  s.version     = GeoHex::VERSION.dup

  s.authors     = ['Dimitrij Denissenko']
  s.email       = 'dimitrij@blacksquaremedia.com'
  s.homepage    = 'https://github.com/bsm/geo_hex'

  s.require_path = 'lib'
  s.files        = Dir['lib/**/*']

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rspec-its'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rubocop-performance'
end
