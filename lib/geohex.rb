module GeoHex
  VERSION = "3.01".freeze

  H_KEY  = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz".freeze
  H_BASE = 20037508.34
  H_DEG  = Math::PI / 6.0
  H_RAD  = H_BASE / 180.0
  H_K    = Math.tan(H_DEG)
  H_D2R  = Math::PI / 180.0

  # X/Y coordinates
  class XY < Struct.new(:x, :y)

    # @param [Float] x the X coordinate
    # @param [Float] y the Y coordinate
    # @return [GeoHex::XY] a normalized X/Y position
    def self.pos(x, y)
      x0, y0 = x.floor, y.floor
      xq, yq = x - x0, y - y0
      xn, yn = x.round, y.round

      if  yq > -xq + 1
        if yq < 2 * xq && yq > 0.5 * xq
          xn, yn = x0 + 1, y0 + 1
        end
      elsif yq < -xq + 1
        if yq > 2 * xq - 1 && yq < 0.5 * xq + 0.5
          xn, yn = x0, y0
        end
      end

      new(xn, yn)
    end

    # Converts coordinates to Lat/Lon model
    # @return [GeoHex::LL] the coordinates
    def to_ll
      lon, lat = [x, y].map {|i| (i / H_BASE) * 180.0 }
      lat = 180.0 / Math::PI * (2 * Math.atan(Math.exp(lat * H_D2R)) - Math::PI / 2.0)
      LL.new(lat, lon)
    end

    # @return [GeoHex::XY] inverted coordinates (destructive)
    def invert!
      xx = x
      self.x = y
      self.y = xx
      self
    end

  end

  # Lat/Lon coordinates
  class LL < Struct.new(:lat, :lon)

    # Converts coordinates to X/Y model
    # @return [GeoHex::XY] the coordinates
    def to_xy
      x = lon * H_RAD
      y = Math.log(Math.tan((90 + lat) * H_D2R / 2)) / H_D2R * H_RAD
      XY.new(x, y)
    end

  end

  # GeoHex Zone
  class Zone

    # @param [Integer] level
    # @return [Float] zone size for the given `level`
    def self.size(level)
      H_BASE / 3**(level+1)
    end

    # @param [Float] lat the latitude
    # @param [Float] lon the longitude
    # @return [Integer] the zone level
    def self.encode(lat, lon, level = 7)
      h_size = size(level+2)
      unit_x = 6 * h_size.to_f
      unit_y = 6 * h_size * H_K

      z_xy  = GeoHex::LL.new(lat, lon).to_xy
      h_x   = (z_xy.x + z_xy.y / H_K) / unit_x
      h_y   = (z_xy.y - H_K * z_xy.x) / unit_y
      h_pos = GeoHex::XY.pos h_x, h_y

      h_lat = (H_K * h_pos.x * unit_x + h_pos.y * unit_y) / 2.0
      h_lon = (h_lat - h_pos.y * unit_y) / H_K
      z_ll  = GeoHex::XY.new(h_lon, h_lat).to_ll

      if H_BASE - h_lon < h_size
        z_ll.lon = 180
        h_pos.invert!
      end

      new(z_ll, h_pos, level)
    end

    attr_reader :ll, :pos, :level

    # @param [GeoHex::LL] ll lat/lon coordinates
    # @param [GeoHex::Position] pos X/Y position
    # @param [Integer] level the granularity level
    def initialize (ll, pos, level)
      @ll, @pos, @level = ll, pos, level
    end

    # @return [Float] latitude
    def lat
      ll.lat
    end

    # @return [Float] longitude
    def lon
      ll.lon
    end

    # @return [String] geo code
    def code
      @code ||= begin
        string, mod_x, mod_y = "", pos.x, pos.y

        (0..level+2).reverse_each do |i|
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
    alias_method :to_s, :code

  end

end
