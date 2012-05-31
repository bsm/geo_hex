module GeoHex

  class Polygon < Struct.new(:easting, :northing, :size)
    H_K = Math.tan(Math::PI / 180.0 * 60)

    # @return [GeoHex::PP] The Northeast point of the Zone
    def north_east
      @north_east ||= PP.new(east_bound, north_bound)
    end
    alias_method :ne, :north_east

    # @return [GeoHex::PP] The East point of the Zone
    def east
      @east ||= PP.new(easting + 2 * size, northing)
    end
    alias_method :e, :east

    # @return [GeoHex::PP] The Southeast point of the Zone
    def south_east
      @south_east ||= PP.new(east_bound, south_bound)
    end
    alias_method :se, :south_east

    # @return [GeoHex::PP] The Southwest point of the Zone
    def south_west
      @south_west ||= PP.new(west_bound, south_bound)
    end
    alias_method :sw, :south_west

    # @return [GeoHex::PP] The West point of the Zone
    def west
      @west ||= PP.new(easting - 2 * size, northing)
    end
    alias_method :w, :west

    # @return [GeoHex::PP] The Northwest point of the Zone
    def north_west
      @north_west ||= PP.new(west_bound, north_bound)
    end
    alias_method :nw, :north_west

    # @return [Array<GeoHex::PP>] All the points of the Zone, ordered from Northeast round to Northwest
    def points
      @points ||= [ne, e, se, sw, w, nw]
    end
    alias_method :to_a, :points

    private

      # @return [Float] The northing of the Northern boundary of the Zone
      def north_bound
        @north_bound ||= northing + H_K * size
      end

      # @return [Float] The easting of both Eastern corners of the Zone
      def east_bound
        @east_bound ||= easting + size
      end

      # @return [Float] The northing of the Southern boundary of the Zone
      def south_bound
        @south_bound ||= northing - H_K * size
      end

      # @return [Float] The easting of both Western corners of the Zone
      def west_bound
        @west_bound  ||= easting - size
      end

  end

end