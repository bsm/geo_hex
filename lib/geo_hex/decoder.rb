module GeoHex
  module Decoder

    # @param [String] code the GeoHex code
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

      GeoHex::Tile.new(x, y, chars-2).to_zone(code)
    end

  end
end