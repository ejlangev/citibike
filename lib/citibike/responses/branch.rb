# encoding: UTF-8

module Citibike
  # Namespace for different response objects
  # representing a list of api objects
  module Responses
    # Represents a list of Branch API objects
    class Branch < Citibike::Response

      #
      # Transforms part of the input hash to the proper
      # type of object.  Expects the keys:
      # {
      #   :data => [{...}, {...}],
      #   :ok => true/false,
      #   :last_updated => Time
      # }
      #
      # @param  data [Hash] [A hash from the Citibike API]
      #
      # @return [nil] [Not used]
      def initialize(data = {})
        data['results'].map! { |r| Citibike::Branch.new(r) }
        super
      end

    end

  end

end