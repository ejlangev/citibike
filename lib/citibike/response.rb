# encoding: UTF-8

module Citibike

  # Base class that defines the shared behavior for
  # all the different response types
  class Response

    include Enumerable

    Dir[File.expand_path('../responses/*.rb', __FILE__)].each { |f| require f }

    # allow direct access to the data stored in this object
    attr_reader :data, :success, :last_update

    # undefine methods from this class so they get proxied to data
    undef_method :to_s, :inspect

    # Initializes a Response object
    # @param  data [Hash] [Response data from an api request]
    #
    # @return [Nil] [This return value is ignored]
    def initialize(data)
      @data = data['results']
      @success = data['ok']
      @last_update = Time.at(data['last_updated'].to_i)

      # build the id_hash
      @id_hash ||= {}
      @data.each do |d|
        @id_hash[d.id] = d
      end
    end

    # each provided to include enumberable
    # @param  &block [Block] [For enumerable]
    #
    # @return [Enumerable] [Another enumerable]
    def each(&block)
      self.data.each(&block)
    end

    #
    # Clones this object and populates
    # @param  data [Array] [Array of API objects]
    #
    # @return [Response] [A clone of self wrapping data]
    def clone_with(data)
      clone = self.clone
      clone.instance_variable_set(:@data, data)
      clone
    end

    #
    # Finds the given object by id using a hash for a shortcut
    # @param  id [Integer] [The id to lookup]
    #
    # @return [Citibike::Api] [Some type of API object e.g Helmet or Station]
    def find_by_id(id)
      id = id.to_i

      @id_hash[id]
    end

    def find_by_ids(*ids)
      ids.map { |i| self.find_by_id(i) }.compact
    end

    #
    # Returns every object within dist (miles)
    # of lat/long
    #
    # @param  lat [Float] [A latitude position]
    # @param  long [Float] [A longitude position]
    # @param  dist [Float] [A radius in miles]
    #
    # @return [Array] [Array of objects within dist of lat/long]
    def all_within(lat, long, dist)
      @data.select { |d| d.distance_from(lat, long) < dist }
    end

    #
    # Returns every object within dist miles
    # of obj
    #
    # @param  obj [Api] [Api Object]
    # @param  dist [Float] [Distance to consider]
    #
    # @return [type] [description]
    def all_near(obj, dist)
      @data.select do |d|
        false if d.id == obj.id
        d.distance_from(obj.latitude, obj.longitude) < dist
      end
    end

    # Delegates any undefined methods to the underlying data
    def method_missing(sym, *args, &block)
      if self.data.respond_to?(sym)
        return self.data.send(sym, *args, &block)
      end

      super
    end

  end

end