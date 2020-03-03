# frozen_string_literal: true

module GeoHex
  # A Unit is a class of Zones. It has a `level`, `width`, `height` and
  # overall `size`. Dimensions vary for different levels.
  class Unit
    class << self
      private :new # rubocop:disable Style/AccessModifierDeclarations

      # @return [Boolean] true if unit caching is enabled, defaults to false
      def cache?
        @cache == true
      end

      # @param [Boolean] value set to true to enable caching (recommended)
      attr_writer :cache

      # @return [Hash] cache store
      def store
        @store ||= {}
      end

      # @param [Integer] level
      # @return [GeoHex::Unit] for the given level
      def [](level)
        cache? ? store[level] ||= new(level) : new(level)
      end
    end

    attr_reader :level

    # @param [Integer] level
    def initialize(level)
      @level = level
    end

    # @return [Float] unit's mercator size
    def size
      @size ||= H_BASE / 3**(level + 3)
    end

    # @return [Float] unit's mercator width
    def width
      @width ||= 6.0 * size
    end

    # @return [Float] unit's mercator height
    def height
      @height ||= width * H_K
    end
  end
end
