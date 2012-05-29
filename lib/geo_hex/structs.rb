module GeoHex

  # X/Y coordinates
  class XY < Struct.new(:x, :y)

    # @param [Float] x the X coordinate
    # @param [Float] y the Y coordinate
    # @return [GeoHex::XY] a normalized X/Y position
    def self.normalize(x, y)
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

end