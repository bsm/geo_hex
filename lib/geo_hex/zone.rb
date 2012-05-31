module GeoHex

  # A positioned instance of a Unit, within a level-grid
  class Zone

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
      meridian_180? ? 180.0 : point.lon
    end

    # @return [Float] the latitude coordinate
    def lat
      point.lat
    end

    # @return [String] GeoHex code
    def code
      @code ||= encode
    end
    alias_method :to_s, :code

    # @return [GeoHex::PP] zone center, point coordinates
    def point
      @point ||= GeoHex::PP.new(easting, northing)
    end

    # @return [<GeoHex::Polygon>] Zone's NE, E, SE, SW, W and NW points
    def polygon
      @polygon ||= GeoHex::Polygon.new(easting, northing, unit.size)
    end

    # @param [Integer] range the number of zones to search within
    # @return [Array<GeoHex::Zone>] the neighbouring zones
    def neighbours(range)
      zones  = []
      x0, xn = x - range, x + range

      x0.upto(xn) do |xi|
        zones << self.class.new(xi, y, level) unless xi == x
      end

      1.upto(range) do |i|
        y+i % 2 == 1 ? xn-=1 : x0+=1

        x0.upto(xn) do |xi|
          zones << self.class.new(xi, y+i, level)
          zones << self.class.new(xi, y-i, level)
        end
      end

      zones
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
        return @meridian_180 if defined?(@meridian_180)
        @meridian_180 = H_BASE - easting < unit.size
      end

  end
end