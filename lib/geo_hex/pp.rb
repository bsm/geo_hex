module GeoHex

  # Mercator projection point
  class PP < Struct.new(:easting, :northing)

    # @return [Float] longitude
    def lon
      @lon ||= LL.normalize(easting / H_BASE * 180.0)
    end

    # @return [Float] latitude
    def lat
      @lat ||= 180.0 / Math::PI * (2 * Math.atan(Math.exp(northing / H_BASE * 180.0 * H_D2R)) - Math::PI / 2.0)
    end

    # @return [GeoHex::LL] lat/lon coordinates
    def to_ll
      LL.new(lat, lon)
    end

    # Converts point coordinates into a Zone for a given `level`
    # @param [Integer] level the level
    # @return [GeoHex::Zone] the zone
    def to_zone(level)
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

      Zone.new(xn, yn, level)
    end

  end

end