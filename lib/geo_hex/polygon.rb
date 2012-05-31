module GeoHex

  class Polygon < Struct.new(:easting, :northing, :size)

    # @return [GeoHex::PP] The Northeast point of the Zone
    def north_east_point
      @north_east_point ||= PP.new(east, north)
    end
    alias_method :ne, :north_east_point

    # @return [GeoHex::PP] The East point of the Zone
    def east_point
      @east_point ||= PP.new(easting + 2 * size, northing)
    end
    alias_method :e, :east_point

    # @return [GeoHex::PP] The Southeast point of the Zone
    def south_east_point
      @south_east_point ||= PP.new(east, south)
    end
    alias_method :se, :south_east_point

    # @return [GeoHex::PP] The Southwest point of the Zone
    def south_west_point
      @south_west_point ||= PP.new(west, south)
    end
    alias_method :sw, :south_west_point

    # @return [GeoHex::PP] The West point of the Zone
    def west_point
      @west_point ||= PP.new(easting - 2 * size, northing)
    end
    alias_method :w, :west_point

    # @return [GeoHex::PP] The Northwest point of the Zone
    def north_west_point
      @north_west_point ||= PP.new(west, north)
    end
    alias_method :nw, :north_west_point

    # @return [Array<GeoHex::PP>] All the points of the Zone, ordered from Northeast round to Northwest
    def points
      @points ||= [ne, e, se, sw, w, nw]
    end

    private

      # @return [Float] The northing of the Northern boundary of the Zone
      def north
        @north ||= northing + H_DEG * size
      end

      # @return [Float] The easting of both Eastern corners of the Zone
      def east
        @east ||= easting + size
      end
      
      # @return [Float] The northing of the Southern boundary of the Zone
      def south
        @north ||= northing - H_DEG * size
      end

      # @return [Float] The easting of both Western corners of the Zone
      def west
        @west ||= easting - size
      end

  end

end