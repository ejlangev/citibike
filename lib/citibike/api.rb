# encoding: UTF-8

module Citibike

  # Base class for shared behavior between
  # all types of objects from this api
  class Api

    Dir[File.expand_path('../apis/*.rb', __FILE__)].each { |f| require f }

    # Radius of the earth in miles
    EARTH_RADIUS = 3963.1676

    attr_reader :internal_object

    def initialize(data)
      @internal_object = data
    end

    #
    # Shortcut to access latitude
    #
    # @return [Float] [Object's latitude position]
    def lat
      self['latitude']
    end

    #
    # Shortcut to access longitude
    #
    # @return [Float] [Object's longitude position]
    def long
      self['longitude']
    end

    #
    # Returns the distance this object is from the given
    # latitude and longitude.  Distance is as the crow flies.
    #
    # @param  lat [Float] [A latitude position]
    # @param  long [Float] [A longitude position]
    #
    # @return [Float] [Distance from the input postion in miles]
    def distance_from(lat, long)
      dLat = self.degrees_to_radians(lat - self.latitude)
      dLon = self.degrees_to_radians(long - self.longitude)

      lat1 = self.degrees_to_radians(lat)
      lat2 = self.degrees_to_radians(self.latitude)

      a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
          Math.sin(dLon / 2) * Math.sin(dLon / 2) *
          Math.cos(lat1) * Math.cos(lat2)

      c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))

      EARTH_RADIUS * c
    end

    # Allow access to the hash through the object
    def [](key)
      self.internal_object[key.to_s]
    end

    # Allow hash keys to be used as methods
    def method_missing(sym, *args, &block)
      if self.internal_object.key?(sym.to_s)
        return self.internal_object[sym.to_s]
      end

      super
    end

    protected

    def degrees_to_radians(deg)
      deg * Math::PI / 180
    end

  end

end