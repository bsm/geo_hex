require 'bigdecimal'
require 'geo_hex/version'
require 'geo_hex/ll'
require 'geo_hex/tile'
require 'geo_hex/zone'
require 'geo_hex/unit'
require 'geo_hex/decoder'

module GeoHex
  H_KEY  = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz".freeze
  H_BASE = 20037508.34
  H_D2R  = Math::PI / 180.0
  H_DEG  = H_D2R * 30
  H_K    = Math.tan(H_DEG)

  # @param [Float] lat the latitude
  # @param [Float] lon the longitude
  # @param [Integer] level the level
  # @return [GeoHex::Zone] the encoded zone
  def self.encode(lat, lon, level = 7)
    LL.new(lat, lon).to_tile(level).encode
  end

  # @see GeoHex::Decoder.decode
  def self.decode(*args)
    Decoder.decode(*args)
  end

end
