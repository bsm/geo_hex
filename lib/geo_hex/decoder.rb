module GeoHex
  module Decoder

    # @param [String] code the GeoHex code
    def self.decode(code)
      chars  = code.size
      tile   = GeoHex::Tile.new(0, 0, chars-2)

      string = "#{H_KEY.index(code[0]) * 30 + H_KEY.index(code[1])}#{code[2..-1]}"
      string = string.rjust(chars+1, "0")
      nums   = string.chars.map {|c| c.to_i }
      nums.each_with_index do |num, i|
        pow = 3**(chars-i)
        num = num.to_s(3).to_i

        case (num / 10) when 0 then tile.x -= pow when 2 then tile.x += pow end
        case (num % 10) when 0 then tile.y -= pow when 2 then tile.y += pow end
      end

      Zone.new tile.reset.to_ll, tile, code
    end

  end
end