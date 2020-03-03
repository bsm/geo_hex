# frozen_string_literal: true

module GeoHex
  # Lat/Lon coordinates
  class LL
    # @return [Float] longitude
    def self.normalize(lon)
      if lon < -180
        lon + 360
      elsif lon > 180
        lon - 360
      else
        lon
      end
    end

    attr_reader :lat, :lon

    # @param [Float] lat the latitude
    # @param [Float] lon the longitude
    def initialize(lat, lon)
      @lat = lat
      @lon = self.class.normalize(lon)
    end

    # @return [Float] mercator easting
    def easting
      @easting ||= lon * H_BASE / 180.0
    end

    # @return [Float] mercator northing
    def northing
      @northing ||= Math.log(Math.tan((90 + lat) * H_D2R / 2)) / Math::PI * H_BASE
    end

    # @return [GeoHex::PP] the full projection point coordinates
    def to_pp
      GeoHex::PP.new(easting, northing)
    end

    # Converts coordinates to Zone
    # @param [Integer] level the level
    # @return [GeoHex::Zone] the coordinates
    def to_zone(level)
      to_pp.to_zone(level)
    end

    # @param [GeoHex::PP] other coordinates
    # @return [Float] distance in meters
    def distance_to(other)
      d_lat = (other.lat - lat) * H_D2R / 2.0
      d_lon = (other.lon - lon) * H_D2R / 2.0
      lat1 = lat * H_D2R
      lat2 = other.lat * H_D2R

      a = Math.sin(d_lat)**2 +
          Math.sin(d_lon)**2 * Math.cos(lat1) * Math.cos(lat2)
      c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))

      H_ER * c
    end
  end
end
