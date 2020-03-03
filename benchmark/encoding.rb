# frozen_string_literal: true

require File.expand_path('helper', __dir__)

GeoHex::BM.new(100_000) do
  report 'Level 0' do
    GeoHex.encode(51.539212, -0.141748, 0).to_s
  end

  report 'Level 7' do
    GeoHex.encode(51.539212, -0.141748, 7).to_s
  end

  report 'Level 12' do
    GeoHex.encode(51.539212, -0.141748, 12).to_s
  end
end
