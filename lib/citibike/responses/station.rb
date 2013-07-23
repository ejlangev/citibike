# encoding: UTF-8

module Citibike

  module Responses
    # Represents a list of Station api objects
    class Station < Citibike::Response

      def initialize(data)
        data['results'].map! { |r| Citibike::Station.new(r) }
        super
      end

    end

  end

end