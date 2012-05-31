module GeoHex

  # A positioned instance of a Unit, within a level-grid
  class Zone

    # @param [Float] the mercator easting
    # @param [Float] the mercator northing
    # @param [Integer] level the level
    # @return [GeoHex::Zone] a normalized, positioned zone
    def self.normalize(easting, northing, level)
      u = Unit[level]
      x = (easting + northing / H_K) / u.width
      y = (northing - H_K * easting) / u.height

      x0, y0 = x.floor, y.floor
      xq, yq = x - x0, y - y0
      xn, yn = if yq > -xq + 1 && yq < 2 * xq && yq > 0.5 * xq
        [x0 + 1, y0 + 1]
      elsif yq < -xq + 1 && yq > 2 * xq - 1 && yq < 0.5 * xq + 0.5
        [x0, y0]
      else
        [x.round, y.round]
      end

      new(xn, yn, level)
    end

    # @return [Integer] the zone coordinates within the grid
    attr_reader :x, :y

    # @return [GeoHex::Unit] the associated unit
    attr_reader :unit

    # @return [Float] the mercator northing
    attr_reader :northing

    # @return [Float] the mercator easting
    attr_reader :easting

    # @param [Integer] x the horizontal index
    # @param [Integer] y the vertical index
    # @param [Integer] level the level
    def initialize(x, y, level)
      @x, @y    = x, y
      @unit     = Unit[level]
      @northing = (H_K * @x * @unit.width + @y * @unit.height) / 2.0
      @easting  = (@northing - @y * @unit.height) / H_K
      @x, @y    = @y, @x if meridian_180?
    end

    # @return [Integer] the level
    def level
      unit.level
    end

    # @return [Float] the longitude coordinate
    def lon
      @lon ||= LL.normalize(meridian_180? ? 180.0 : easting / H_BASE * 180.0)
    end

    # @return [Float] the latitude coordinate
    def lat
      @lat ||= 180.0 / Math::PI * (2 * Math.atan(Math.exp(northing / H_BASE * 180.0 * H_D2R)) - Math::PI / 2.0)
    end

    # @return [String] GeoHex code
    def code
      @code ||= encode
    end
    alias_method :to_s, :code

    # @param [Integer] radius the number of zones to search within
    # @return [Array<GeoHex::Zone>] the neighbouring zones
    def neighbours(radius)
      []
    end
    alias_method :neighbors, :neighbours

    # @param [Zone, String] other another Zone or a GeoHex code (String)
    # @return [Boolean] true, if given Zone or GeoHex code (String) matches self
    def ==(other)
      case other
      when String
        to_s == other
      when self.class
        x == other.x && y == other.y && level == other.level
      else
        super
      end
    end
    alias_method :eql?, :==

    # @return [Fixnum] the object hash
    def hash
      [x, y, level].hash
    end

    protected

      # @param [String] code the GeoHex code
      # @return [GeoHex::Zone] GeoHex zone
      def with_code(code)
        @code = code
        self
      end

    private

      # @return [String] GeoHex code
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
        "#{H_KEY[number / 30]}#{H_KEY[number % 30]}#{code[3..-1]}"
      end

      # @return [Boolean] true if the zone is placed on the 180th meridian
      def meridian_180?
        H_BASE - easting < unit.size
      end

  end
end