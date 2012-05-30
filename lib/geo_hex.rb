require 'geo_hex/version'
require 'geo_hex/ll'
require 'geo_hex/tile'
require 'geo_hex/zone'
require 'geo_hex/unit'
require 'geo_hex/encoder'
require 'geo_hex/decoder'

module GeoHex
  H_KEY  = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz".freeze
  H_BASE = 20037508.34
  H_D2R  = Math::PI / 180.0
  H_DEG  = H_D2R * 30
  H_K    = Math.tan(H_DEG)

  # @see GeoHex::Encoder.encode
  def self.encode(*args)
    Encoder.encode(*args)
  end

  # @see GeoHex::Decoder.decode
  def self.decode(*args)
    Decoder.decode(*args)
  end

end
