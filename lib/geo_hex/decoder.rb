require 'set'

module GeoHex
  class Decoder

    EXCLUSIONS = [1, 2, 5].to_set.freeze

    # @param [String] code the GeoHex code
    def self.decode(code)
      new(code).zone
    end

    # @param [String] code the GeoHex code
    def initialize(code)
      @code  = code
      level  = code.size
      h_size = Zone.size(level)
      unit_x = 6.0 * h_size
      unit_y = 6.0 * h_size * H_K
      @pos   = XY.new(0.0, 0.0)

      chars = "#{H_KEYI[code[0]] * 30 + H_KEYI[code[1]]}#{code[2..-1]}"
      chars = chars.rjust(level+1, "0")
      nums  = chars.chars.map {|c| c.to_i }

      case nums[0]
      when 1, 5
        unless EXCLUSIONS.include?(nums[1]) || EXCLUSIONS.include?(nums[2])
          nums.unshift nums.shift + 2
        end
      end

      nums.each_with_index do |num, i|
        pow = 3 ** (level-i)
        num = num.to_s(3).to_i

        case (num / 10) when 0 then @pos.x -= pow when 2 then @pos.x += pow end
        case (num % 10) when 0 then @pos.y -= pow when 2 then @pos.y += pow end
      end

      h_lat = (H_K * @pos.x * unit_x + @pos.y * unit_y) / 2.0
      h_lon = (h_lat - @pos.y * unit_y) / H_K
      @ll   = XY.new(h_lon, h_lat).to_ll

      if @ll.lon > 180
        @ll.lon -= 360
        @pos.x  -= 3**level
        @pos.y  += 3**level
      elsif @ll.lon < -180
        @ll.lon += 360
        @pos.x  += 3**level
        @pos.y  -= 3**level
      end
    end

    # @return [GeoHex::Zone] the decoded zone
    def zone
      Zone.new @ll, @pos, @code
    end

  end
end