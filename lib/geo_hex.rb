require 'geo_hex/version'
require 'geo_hex/structs'
require 'geo_hex/zone'
require 'geo_hex/encoder'
require 'geo_hex/decoder'

module GeoHex
  H_KEY  = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz".freeze
  H_KEYI = H_KEY.chars.inject({}) {|r, c| r.merge c => H_KEY.index(c) }.freeze
  H_BASE = 20037508.34
  H_DEG  = Math::PI / 6.0
  H_RAD  = H_BASE / 180.0
  H_K    = Math.tan(H_DEG)
  H_D2R  = Math::PI / 180.0

  # @see GeoHex::Encoder.encode
  def self.encode(*args)
    Encoder.encode(*args)
  end

  # @see GeoHex::Decoder.decode
  def self.decode(*args)
    Decoder.decode(*args)
  end

end
