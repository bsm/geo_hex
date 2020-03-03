# frozen_string_literal: true

require 'spec_helper'

describe GeoHex do
  it 'should encode coordinates' do
    expect(described_class.encode(0, 0, 0)).to be_instance_of(GeoHex::Zone)
  end

  it 'should encode correctly' do
    CSV.foreach(File.expand_path('cases.csv', __dir__)) do |lat, lon, level, code|
      lat = lat.to_f
      lon = lon.to_f
      level = level.to_i
      expect(described_class.encode(lat, lon, level).to_s).to eq(code)
    end
  end

  it 'should decode strings' do
    expect(described_class.decode('OY')).to be_instance_of(GeoHex::Zone)
  end

  it 'should decode correctly' do
    CSV.foreach(File.expand_path('cases.csv', __dir__)) do |lat, lon, level, code|
      lat = lat.to_f
      lon = lon.to_f
      level = level.to_i
      zone = GeoHex::LL.new(lat, lon).to_zone(level)

      decoded_zone = described_class.decode(code)
      expect([decoded_zone.to_s, decoded_zone.level, decoded_zone.x, decoded_zone.y]).to eq([code, level, zone.x, zone.y])
      expect(zone.lon).to be_within(180.0).of(0.0)
    end
  end
end
