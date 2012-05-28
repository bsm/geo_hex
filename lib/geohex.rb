module GeoHex
  VERSION = "3.01".freeze
  H_KEY   = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz".freeze
  H_BASE  = 20037508.34
  H_DEG   = Math::PI / 6.0
  H_K     = Math.tan(H_DEG)
  XY      = Struct.new(:x, :y)
  LOC     = Struct.new(:lat, :lon)

  # @param [Float] lat the latitude
  # @param [Float] lon the longitude
  # @return [GeoHex::XY] the coordinates
  def self.loc2xy(lat, lon)
    x  = lon * H_BASE / 180
    y  = Math.log(Math.tan((90 + lat) * Math::PI / 360)) / (Math::PI / 180)
    y *= H_BASE / 180
    XY.new(x, y)
  end

  # @param [Integer] x the x coordinate
  # @param [Integer] y the y coordinate
  # @return [GeoHex::LOC] the location
  def self.xy2loc(x, y)
    lon, lat = [x, y].map {|i| (i / H_BASE) * 180 }
    lat = 180 / Math::PI * (2 * Math.atan(Math.exp(lat * Math::PI / 180)) - Math::PI / 2)
    LOC.new(lat, lon)
  end

  class Zone < String

    # @param [Integer] level
    # @return [Float] zone size for the given `level`
    def self.size(level)
      H_BASE / 3**(level+1)
    end

    # @param [Float] lat the latitude
    # @param [Float] lon the longitude
    # @return [Integer] the zone level
    def self.encode(lat, lon, level = 7)
      level += 2
      h_size = size(level)
      unit_x = 6 * h_size.to_f
      unit_y = 6 * h_size * H_K

      z_xy    = GeoHex.loc2xy(lat, lon)
      h_pos_x = (z_xy.x + z_xy.y / H_K) / unit_x
      h_pos_y = (z_xy.y - H_K * z_xy.x) / unit_y

      h_x_0   = h_pos_x.floor
      h_y_0   = h_pos_y.floor
      h_x_q   = h_pos_x - h_x_0
      h_y_q   = h_pos_y - h_y_0
      h_x     = h_pos_x.round
      h_y     = h_pos_y.round

      if  h_y_q > -h_x_q + 1
        if h_y_q < 2 * h_x_q && h_y_q > 0.5 * h_x_q
          h_x, h_y = h_x_0 + 1, h_y_0 + 1
        end
      elsif h_y_q < -h_x_q + 1
        if h_y_q > 2 * h_x_q - 1 && h_y_q < 0.5 * h_x_q + 0.5
          h_x, h_y = h_x_0, h_y_0
        end
      end

      h_lat = (H_K * h_x * unit_x + h_y * unit_y) / 2.0
      h_lon = (h_lat - h_y * unit_y) / H_K
      z_loc = GeoHex.xy2loc(h_lon, h_lat)

      if H_BASE - h_lon < h_size
        z_loc.lon = 180
        h_xy      = h_x
        h_x       = h_y
        h_y       = h_xy
      end

      mod_x, mod_y = h_x, h_y
      h_code = (0..level).map do |i|
        h_pow = 3 ** (level-i)
        h_p2c = (h_pow / 2.0).ceil

        code3_x = if mod_x >= h_p2c
          mod_x -= h_pow
          2
        elsif mod_x <= -h_p2c
          mod_x += h_pow
          0
        else
          1
        end

        code3_y = if mod_y >= h_p2c
          mod_y -= h_pow
          2
        elsif mod_y <= -h_p2c
          mod_y += h_pow
          0
        else
          1
        end

        Integer([code3_x, code3_y].join, 3)
      end.join

      h_int  = h_code[0..2].to_i
      h_code = H_KEY[h_int / 30] + H_KEY[h_int % 30] + h_code[3..-1]

      new z_loc.lat, z_loc.lon, h_x, h_y, h_code
    end

    attr_reader :lat, :lon, :x, :y, :code

    # @param [Float] lat the latitude
    # @param [Float] lon the longitude
    # @param [Integer] x the x coordinate
    # @param [Integer] y the y coordinate
    # @param [String] code the GeoHex code
    def initialize (lat, lon, x, y, code)
      @lat, @lon, @x, @y = lat, lon, x, y
      super(code)
    end

    # @return [Integer] the zone level
    def level
      size - 2
    end

  end
end
