# frozen_string_literal: true

require 'bundler/setup'
require 'geo_hex'
require 'benchmark'

GeoHex::Unit.cache = true

module GeoHex
  class BM
    def initialize(cycles, *args, &block)
      Benchmark.bm(args.shift || 20) do |benchmark|
        @cycles    = cycles
        @benchmark = benchmark
        instance_eval(&block)
      end
    end

    def report(message, &block)
      @benchmark.report(message) { @cycles.times(&block) }
    end
  end
end
