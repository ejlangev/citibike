# encoding: UTF-8

module Citibike
  # Represents a Station in the Citibike system and
  # holds the data provided from the API itself along with
  # some convenience methods accessing it
  class Station < Api

    def self.path
      'data2/stations.php'
    end
    #
    # Returns if this station is active
    #
    # @return [Bool] [Stations is active or not]
    def active?
      self.internal_object['status'] == 'Active'
    end

    #
    # Returns the number of available bikes at this station
    #
    # @return [Integer] [Number of available bikes]
    def available_bikes
      self['availableBikes']
    end

    #
    # Returns the number of available docks at this station
    #
    # @return [Integer] [Number of available docks]
    def available_docks
      self['availableDocks']
    end

    #
    # Returns the address of the station
    #
    # @return [String] [Address of the station]
    def station_address
      self['stationAddress']
    end

    #
    # Nearby station array of hashes of the form
    # [
    #   {
    #     :id => Integer,
    #     :distance => Float
    #   },
    #   ...
    # ]
    #
    # @return [Array] [Array of hashes of nearby stations]
    def nearby_stations
      self['nearbyStations']
    end

    #
    # Returns the ids of nearby stations for
    # easy lookup in a Citibike::Responses::Station object
    #
    # @return [Array] [Array of integer ids]
    def nearby_station_ids
      @nearby_station_ids ||= self.nearby_stations.map { |s| s['id'] }
    end

    #
    # Returns the distance to a nearby station (in miles?)
    # @param  id [Integer] [Id of a nearby station]
    #
    # @return [Float] [Distance to nearby station in miles]
    def distance_to_nearby(id)
      unless self.nearby_station_ids.include?(id.to_i)
        raise "Station #{id} is not a nearby station"
      end

      sta = self.nearby_stations.find { |s| s['id'].to_i == id.to_i }
      sta['distance']
    end
  end

end