module GeoHex
  module Decoder

    EXCLUSIONS = [1, 2, 5].to_set.freeze

    # @param [String] code the GeoHex code
    def self.decode(code)
      chars  = code.size
      tile   = GeoHex::Tile.new(0, 0, chars-2)

      string = "#{H_KEY.index(code[0]) * 30 + H_KEY.index(code[1])}#{code[2..-1]}"
      string = string.rjust(chars+1, "0")
      nums   = string.chars.map {|c| c.to_i }

      case nums[0]
      when 1, 5
        unless EXCLUSIONS.include?(nums[1]) || EXCLUSIONS.include?(nums[2])
          nums.unshift nums.shift + 2
        end
      end

      nums.each_with_index do |num, i|
        pow = 3**(tile.level-i)
        num = num.to_s(3).to_i

        case (num / 10) when 0 then tile.x -= pow when 2 then tile.x += pow end
        case (num % 10) when 0 then tile.y -= pow when 2 then tile.y += pow end
      end

      ll = tile.to_ll
      if ll.lon > 180
        ll.lon -= 360
        tile.x -= 3**tile.level
        tile.y += 3**tile.level
      elsif ll.lon < -180
        ll.lon += 360
        tile.x += 3**tile.level
        tile.y -= 3**tile.level
      end

      Zone.new ll, tile, code
    end

  end
end