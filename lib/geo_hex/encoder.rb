module GeoHex

  # GeoHex Encoder
  # @see GeoHex::Encoder.encode
  class Encoder

    # @param [Float] lat the latitude
    # @param [Float] lon the longitude
    # @param [Integer] level the level
    # @return [GeoHex::Zone] the encoded zone
    def self.encode(lat, lon, level = 7)
      new(lat, lon, level).zone
    end

    # @param [Float] lat the latitude
    # @param [Float] lon the longitude
    # @param [Integer] level the level
    def initialize(lat, lon, level)
      @level = level
      size   = Zone.size(level+2)
      unit_x = 6.0 * size
      unit_y = 6.0 * size * H_K

      xy   = LL.new(lat, lon).to_xy
      h_x  = (xy.x + xy.y / H_K) / unit_x
      h_y  = (xy.y - H_K * xy.x) / unit_y
      @pos = XY.normalize h_x, h_y

      h_lat = (H_K * @pos.x * unit_x + @pos.y * unit_y) / 2.0
      h_lon = (h_lat - @pos.y * unit_y) / H_K
      @ll   = XY.new(h_lon, h_lat).to_ll

      if H_BASE - h_lon < size
        @ll.lon = 180
        @pos.invert!
      end
    end

    # @return [GeoHex::Zone] the encoded zone
    def zone
      Zone.new @ll, @pos, code
    end

    # @return [String] the GeoHex code
    def code
      string, mod_x, mod_y = "", @pos.x, @pos.y

      (0..@level+2).reverse_each do |i|
        pow = 3 ** i
        p2c = (pow / 2.0).ceil

        c3_x = if mod_x >= p2c
          mod_x -= pow
          2
        elsif mod_x <= -p2c
          mod_x += pow
          0
        else
          1
        end

        c3_y = if mod_y >= p2c
          mod_y -= pow
          2
        elsif mod_y <= -p2c
          mod_y += pow
          0
        else
          1
        end

        string << Integer([c3_x, c3_y].join, 3).to_s
      end

      number = string[0..2].to_i
      H_KEY[number / 30] + H_KEY[number % 30] + string[3..-1]
    end

  end
end
