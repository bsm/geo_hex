# frozen_string_literal: true

require File.expand_path('helper', __dir__)

GeoHex::BM.new(100) do
  zone = GeoHex::Zone.new(5700, 5717, 7)

  report 'Range: 1' do
    zone.neighbours(1)
  end

  report 'Range: 2' do
    zone.neighbours(2)
  end

  report 'Range: 3' do
    zone.neighbours(3)
  end

  report 'Range: 20' do
    zone.neighbours(20)
  end

  report 'Range: 100' do
    zone.neighbours(100)
  end
end
