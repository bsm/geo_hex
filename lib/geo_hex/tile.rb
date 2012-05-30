module GeoHex

  # A positioned instance of a Unit, within a level-grid
  class Tile < Struct.new(:x, :y)

    # @param [Float] the mercator easting
    # @param [Float] the mercator northing
    # @param [Integer] level the level
    # @return [GeoHex::Tile] a normalized, positioned tile
    def self.normalize(easting, northing, level)
      u = Unit[level]
      x = (easting + northing / H_K) / u.width
      y = (northing - H_K * easting) / u.height

      x0, y0 = x.floor, y.floor
      xq, yq = x - x0, y - y0
      xn, yn = x.round, y.round

      if yq > -xq + 1
        if yq < 2 * xq && yq > 0.5 * xq
          xn, yn = x0 + 1, y0 + 1
        end
      elsif yq < -xq + 1
        if yq > 2 * xq - 1 && yq < 0.5 * xq + 0.5
          xn, yn = x0, y0
        end
      end

      new(xn, yn, level)
    end

    attr_reader :unit

    # @param [Integer] x the horizontal index
    # @param [Integer] y the vertical index
    # @param [Integer] level the level
    def initialize(x, y, level)
      @unit = Unit[level]
      super(x, y)
      self.x, self.y = y, x if meridian_180?
    end

    # @return [Integer] the level
    def level
      unit.level
    end

    # @return [Boolean] true if the tile is placed on the 180th meridian
    def meridian_180?
      H_BASE - easting < unit.size
    end

    # @return [Float] the mercator easting
    def easting
      @easting ||= (northing - y * unit.height) / H_K
    end

    # @return [Float] the mercator northing
    def northing
      @northing ||= (H_K * x * unit.width + y * unit.height) / 2.0
    end

    # @return [GeoHex::LL] the lat/lon coordinates
    def to_ll
      lon = meridian_180? ? 180.0 : easting / H_BASE * 180.0
      lat = northing / H_BASE * 180.0
      lat = 180.0 / Math::PI * (2 * Math.atan(Math.exp(lat * H_D2R)) - Math::PI / 2.0)
      LL.new(lat, lon)
    end

    # @return [GeoHex::Zone] GeoHex zone
    def encode
      code, mod_x, mod_y = "", self.x, self.y

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

        code << Integer([c3_x, c3_y].join, 3).to_s
      end

      number = code[0..2].to_i
      code   = H_KEY[number / 30] + H_KEY[number % 30] + code[3..-1]

      Zone.new to_ll, self, code
    end

  end
end