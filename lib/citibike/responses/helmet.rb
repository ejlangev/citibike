# encoding: UTF-8

module Citibike

  module Responses
    # Represents a list of Helmet API objects
    class Helmet < Citibike::Response

      def initialize(data)
        data['results'].map! { |r| Citibike::Helmet.new(r) }
        super
      end

    end

  end

end