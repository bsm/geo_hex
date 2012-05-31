require 'bigdecimal'
require 'geo_hex/version'
require 'geo_hex/ll'
require 'geo_hex/zone'
require 'geo_hex/unit'

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
    LL.new(lat, lon).to_zone(level)
  end

  # @param [String] code the GeoHex code
  # @return [GeoHex::Zone] the decoded zone
  def self.decode(code)
    x, y   = 0, 0
    chars  = code.size
    string = "#{H_KEY.index(code[0]) * 30 + H_KEY.index(code[1])}#{code[2..-1]}"
    string = string.rjust(chars+1, "0")
    nums   = string.chars.map {|c| c.to_i }
    nums.each_with_index do |num, i|
      pow = 3**(chars-i)
      num = num.to_s(3).to_i

      case (num / 10) when 0 then x -= pow when 2 then x += pow end
      case (num % 10) when 0 then y -= pow when 2 then y += pow end
    end

    GeoHex::Zone.new(x, y, chars-2).send(:with_code, code)
  end

end
